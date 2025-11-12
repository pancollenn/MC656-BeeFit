import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/workout_session.dart';

/// Define o "contrato" do que um repositório de histórico deve fazer.
abstract class HistoryRepository {
  /// Carrega a lista de todas as sessões de treino salvas.
  Future<List<WorkoutSession>> loadHistory();

  /// Salva a lista completa de sessões de treino.
  Future<void> saveHistory(List<WorkoutSession> sessions);
}

/// Implementação do repositório que salva os dados em um arquivo JSON.
class FileHistoryRepository implements HistoryRepository {
  const FileHistoryRepository();

  /// Encontra o arquivo 'history.json' no diretório de documentos do app.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/history.json');
  }

  @Override
  Future<List<WorkoutSession>> loadHistory() async {
    try {
      final file = await _getFile();
      
      // Se o arquivo não existir, apenas retorna uma lista vazia.
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }

      final List<dynamic> historyJson = jsonDecode(contents);
      
      // Converte cada item do JSON em um objeto WorkoutSession
      return historyJson
          .map((json) => WorkoutSession.fromJson(json))
          .toList();
          
    } catch (e) {
      print("Erro ao carregar histórico de treinos: $e");
      // Retorna uma lista vazia em caso de qualquer erro
      return [];
    }
  }

  @Override
  Future<void> saveHistory(List<WorkoutSession> sessions) async {
    try {
      final file = await _getFile();
      
      // Converte a lista de objetos WorkoutSession em uma lista de Maps JSON
      final List<Map<String, dynamic>> historyJson =
          sessions.map((session) => session.toJson()).toList();
          
      // Escreve a string JSON codificada no arquivo
      await file.writeAsString(jsonEncode(historyJson));
    } catch (e) {
      print("Erro ao salvar histórico de treinos: $e");
    }
  }
}