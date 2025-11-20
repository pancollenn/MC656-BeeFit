import 'exercise_model.dart';

class WorkoutPlan {
  String name;
  List<Exercise> exercises;

  WorkoutPlan({required this.name, required this.exercises});

  // Métodos fromJson/toJson para que possamos salvá-lo
  // no repositório de arquivos, assim como fizemos com o Exercise.

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    var exerciseList = json['exercises'] as List;
    List<Exercise> exercises = exerciseList.map((e) => Exercise.fromJson(e)).toList();
    
    return WorkoutPlan(
      name: json['name'] as String,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // Converte cada Exercise em seu próprio map JSON
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}