// lib/models/workout_session.dart
import 'exercise_log.dart';

class WorkoutSession {
  final String planName;    // Ex: "Treino A: Peito e Tríceps"
  final DateTime startTime; // Quando o treino começou
  final DateTime endTime;   // Quando o treino terminou
  final List<ExerciseLog> logs; // A lista de todas as séries feitas

  WorkoutSession({
    required this.planName,
    required this.startTime,
    required this.endTime,
    required this.logs,
  });

  // Métodos fromJson/toJson para salvar
  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'startTime': startTime.toIso8601String(), // Salva como texto
      'endTime': endTime.toIso8601String(),
      'logs': logs.map((log) => log.toJson()).toList(),
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    var logList = json['logs'] as List;
    List<ExerciseLog> logs = logList.map((log) => ExerciseLog.fromJson(log)).toList();

    return WorkoutSession(
      planName: json['planName'],
      startTime: DateTime.parse(json['startTime']), // Converte texto em DateTime
      endTime: DateTime.parse(json['endTime']),
      logs: logs,
    );
  }
}