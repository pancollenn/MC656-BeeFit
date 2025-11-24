import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screens/edit_exercise_page.dart'; // Verifique se o caminho está correto
import 'package:my_app/models/exercise_model.dart';   // Verifique se o caminho está correto

void main() {
  group('Avaliação A5 - EditExercisePage (Classes de Equivalência)', () {
    
    // Objeto mock para iniciar a tela
    final initialExercise = Exercise(name: 'Supino', series: '3x10');

    testWidgets('Classe 1 (Edição): Deve atualizar os dados e retornar o objeto modificado', (WidgetTester tester) async {
      // ARRANGE: Variável para capturar o resultado do Navigator.pop
      dynamic result;

      // Montamos a tela dentro de um botão para simular o Navigator.push e capturar o retorno
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              child: const Text('Abrir Editor'),
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditExercisePage(exercise: initialExercise)),
                );
              },
            ),
          ),
        ),
      ));

      // Abre a tela de edição
      await tester.tap(find.text('Abrir Editor'));
      await tester.pumpAndSettle();

      // VERIFICAÇÃO INICIAL: Os dados antigos estão lá?
      expect(find.text('Supino'), findsOneWidget);
      expect(find.text('3x10'), findsOneWidget);

      // ACT: Simula a digitação de novos valores (Classe de Equivalência: Dados de Texto Válidos)
      // Encontra pelo labelText definido no seu código
      final nameFinder = find.widgetWithText(TextField, 'Nome do Exercício');
      final seriesFinder = find.widgetWithText(TextField, 'Séries e Repetições');

      await tester.enterText(nameFinder, 'Supino Inclinado');
      await tester.enterText(seriesFinder, '4x12');
      await tester.pump();

      // Clica em salvar
      await tester.tap(find.text('Salvar Alterações'));
      await tester.pumpAndSettle();

      // ASSERT:
      // 1. O resultado deve ser um objeto do tipo Exercise
      expect(result, isA<Exercise>());
      // 2. Os dados devem estar atualizados
      expect((result as Exercise).name, 'Supino Inclinado');
      expect(result.series, '4x12');
    });

    testWidgets('Classe 2 (Exclusão): Deve retornar sinal "DELETE" ao confirmar exclusão', (WidgetTester tester) async {
      // ARRANGE
      dynamic result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              child: const Text('Abrir Editor'),
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditExercisePage(exercise: initialExercise)),
                );
              },
            ),
          ),
        ),
      ));

      // Abre a tela
      await tester.tap(find.text('Abrir Editor'));
      await tester.pumpAndSettle();

      // ACT: Clica no botão de apagar (Classe de Equivalência: Fluxo Destrutivo)
      await tester.tap(find.text('Apagar Exercício'));
      await tester.pumpAndSettle();

      // Verifica se o Dialog apareceu
      expect(find.text('Confirmar Exclusão'), findsOneWidget);

      // Confirma a exclusão no Dialog
      await tester.tap(find.text('Apagar'));
      await tester.pumpAndSettle();

      // ASSERT: O resultado capturado deve ser a string 'DELETE'
      expect(result, 'DELETE');
    });
  });
}