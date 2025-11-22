import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Precisaremos para formatar datas
import 'session_details_page.dart';
import '../providers/history_provider.dart';
import '../models/workout_session.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Carrega o histórico assim que a tela é iniciada
    // (mas só se ainda não foi carregado, por exemplo)
    // Uma abordagem simples é apenas chamar o load:
    Future.microtask(() {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Assiste o provider para mudanças
    final historyProvider = context.watch<HistoryProvider>();

    return Scaffold(
      body: _buildHistoryList(historyProvider),
    );
  }

  Widget _buildHistoryList(HistoryProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.history.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum treino concluído ainda.\nComplete um treino para vê-lo aqui!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Ordena a lista para mostrar os mais recentes primeiro
    final sortedHistory = List<WorkoutSession>.from(provider.history)
      ..sort((a, b) => b.endTime.compareTo(a.endTime));

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final session = sortedHistory[index];
        
        // Formata a data para ficar legível
        final String formattedDate = 
            DateFormat('dd/MM/yyyy \'às\' HH:mm').format(session.endTime);
        
        // Calcula a duração do treino
        final Duration duration = session.endTime.difference(session.startTime);
        final String durationString = 
            "${duration.inMinutes} min"; // Ex: "45 min"

        return Card(
          child: ListTile(
            title: Text(
              session.planName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Concluído em: $formattedDate\nDuração: $durationString',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetailsPage(session: session),
                ),
              );
            },
          ),
        );
      },
    );
  }
}