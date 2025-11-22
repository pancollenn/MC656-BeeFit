// lib/screens/session_details_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_session.dart';
import '../models/exercise_log.dart';

class SessionDetailsPage extends StatelessWidget {
  final WorkoutSession session;

  const SessionDetailsPage({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy \'às\' HH:mm').format(session.endTime);
    final duration = session.endTime.difference(session.startTime);
    final durationString = "${duration.inMinutes} min";

    // Agrupa os logs por nome de exercício para exibição organizada
    final Map<String, List<ExerciseLog>> groupedLogs = {};
    for (var log in session.logs) {
      if (!groupedLogs.containsKey(log.exerciseName)) {
        groupedLogs[log.exerciseName] = [];
      }
      groupedLogs[log.exerciseName]!.add(log);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Treino'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cartão de Resumo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      session.planName,
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(Icons.calendar_today, formattedDate),
                        _buildInfoItem(Icons.timer, durationString),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exercícios Realizados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lista de Exercícios Agrupados
            ...groupedLogs.entries.map((entry) {
              final exerciseName = entry.key;
              final logs = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exerciseName,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(),
                      // Lista das séries deste exercício
                      ...logs.map((log) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Série ${log.seriesIndex}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              "${log.weight} kg  x  ${log.reps} reps",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          text, 
          style: const TextStyle(color: Colors.white, fontSize: 14)
        ),
      ],
    );
  }
}