import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart'; // 1. Importe o Provider

// 2. Importe os novos modelos e o provider
import 'package:my_app/models/exercise_model.dart';
import 'package:my_app/models/workout_plan.dart';
import 'package:my_app/screens/training_page.dart';
import 'package:my_app/repositories/workout_repository.dart';
import 'package:my_app/providers/workout_provider.dart'; // 3. Importe seu provider

// 4. Atualize o Mock para implementar a NOVA interface
class MockWorkoutRepository implements WorkoutRepository {
  List<WorkoutPlan>? mockPlans; // Agora usa uma lista de WorkoutPlan
  bool shouldThrowError = false;

  @override
  Future<List<WorkoutPlan>> loadWorkoutPlans() async {
    if (shouldThrowError) {
      throw Exception('Erro simulado');
    }
    // Retorna a lista de planos mockados ou um padrão de teste
    return mockPlans ?? [
      WorkoutPlan(
        name: 'Plano Padrão Mock',
        exercises: [Exercise(name: 'Exercício Padrão Mock', series: '1x1')]
      )
    ];
  }

  @override
  Future<void> saveWorkoutPlans(List<WorkoutPlan> plans) async {
    // Em um teste, não precisamos fazer nada aqui
    print('Planos salvos no mock!');
    return;
  }
}

void main() {
  
  testWidgets('Deve carregar e exibir a lista de PLANOS de treino do provider', (WidgetTester tester) async {
    // ARRANGE (Etapa 1): Criar o repositório falso.
    final mockRepo = MockWorkoutRepository();
    // Configura o que ele deve retornar.
    mockRepo.mockPlans = [
      WorkoutPlan(
        name: 'Treino A: Peito e Tríceps (Mock)',
        exercises: [Exercise(name: 'Supino Mock', series: '4x10')]
      ),
      WorkoutPlan(
        name: 'Treino B: Costas e Bíceps (Mock)',
        exercises: [Exercise(name: 'Barra Fixa Mock', series: '3x5')]
      ),
    ];

    // ARRANGE (Etapa 2): Criar o Provider real, mas INJETAR o repositório falso nele.
    // (Isto presume que seu WorkoutProvider aceita um 'repository' no construtor)
    final mockProvider = WorkoutProvider(repository: mockRepo);

    // ACT: Constrói o widget, mas agora o envolvemos com o Provider.
    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutProvider>(
        create: (context) => mockProvider,
        child: const MaterialApp(
          // O construtor da TrainingPage agora está correto (sem parâmetros)
          home: TrainingPage(), 
        ),
      ),
    );

    // Espera a UI ser construída após o carregamento dos dados (Future)
    await tester.pumpAndSettle();

    // ASSERT: Verifica se os NOMES DOS PLANOS (e não os exercícios)
    // foram carregados e exibidos.
    expect(find.text('Treino A: Peito e Tríceps (Mock)'), findsOneWidget);
    expect(find.text('Treino B: Costas e Bíceps (Mock)'), findsOneWidget);

    // Verifica se os 2 planos criaram 2 ListTiles (ou o widget que você usa)
    expect(find.byType(ListTile), findsNWidgets(2));

    // Os exercícios em si NÃO devem aparecer nesta tela (provavelmente)
    expect(find.text('Supino Mock'), findsNothing);
  });
}