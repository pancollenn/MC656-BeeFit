import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../repositories/workout_repository.dart';
import 'edit_exercise_page.dart';

class TrainingPage extends StatefulWidget {
  final WorkoutRepository repository;

  const TrainingPage({
    Key? key,
    this.repository = const FileWorkoutRepository(),
  }) : super(key: key);

  @override
  State<TrainingPage> createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {
  List<Exercise> chestAndTricepsWorkout = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    if (mounted) setState(() => _isLoading = true);
    final loadedExercises = await widget.repository.loadExercises();
    if (mounted) {
      setState(() {
        chestAndTricepsWorkout = loadedExercises;
        _isLoading = false;
      });
    }
  }

  Future<void> saveChanges() async {
    await widget.repository.saveExercises(chestAndTricepsWorkout);
  }

  void _addExercise() {
    setState(() {
      chestAndTricepsWorkout.add(
        Exercise(name: 'Novo Exercício Adicionado', series: '3 séries de 12'),
      );
    });
    saveChanges();
  }

  void _navigateToEditPage(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(
          exercise: chestAndTricepsWorkout[index],
        ),
      ),
    );

    bool shouldSave = false;

    if (result == 'DELETE') {
      setState(() {
        chestAndTricepsWorkout.removeAt(index);
      });
      shouldSave = true;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercício apagado com sucesso.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (result != null && result is Exercise) {
      setState(() {
        chestAndTricepsWorkout[index] = result;
      });
      shouldSave = true;
    }

    if (shouldSave) {
      saveChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino de Peito e Tríceps'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: Text('Carregando exercícios...'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    itemCount: chestAndTricepsWorkout.length,
                    itemBuilder: (BuildContext context, int index) {
                      final exercise = chestAndTricepsWorkout[index];
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
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