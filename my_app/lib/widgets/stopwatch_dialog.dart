import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchDialog extends StatefulWidget {
  const StopwatchDialog({Key? key}) : super(key: key);

  @override
  _StopwatchDialogState createState() => _StopwatchDialogState();
}

class _StopwatchDialogState extends State<StopwatchDialog> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00';
  bool _isRunning = true;
  

  @override
  void initState() {

    super.initState();
    _stopwatch.start();
    // O timer é inicializado aqui, mas só começa a rodar quando o usuário clica em Iniciar.
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          // Formata o tempo para exibição
          final int milliseconds = _stopwatch.elapsedMilliseconds;
          final int hundreds = (milliseconds / 10).truncate();
          final int seconds = (hundreds / 100).truncate();
          final int minutes = (seconds / 60).truncate();

          final String minutesStr = (minutes % 60).toString().padLeft(2, '0');
          final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
          final String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

          _result = '$minutesStr:$secondsStr:$hundredsStr';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela o timer para evitar memory leaks
    _stopwatch.stop();
    super.dispose();
  }

  void _startStop() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
      _isRunning = _stopwatch.isRunning;
    });
  }

  void _reset() {
    _stopwatch.reset();
    if (!_isRunning) { // Só atualiza a UI se não estiver rodando
      setState(() {
        _result = '00:00:00';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cronômetro de Descanso', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _result,
            style: const TextStyle(
              fontSize: 48.0,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Botão Iniciar/Parar
              ElevatedButton(
                onPressed: _startStop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.redAccent : Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
              ),
              // Botão Resetar
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.refresh, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
