// repositories/workout_repository.dart
import '../models/exercise_model.dart';
import '../models/workout_plan.dart'; // Importe o novo modelo
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

abstract class WorkoutRepository {
  /// Carrega a lista de PLANOS de exercícios.
  Future<List<WorkoutPlan>> loadWorkoutPlans();

  /// Salva a lista de PLANOS de exercícios.
  Future<void> saveWorkoutPlans(List<WorkoutPlan> plans);
}

class FileWorkoutRepository implements WorkoutRepository {
  // Instância única (privada e estática)
  // Implementa o padrão Singleton para evitar múltiplas instâncias que possam causar leituras e gravações simultâneas em workout.json.
  static final FileWorkoutRepository _instance = FileWorkoutRepository._internal();

  // Factory constructor: sempre retorna a mesma instância
  factory FileWorkoutRepository() {
    return _instance;
  }

  // Construtor privado
  FileWorkoutRepository._internal();


  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    // O nome do arquivo pode continuar o mesmo, mas seu conteúdo será diferente
    return File('$path/workout.json');
  }

  @override
  Future<List<WorkoutPlan>> loadWorkoutPlans() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> plansJson = jsonDecode(contents);
        // Mapeia o JSON para a lista de WorkoutPlan
        return plansJson.map((json) => WorkoutPlan.fromJson(json)).toList();
      } else {
        // Retorna uma lista de planos padrão se o arquivo não existir.
        return [
          WorkoutPlan(
            name: 'Treino A: Peito e Tríceps',
            exercises: [
              Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
              Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
              Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
              Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
              Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
              Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
            ],
          ),
          WorkoutPlan(
            name: 'Treino B: Costas e Bíceps',
            exercises: [
              Exercise(name: 'Barra Fixa', series: '4 séries'),
              Exercise(name: 'Puxada Frontal', series: '4 séries'),
              Exercise(name: 'Remada Curvada', series: '3 séries'),
              Exercise(name: 'Rosca Direta', series: '4 séries'),
            ],
          ),
        ];
      }
    } catch (e) {
      print("Erro ao carregar planos de treino: $e");
      return [];
    }
  }

  @override
  Future<void> saveWorkoutPlans(List<WorkoutPlan> plans) async {
    final file = await _getFile();
    // Converte a lista de planos para JSON
    final List<Map<String, dynamic>> plansJson =
        plans.map((plan) => plan.toJson()).toList();
    await file.writeAsString(jsonEncode(plansJson));
  }
}