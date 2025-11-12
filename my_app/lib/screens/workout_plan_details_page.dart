import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_model.dart';
import '../models/workout_plan.dart'; // Importe o WorkoutPlan
import '../providers/workout_provider.dart';
import 'edit_exercise_page.dart';
import 'active_workout_page.dart'; // Importe a ActiveWorkoutPage

class WorkoutPlanDetailsPage extends StatefulWidget {
  final int planIndex;

  const WorkoutPlanDetailsPage({Key? key, required this.planIndex})
      : super(key: key);

  @override
  _WorkoutPlanDetailsPageState createState() => _WorkoutPlanDetailsPageState();
}

class _WorkoutPlanDetailsPageState extends State<WorkoutPlanDetailsPage> {

  // Ação de Adicionar Exercício
  void _addExercise() {
    context.read<WorkoutProvider>().addExerciseToPlan(widget.planIndex);
  }

  // Ação de Editar Exercício
  void _navigateToEditPage(BuildContext context, int exerciseIndex) async {
    final workoutProvider = context.read<WorkoutProvider>();
    final exercise = workoutProvider.plans[widget.planIndex].exercises[exerciseIndex];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(exercise: exercise),
      ),
    );

    if (!mounted) return;
    bool shouldShowSnackbar = false;

    if (result == 'DELETE') {
      workoutProvider.deleteExerciseFromPlan(widget.planIndex, exerciseIndex);
      shouldShowSnackbar = true;
    } else if (result != null && result is Exercise) {
      workoutProvider.updateExerciseInPlan(widget.planIndex, exerciseIndex, result);
    }

    if (shouldShowSnackbar && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercício apagado com sucesso.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Ação de Iniciar Treino
  void _startWorkout(WorkoutPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Navega para a tela de treino ativo
        builder: (context) => ActiveWorkoutPage(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assista o provider
    final workoutProvider = context.watch<WorkoutProvider>();
    // Pegue o plano específico pelo índice
    final plan = workoutProvider.plans[widget.planIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name), // Título da AppBar é o nome do plano
        backgroundColor: Colors.blueAccent,
        actions: [
          // 2. MUDANÇA: Botão "Adicionar Exercício" agora é um ícone aqui
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Exercício',
            onPressed: _addExercise,
          ),
        ],
      ),
      // 3. MUDANÇA: O body agora é SÓ a lista.
      // A Column foi removida.
      body: ListView.builder(
        // Adiciona um padding no final para o FAB não cobrir o último item
        padding: const EdgeInsets.only(top: 8.0, bottom: 100.0),
        itemCount: plan.exercises.length, // Lista os exercícios DESTE plano
        itemBuilder: (BuildContext context, int index) {
          final exercise = plan.exercises[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              leading: CircleAvatar(
                backgroundColor: Colors.amber[100],
                child: Text('${index + 1}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
              title: Text(exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(exercise.series),
              trailing: const Icon(Icons.edit),
              onTap: () => _navigateToEditPage(context, index),
            ),
          );
        },
      ),

      // 1. MUDANÇA: O botão principal agora é um FloatingActionButton
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startWorkout(plan),
        label: const Text('INICIAR TREINO'),
        icon: const Icon(Icons.play_arrow),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}