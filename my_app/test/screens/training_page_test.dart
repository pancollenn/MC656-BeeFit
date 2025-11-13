import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importe suas classes
import 'package:my_app/models/exercise_model.dart';
import 'package:my_app/screens/training_page.dart';
import 'package:my_app/repositories/workout_repository.dart';

// 1. Crie uma implementação FALSA do repositório para os testes.
// Ela não usa arquivos, apenas uma lista em memória. É instantânea e confiável.
class MockWorkoutRepository implements WorkoutRepository {
  List<Exercise>? mockExercises;
  bool shouldThrowError = false;

  @override
  Future<List<Exercise>> loadExercises() async {
    if (shouldThrowError) {
      throw Exception('Erro simulado');
    }
    // Retorna a lista mock que configuramos ou uma lista padrão de teste.
    return mockExercises ?? [Exercise(name: 'Exercício Padrão Mock', series: '1x1')];
  }

  @override
  Future<void> saveExercises(List<Exercise> exercises) async {
    // Em um teste, podemos simplesmente confirmar que foi salvo, ou não fazer nada.
    print('Exercícios salvos no mock!');
    return;
  }
}

void main() {
  // Não precisamos mais de setUpAll, tearDown ou mocks de path_provider!
  
  testWidgets('Deve carregar e exibir a lista de exercícios do repositório mock', (WidgetTester tester) async {
    // ARRANGE: Cria o nosso repositório falso.
    final mockRepo = MockWorkoutRepository();
    // Configura o que ele deve retornar.
    mockRepo.mockExercises = [
      Exercise(name: 'Supino Mock', series: '4x10'),
      Exercise(name: 'Tríceps Mock', series: '3x12'),
    ];

    // ACT: Constrói o widget INJETANDO o repositório falso.
    await tester.pumpWidget(MaterialApp(
      home: TrainingPage(repository: mockRepo),
    ));

    // Agora, um simples pumpAndSettle funciona perfeitamente.
    await tester.pumpAndSettle();

    // ASSERT: Verifica se os dados do MOCK foram carregados.
    expect(find.text('Carregando exercícios...'), findsNothing);
    expect(find.text('Supino Mock'), findsOneWidget);
    expect(find.text('Tríceps Mock'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
  });
}