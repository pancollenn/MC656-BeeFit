import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';
import '../repositories/history_repository.dart';

class HistoryProvider with ChangeNotifier {
  final HistoryRepository _repository;

  // Estado: A lista de sessões e o status de carregamento
  List<WorkoutSession> _history = [];
  bool _isLoading = true;

  // Getters: Como a UI vai ler o estado
  List<WorkoutSession> get history => _history;
  bool get isLoading => _isLoading;

  // Construtor: Injeta o repositório
  HistoryProvider({HistoryRepository? repository})
      : _repository = repository ?? const FileHistoryRepository();

  /// Ação: Carrega o histórico do repositório
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners(); // Notifica a UI "Estou carregando"
    
    _history = await _repository.loadHistory();
    
    _isLoading = false;
    notifyListeners(); // Notifica a UI "Carregamento concluído, aqui estão os dados"
  }

  /// Ação: Adiciona uma nova sessão de treino concluída
  Future<void> addSession(WorkoutSession newSession) async {
    // 1. Adiciona a nova sessão à lista local
    _history.add(newSession);
    
    // 2. Notifica a UI imediatamente (otimismo!)
    notifyListeners();
    
    // 3. Manda o repositório salvar a lista *completa* atualizada
    // Isso pode acontecer em segundo plano.
    await _repository.saveHistory(_history);
  }
}