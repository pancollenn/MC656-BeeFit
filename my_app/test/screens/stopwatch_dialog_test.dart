import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/stopwatch_dialog.dart';

void main() {
  testWidgets(
      'Teste completo do cronômetro: abrir, pausar, continuar, resetar e fechar',
      (WidgetTester tester) async {
    
    // 1. ARRANGE: Prepara um ambiente limpo apenas para testar o Dialog.
    // REMOVEMOS TrainingPage e MockWorkoutRepository para evitar erros de compilação.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.timer),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const StopwatchDialog(),
              );
            },
          );
        }),
      ),
    ));

    // --- 1. ABRIR ---
    // ACT: Clica no botão para abrir o dialog
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pump(); // Constrói o dialog (Frame 0)

    // ASSERT: Verifica se abriu com o tempo zerado
    expect(find.byType(StopwatchDialog), findsOneWidget);
    expect(find.text('00:00:00'), findsOneWidget);

    // Avança o tempo (pois o relógio roda automático)
    await tester.pump(const Duration(milliseconds: 500));

    // Verifica que o tempo mudou (não é mais 00:00:00)
    expect(find.text('00:00:00'), findsNothing);


    // --- 2. PAUSAR ---
    // ACT: Clica em Pausar
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump(); // Atualiza ícone

    // Busca o texto do tempo usando Regex para garantir que é o relógio
    // Isso evita confundir com o título do Dialog ou outros textos.
    final timeFinder = find.descendant(
      of: find.byType(StopwatchDialog),
      matching: find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data != null) {
          return RegExp(r'\d{2}:\d{2}:\d{2}').hasMatch(widget.data!);
        }
        return false;
      }),
    );

    // Captura o tempo exato onde parou
    final String? pausedTime = (tester.widget(timeFinder) as Text).data;
    
    // ACT: Tenta avançar o tempo
    await tester.pump(const Duration(seconds: 2));

    // ASSERT: Tempo deve ser igual (pausado) e ícone deve ser Play
    expect(find.text(pausedTime!), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);


    // --- 3. CONTINUAR ---
    // ACT: Play
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(); 
    
    // Avança tempo
    await tester.pump(const Duration(seconds: 2));

    // ASSERT: Tempo mudou
    expect(find.text(pausedTime), findsNothing);


    // --- 4. RESETAR ---
    // ACT: Reset
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(); 

    // ASSERT: Volta a zero
    expect(find.text('00:00:00'), findsOneWidget);


    // --- 5. FECHAR ---
    // Garante que está pausado antes de fechar para não dar erro de Timer rodando em background
    if (find.byIcon(Icons.pause).evaluate().isNotEmpty) {
      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();
    }

    // Fecha
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    // Verifica se sumiu da tela
    expect(find.byType(StopwatchDialog), findsNothing);
  });
}