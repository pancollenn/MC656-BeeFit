import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Adapte os imports para a estrutura do seu projeto
import 'package:seu_app/models/exercise_model.dart';
import 'package:seu_app/screens/training_page.dart';
import 'package:seu_app/repositories/workout_repository.dart';
import 'package:seu_app/widgets/stopwatch_dialog.dart';

// 1. Implementação FALSA do repositório, como no seu exemplo.
// Isso isola nosso teste de dependências externas (como arquivos).
class MockWorkoutRepository implements WorkoutRepository {
  @override
  Future<List<Exercise>> loadExercises() async {
    // Retorna uma lista vazia ou com dados de teste, o suficiente para a página construir.
    return [Exercise(name: 'Exercício Mock', series: '1x1')];
  }

  @override
  Future<void> saveExercises(List<Exercise> exercises) async {
    return; // Não faz nada, pois é um mock.
  }
}


void main() {
  testWidgets(
      'Teste completo do cronômetro: abrir, pausar, continuar, resetar e fechar',
      (WidgetTester tester) async {
    // ARRANGE: Prepara o ambiente do teste.
    final mockRepo = MockWorkoutRepository();

    // Constrói a tela principal que contém o botão para abrir o cronômetro.
    await tester.pumpWidget(MaterialApp(
      home: TrainingPage(repository: mockRepo),
    ));

    // Aguarda a UI assíncrona (como o loadExercises) terminar.
    await tester.pumpAndSettle();

    // --- 1. ABRIR E VERIFICAR SE ESTÁ RODANDO ---

    // ACT: Encontra o FloatingActionButton pelo ícone e o pressiona.
    await tester.tap(find.byIcon(Icons.timer));
    // Aguarda a animação de abertura do diálogo terminar.
    await tester.pumpAndSettle();

    // ASSERT: Verifica se o diálogo (AlertDialog) apareceu.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Cronômetro de Descanso'), findsOneWidget);
    // Verifica se o tempo inicial é "00:00:00".
    expect(find.text('00:00:00'), findsOneWidget);

    // ACT: Avança o tempo do teste em 1 segundo.
    await tester.pump(const Duration(seconds: 1));

    // ASSERT: Verifica se o cronômetro começou a contar e o texto mudou.
    expect(find.text('00:00:00'), findsNothing);


    // --- 2. PAUSAR E VERIFICAR SE PAROU ---

    // ACT: Encontra o botão de pausa pelo ícone e o pressiona.
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump(); // Reconstrói a UI para mostrar o ícone de play.

    // Captura o tempo exato em que foi pausado.
    final pausedTime =
        (tester.firstWidget(find.byType(Text)) as Text).data;

    // ACT: Avança mais 1 segundo no tempo do teste.
    await tester.pump(const Duration(seconds: 1));

    // ASSERT: Verifica se o tempo na tela NÃO mudou, confirmando que está pausado.
    expect(find.text(pausedTime!), findsOneWidget);


    // --- 3. CONTINUAR E VERIFICAR SE VOLTOU A CONTAR ---

    // ACT: Encontra o botão de play (que substituiu o de pausa) e o pressiona.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(seconds: 1)); // Avança 1 segundo.

    // ASSERT: Verifica se o tempo na tela é diferente do tempo pausado.
    expect(find.text(pausedTime), findsNothing);


    // --- 4. RESETAR E VERIFICAR ---

    // ACT: Encontra o botão de reset pelo ícone e o pressiona.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(); // Reconstrói a UI.

    // ASSERT: Verifica se o cronômetro voltou para o estado inicial.
    // NOTA: Este passo pode falhar com seu código original. Veja a correção abaixo.
    expect(find.text('00:00:00'), findsOneWidget);


    // --- 5. FECHAR O DIÁLOGO ---

    // ACT: Encontra o botão "Fechar" e o pressiona.
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle(); // Aguarda a animação de fechamento.

    // ASSERT: Verifica se o diálogo não está mais na tela.
    expect(find.byType(AlertDialog), findsNothing);
  });
}