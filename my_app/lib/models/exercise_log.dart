class ExerciseLog {
  final String exerciseName;
  final int seriesIndex; // O número da série (ex: 1ª, 2ª, 3ª)
  final double weight;   // Peso levantado
  final int reps;         // Repetições feitas

  ExerciseLog({
    required this.exerciseName,
    required this.seriesIndex,
    required this.weight,
    required this.reps,
  });

  // Métodos fromJson/toJson para salvar
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'seriesIndex': seriesIndex,
      'weight': weight,
      'reps': reps,
    };
  }

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      exerciseName: json['exerciseName'],
      seriesIndex: json['seriesIndex'],
      weight: json['weight'],
      reps: json['reps'],
    );
  }
}