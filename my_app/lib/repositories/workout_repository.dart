// repositories/workout_repository.dart
import '../models/exercise_model.dart';

import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';


abstract class WorkoutRepository {
  /// Carrega a lista de exercícios.
  Future<List<Exercise>> loadExercises();

  /// Salva a lista de exercícios.
  Future<void> saveExercises(List<Exercise> exercises);
}

// repositories/workout_repository.dart (no mesmo arquivo)


class FileWorkoutRepository implements WorkoutRepository {
  
  const FileWorkoutRepository();

  // A lógica de encontrar o arquivo foi movida para cá.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/workout.json');
  }

  @override
  Future<List<Exercise>> loadExercises() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> exercisesJson = jsonDecode(contents);
        return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
      } else {
        // Retorna a lista padrão se o arquivo não existir.
        return [
          Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
          Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
          Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
          Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
          Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
          Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
        ];
      }
    } catch (e) {
      print("Erro ao carregar exercícios: $e");
      // Retorna uma lista vazia em caso de erro.
      return [];
    }
  }

  @override
  Future<void> saveExercises(List<Exercise> exercises) async {
    final file = await _getFile();
    final List<Map<String, dynamic>> exercisesJson =
        exercises.map((exercise) => exercise.toJson()).toList();
    await file.writeAsString(jsonEncode(exercisesJson));
  }
}