import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import 'edit_exercise_page.dart';

class WorkoutPlanDetailsPage extends StatefulWidget {
  final int planIndex;

  const WorkoutPlanDetailsPage({Key? key, required this.planIndex})
      : super(key: key);

  @override
  _WorkoutPlanDetailsPageState createState() => _WorkoutPlanDetailsPageState();
}

class _WorkoutPlanDetailsPageState extends State<WorkoutPlanDetailsPage> {

  void _addExercise() {
    context.read<WorkoutProvider>().addExerciseToPlan(widget.planIndex);
  }

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

    if (shouldShowSnackbar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercício apagado com sucesso.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Exercício'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}