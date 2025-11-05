// lib/providers/workout_provider.dart
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../repositories/workout_repository.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutRepository _repository;

  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  WorkoutProvider({WorkoutRepository? repository})
      : _repository = repository ?? const FileWorkoutRepository();

  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();
    _exercises = await _repository.loadExercises();
    _isLoading = false;
    notifyListeners();
  }

  // Salva e notifica
  Future<void> _saveAndNotify() async {
    await _repository.saveExercises(_exercises);
    notifyListeners();
  }

  void addExercise() {
    _exercises.add(
      Exercise(name: 'Novo Exercício Adicionado', series: '3 séries de 12'),
    );
    // Salva em "segundo plano", mas notifica a UI imediatamente
    _saveAndNotify();
  }

  void updateExercise(int index, Exercise exercise) {
    if (index >= 0 && index < _exercises.length) {
      _exercises[index] = exercise;
      _saveAndNotify();
    }
  }

  void deleteExercise(int index) {
    if (index >= 0 && index < _exercises.length) {
      _exercises.removeAt(index);
      _saveAndNotify();
    }
  }
}