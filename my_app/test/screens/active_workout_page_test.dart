import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/active_workout_page.dart';
import 'package:my_app/models/workout_plan.dart';
import 'package:my_app/models/exercise_model.dart';
import 'package:my_app/providers/history_provider.dart';

void main() {
  late WorkoutPlan testPlan;

  setUp(() {
    testPlan = WorkoutPlan(
      name: 'Plano Teste',
      exercises: [
        Exercise(name: 'Supino', series: '3x10'),
        Exercise(name: 'Agachamento', series: '3x10'),
      ],
    );
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider(),
      child: MaterialApp(
        home: ActiveWorkoutPage(plan: testPlan),
      ),
    );
  }

  group('Particionamento em Classes de Equivalência - Peso', () {
    testWidgets('Deve aceitar peso válido da classe positiva', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Entrada de dados válidos
      await tester.enterText(find.byType(TextField).first, '10.5');
      await tester.enterText(find.byType(TextField).last, '12');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Verifica que avançou para série 2
      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Não deve aceitar peso negativo (classe inválida)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tenta inserir peso negativo (o inputFormatter deve bloquear)
      await tester.enterText(find.byType(TextField).first, '-10');
      await tester.enterText(find.byType(TextField).last, '12');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // O campo deve estar vazio ou sem o sinal negativo
      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.controller?.text, isNot(contains('-')));
    });

    testWidgets('Deve aceitar peso zero (limite da classe válida)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '0');
      await tester.enterText(find.byType(TextField).last, '12');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Deve aceitar e avançar
      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve aceitar peso decimal válido', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '50.75');
      await tester.enterText(find.byType(TextField).last, '10');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });
  });

  group('Particionamento em Classes de Equivalência - Repetições', () {
    testWidgets('Deve aceitar repetições válidas (classe positiva)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '20');
      await tester.enterText(find.byType(TextField).last, '15');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Não deve salvar série com 0 repetições (classe inválida)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '20');
      await tester.enterText(find.byType(TextField).last, '0');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Não deve avançar de série (ainda deve estar na série 1)
      expect(find.text('Série: 1 de 3'), findsOneWidget);
    });

    testWidgets('Não deve aceitar repetições negativas (classe inválida)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // O inputFormatter deve bloquear valores negativos
      await tester.enterText(find.byType(TextField).first, '20');
      await tester.enterText(find.byType(TextField).last, '-5');
      
      final textField = tester.widget<TextField>(find.byType(TextField).last);
      expect(textField.controller?.text, isNot(contains('-')));
    });

    testWidgets('Deve aceitar repetições muito altas (classe válida)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '100');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });
  });

  group('Análise de Valor Limite - Peso', () {
    testWidgets('Deve aceitar peso 0.0 (limite inferior)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '0.0');
      await tester.enterText(find.byType(TextField).last, '10');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve aceitar peso 0.1 (logo acima do limite inferior)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '0.1');
      await tester.enterText(find.byType(TextField).last, '10');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve aceitar peso 999.9 (limite superior realista)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '999.9');
      await tester.enterText(find.byType(TextField).last, '5');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve aceitar peso 1000.0 (limite superior)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '1000.0');
      await tester.enterText(find.byType(TextField).last, '3');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });
  });

  group('Análise de Valor Limite - Repetições', () {
    testWidgets('Não deve salvar com 0 repetições (limite inferior inválido)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '20');
      await tester.enterText(find.byType(TextField).last, '0');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 1 de 3'), findsOneWidget);
    });

    testWidgets('Deve salvar com 1 repetição (limite inferior válido)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '20');
      await tester.enterText(find.byType(TextField).last, '1');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve salvar com 99 repetições (próximo ao limite superior)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '99');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve salvar com 100 repetições (limite superior)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '100');
      
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });
  });

  group('Análise de Valor Limite - Navegação entre Séries e Exercícios', () {
    testWidgets('Deve avançar da série 1 para série 2 (primeira transição)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Série: 1 de 3'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '12');
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });

    testWidgets('Deve avançar da série 2 para série 3 (transição intermediária)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Completa série 1
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '12');
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Completa série 2
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '12');
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 3 de 3'), findsOneWidget);
    });

    testWidgets('Deve avançar para próximo exercício após última série (limite de série)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Exercício: 1 de 2'), findsOneWidget);
      expect(find.text('Supino'), findsOneWidget);

      // Completa 3 séries do primeiro exercício
      for (int i = 0; i < 3; i++) {
        await tester.enterText(find.byType(TextField).first, '20');
        await tester.enterText(find.byType(TextField).last, '10');
        await tester.tap(find.text('Salvar Série'));
        await tester.pump();
      }

      // Deve avançar para o segundo exercício
      expect(find.text('Exercício: 2 de 2'), findsOneWidget);
      expect(find.text('Agachamento'), findsOneWidget);
      expect(find.text('Série: 1 de 3'), findsOneWidget);
    });

    testWidgets('Deve marcar treino como finalizado após último exercício (limite final)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Completa todos os exercícios (2 exercícios x 3 séries = 6 séries)
      for (int i = 0; i < 6; i++) {
        await tester.enterText(find.byType(TextField).first, '20');
        await tester.enterText(find.byType(TextField).last, '10');
        await tester.tap(find.text('Salvar Série'));
        await tester.pump();
      }

      // Deve mostrar tela de treino concluído
      expect(find.text('Treino Concluído!'), findsOneWidget);
      expect(find.text('Salvar e Sair'), findsOneWidget);
    });

    testWidgets('Deve começar no primeiro exercício e primeira série (limites iniciais)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Exercício: 1 de 2'), findsOneWidget);
      expect(find.text('Série: 1 de 3'), findsOneWidget);
      expect(find.text('Supino'), findsOneWidget);
    });
  });

  group('Casos de Borda - Campos Vazios', () {
    testWidgets('Não deve salvar série com campos vazios', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Não deve avançar
      expect(find.text('Série: 1 de 3'), findsOneWidget);
    });

    testWidgets('Não deve salvar série apenas com peso preenchido', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, '20');
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      expect(find.text('Série: 1 de 3'), findsOneWidget);
    });

    testWidgets('Deve salvar série apenas com repetições preenchidas (peso = 0)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).last, '12');
      await tester.tap(find.text('Salvar Série'));
      await tester.pump();

      // Deve aceitar peso 0 como válido
      expect(find.text('Série: 2 de 3'), findsOneWidget);
    });
  });
}
