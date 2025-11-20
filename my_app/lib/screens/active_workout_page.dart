import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Para filtrar o input de números

import '../models/workout_plan.dart';
import '../models/exercise_model.dart';
import '../models/exercise_log.dart';
import '../models/workout_session.dart';
import '../providers/history_provider.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final WorkoutPlan plan;

  const ActiveWorkoutPage({Key? key, required this.plan}) : super(key: key);

  @override
  _ActiveWorkoutPageState createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  // Estado da Sessão
  late DateTime _startTime;
  final List<ExerciseLog> _logs = []; // Lista de todas as séries concluídas

  // Estado da UI
  int _currentExerciseIndex = 0;
  int _currentSeriesIndex = 0;
  bool _isFinished = false;

  // Controladores de Texto
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  
  // Foco
  final FocusNode _repsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Marca o início do treino
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _repsFocus.dispose();
    super.dispose();
  }
  
  Exercise get _currentExercise {
    return widget.plan.exercises[_currentExerciseIndex];
  }

  // Ação principal: Salva a série atual e avança
  void _logSeries() {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final int reps = int.tryParse(_repsController.text) ?? 0;

    // Não salva se não houver repetições
    if (reps == 0) return;

    // 1. Cria o log da série
    final log = ExerciseLog(
      exerciseName: _currentExercise.name,
      seriesIndex: _currentSeriesIndex + 1, // +1 para ser (Série 1, Série 2...)
      weight: weight,
      reps: reps,
    );
    
    // 2. Salva o log
    setState(() {
      _logs.add(log);
      
      // 3. Avança para a próxima série ou exercício
      _currentSeriesIndex++;
      
      // TODO: Usar o número de séries do plano (ex: '4 séries')
      // Por enquanto, vamos assumir 3 séries para tudo
      if (_currentSeriesIndex >= 3) {
        _currentSeriesIndex = 0;
        _currentExerciseIndex++;
        
        // Verifica se o treino acabou
        if (_currentExerciseIndex >= widget.plan.exercises.length) {
          _isFinished = true;
        }
      }
      
      // Limpa os campos
      _weightController.clear();
      _repsController.clear();
      
      // Foca no campo de peso para a próxima série
      FocusScope.of(context).requestFocus(FocusManager.instance.primaryFocus);
    });
  }

  // Ação Final: Salva a sessão inteira
  void _finishWorkout() {
    final DateTime endTime = DateTime.now();
    
    // 1. Cria a Sessão
    final session = WorkoutSession(
      planName: widget.plan.name,
      startTime: _startTime,
      endTime: endTime,
      logs: _logs, // A lista de logs que construímos
    );
    
    // 2. Adiciona ao Histórico via Provider
    context.read<HistoryProvider>().addSession(session);
    
    // 3. Mostra um snackbar e fecha a tela
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop(); // Volta para a tela de detalhes
  }

  // Função para mostrar o diálogo de confirmação
  Future<bool> _onWillPop() async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar treino?'),
        content: const Text('Você tem certeza que quer sair? Todo o progresso deste treino será perdido.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Não sai
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Sai
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Descartar'),
          ),
        ],
      ),
    )) ?? false; // Retorna 'false' se o diálogo for dispensado
  }

  @override
  Widget build(BuildContext context) {
    // Tela de Treino Concluído
    if (_isFinished) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.plan.name),
          automaticallyImplyLeading: false, // Remove o botão de voltar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text('Treino Concluído!', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar e Sair'),
                onPressed: _finishWorkout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.green
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Tela de treino ativo
    // O WillPopScope impede o usuário de "arrastar" para voltar
    // ou usar o botão físico de voltar do Android sem confirmação.
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentExercise.name),
          // Botão de fechar que chama o diálogo de confirmação
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Plano: ${widget.plan.name}', 
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 10),
              Text('Exercício: ${_currentExerciseIndex + 1} de ${widget.plan.exercises.length}', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Série: ${_currentSeriesIndex + 1} de 3', // TODO: Usar o valor real
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Campos de Input
              TextField(
                controller: _weightController,
                autofocus: true, // Foca no peso ao carregar a tela
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                // Pula para o campo de repetições ao apertar "Enter"
                onSubmitted: (_) => _repsFocus.requestFocus(), 
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _repsController,
                focusNode: _repsFocus,
                decoration: const InputDecoration(
                  labelText: 'Repetições',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
                // Salva a série ao apertar "Enter"
                onSubmitted: (_) => _logSeries(),
              ),
              const SizedBox(height: 30),
              
              // Botão de Ação
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Salvar Série'),
                onPressed: _logSeries,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
              
              // TODO: Adicionar um botão "Pular Série" ou "Pular Exercício"
            ],
          ),
        ),
      ),
    );
  }
}