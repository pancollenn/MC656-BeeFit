import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/stopwatch_dialog.dart';

void main() {
  testWidgets(
      'Teste completo do cronômetro: abrir, pausar, continuar, resetar e fechar',
      (WidgetTester tester) async {
    
    // 1. ARRANGE: Prepara o botão para abrir o Dialog
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

    // --- 1. ABRIR E VERIFICAR ---

    // ACT: Clica no botão
    await tester.tap(find.byIcon(Icons.timer));
    await tester.pump(); // Frame inicial

    // ASSERT: Verifica se o diálogo abriu e se o texto inicial é 00:00:00
    // Usamos um Predicate para ter certeza que estamos pegando o texto do relógio (formato XX:XX:XX)
    // ou simplesmente o texto inicial conhecido.
    expect(find.text('00:00:00'), findsOneWidget);

    // Avança o tempo (o relógio roda automático)
    await tester.pump(const Duration(milliseconds: 500));

    // Verifica que o tempo mudou
    expect(find.text('00:00:00'), findsNothing);


    // --- 2. PAUSAR E VERIFICAR SE PAROU ---

    // ACT: Clica em Pausar (Ícone inicial é Pause pois começa rodando)
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump(); // Atualiza ícone

    // [CORREÇÃO CRÍTICA AQUI]
    // Precisamos encontrar o widget de texto do tempo, NÃO o título.
    // Vamos procurar pelo Widget Text que contém números e dois pontos.
    final timeFinder = find.descendant(
      of: find.byType(StopwatchDialog),
      matching: find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data != null) {
          // Verifica se o texto parece um tempo (ex: 00:00:15)
          return RegExp(r'\d{2}:\d{2}:\d{2}').hasMatch(widget.data!);
        }
        return false;
      }),
    );

    // Captura o tempo exato onde paramos
    final String? pausedTime = (tester.widget(timeFinder) as Text).data;
    
    // ACT: Avança 2 segundos com o relógio pausado
    await tester.pump(const Duration(seconds: 2));

    // ASSERT: O texto do tempo deve ser EXATAMENTE o mesmo
    expect(find.text(pausedTime!), findsOneWidget);
    
    // Verifica se o ícone mudou para Play
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);


    // --- 3. CONTINUAR E VERIFICAR SE VOLTOU A CONTAR ---

    // ACT: Clica no Play
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(); 
    
    // Avança o tempo
    await tester.pump(const Duration(seconds: 2));

    // ASSERT: O tempo antigo não deve mais estar na tela
    expect(find.text(pausedTime), findsNothing);


    // --- 4. RESETAR E VERIFICAR ---

    // ACT: Clica no Reset
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(); 

    // ASSERT: Volta para zero
    expect(find.text('00:00:00'), findsOneWidget);


    // --- 5. FECHAR O DIÁLOGO ---

    // GARANTIA: Pausa antes de fechar para evitar conflito de Timer
    if (find.byIcon(Icons.pause).evaluate().isNotEmpty) {
      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();
    }

    // ACT: Fecha o diálogo
    await tester.tap(find.text('Fechar'));
    
    // Aguarda animação de saída
    await tester.pumpAndSettle();

    // ASSERT: Diálogo sumiu
    expect(find.byType(StopwatchDialog), findsNothing);
  });
}