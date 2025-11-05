import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../models/workout_plan.dart'; // Importe o novo modelo
import '../repositories/workout_repository.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutRepository _repository;

  List<WorkoutPlan> _plans = [];
  bool _isLoading = true;

  List<WorkoutPlan> get plans => _plans;
  bool get isLoading => _isLoading;

  WorkoutProvider({WorkoutRepository? repository})
      : _repository = repository ?? const FileWorkoutRepository();

  Future<void> loadPlans() async {
    _isLoading = true;
    notifyListeners();
    _plans = await _repository.loadWorkoutPlans();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _savePlansAndNotify() async {
    await _repository.saveWorkoutPlans(_plans);
    notifyListeners();
  }

  // --- Métodos para gerenciar PLANOS ---

  void addPlan(String name) {
    _plans.add(
      WorkoutPlan(name: name, exercises: []),
    );
    _savePlansAndNotify();
  }

  void deletePlan(int planIndex) {
    if (planIndex >= 0 && planIndex < _plans.length) {
      _plans.removeAt(planIndex);
      _savePlansAndNotify();
    }
  }

  void updatePlanName(int planIndex, String newName) {
    if (planIndex >= 0 && planIndex < _plans.length) {
      _plans[planIndex].name = newName;
      _savePlansAndNotify();
    }
  }

  // --- Métodos para gerenciar EXERCÍCIOS DENTRO DE UM PLANO ---

  void addExerciseToPlan(int planIndex) {
    if (planIndex >= 0 && planIndex < _plans.length) {
      _plans[planIndex].exercises.add(
            Exercise(name: 'Novo Exercício', series: '3 séries de 10'),
          );
      _savePlansAndNotify();
    }
  }

  void updateExerciseInPlan(int planIndex, int exerciseIndex, Exercise exercise) {
    if (planIndex >= 0 && planIndex < _plans.length) {
      final plan = _plans[planIndex];
      if (exerciseIndex >= 0 && exerciseIndex < plan.exercises.length) {
        plan.exercises[exerciseIndex] = exercise;
        _savePlansAndNotify();
      }
    }
  }

  void deleteExerciseFromPlan(int planIndex, int exerciseIndex) {
    if (planIndex >= 0 && planIndex < _plans.length) {
      final plan = _plans[planIndex];
      if (exerciseIndex >= 0 && exerciseIndex < plan.exercises.length) {
        plan.exercises.removeAt(exerciseIndex);
        _savePlansAndNotify();
      }
    }
  }
}