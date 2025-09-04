// lib/pages/edit_exercise_page.dart (versão modificada)

import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class EditExercisePage extends StatefulWidget {
  final Exercise exercise;
  const EditExercisePage({Key? key, required this.exercise}) : super(key: key);

  @override
  _EditExercisePageState createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  late TextEditingController _nameController;
  late TextEditingController _seriesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _seriesController = TextEditingController(text: widget.exercise.series);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _seriesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedExercise = Exercise(
      name: _nameController.text,
      series: _seriesController.text,
    );
    Navigator.of(context).pop(updatedExercise);
  }

  // NOVO: Função para mostrar o diálogo de confirmação de exclusão
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja apagar este exercício? Esta ação não pode ser desfeita.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                // Apenas fecha o diálogo
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Apagar'),
              onPressed: () {
                // Fecha o diálogo e depois fecha a página de edição,
                // enviando o sinal 'DELETE' de volta.
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop('DELETE'); // Envia o sinal de exclusão
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Exercício'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Exercício',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _seriesController,
              decoration: const InputDecoration(
                labelText: 'Séries e Repetições',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Salvar Alterações'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12), // Espaçamento entre os botões
            
            // NOVO: Botão para apagar o exercício
            ElevatedButton.icon(
              onPressed: _showDeleteConfirmationDialog, // Chama o diálogo de confirmação
              icon: const Icon(Icons.delete_forever),
              label: const Text('Apagar Exercício'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                backgroundColor: Colors.red, // Cor vermelha para indicar perigo
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}