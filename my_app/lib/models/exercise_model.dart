// lib/models/exercise_model.dart

class Exercise {
  String name;
  String series;

  Exercise({required this.name, required this.series});

  // NOVO: Método para converter um objeto Exercise em um Map (formato JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'series': series,
    };
  }

  // NOVO: "Factory constructor" para criar um Exercise a partir de um Map
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      series: json['series'] as String,
    );
  }
}