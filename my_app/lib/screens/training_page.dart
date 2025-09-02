import 'package:flutter/material.dart';
// --- CORREÇÃO APLICADA AQUI ---
// Adicionada a importação do modelo de exercício
import '../models/exercise_model.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  // Agora o arquivo sabe o que é um 'Exercise' e que ele tem um construtor const
  final List<Exercise> chestAndTricepsWorkout = const [
    Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
    Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
    Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
    Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
    Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
    Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      itemCount: chestAndTricepsWorkout.length,
      itemBuilder: (BuildContext context, int index) {
        final exercise = chestAndTricepsWorkout[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            leading: CircleAvatar(
              backgroundColor: Colors.amber[100],
              child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(exercise.series),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => print('Exercício selecionado: ${exercise.name}'),
          ),
        );
      },
    );
  }
}