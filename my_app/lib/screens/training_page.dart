import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import 'edit_exercise_page.dart';

// --- NOVAS IMPORTAÇÕES ---
import 'dart:io';                 // Para lidar com arquivos (File)
import 'dart:convert';            // Para codificar/decodificar JSON
import 'package:path_provider/path_provider.dart'; // Para encontrar o caminho de salvamento

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<Exercise> chestAndTricepsWorkout = []; // Inicia a lista vazia
  bool _isLoading = true; // NOVO: Flag para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadExercises(); // NOVO: Carrega os exercícios quando a página inicia
  }

  // --- NOVAS FUNÇÕES DE SALVAR E CARREGAR ---

  // Encontra o caminho e o arquivo onde os dados serão salvos
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/workout.json');
  }

  // Salva a lista atual de exercícios no arquivo JSON
  Future<void> _saveExercises() async {
    final file = await _getFile();
    // Converte a lista de exercícios para uma lista de JSON
    final List<Map<String, dynamic>> exercisesJson =
        chestAndTricepsWorkout.map((exercise) => exercise.toJson()).toList();
    // Escreve a string JSON no arquivo
    await file.writeAsString(jsonEncode(exercisesJson));
  }

  // Carrega os exercícios do arquivo JSON
  Future<void> _loadExercises() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> exercisesJson = jsonDecode(contents);
        setState(() {
          chestAndTricepsWorkout =
              exercisesJson.map((json) => Exercise.fromJson(json)).toList();
        });
      } else {
         // Se o arquivo não existe, carrega a lista padrão
        setState(() {
          chestAndTricepsWorkout = [
            Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
            Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
            Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
            Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
            Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
            Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
          ];
        });
      }
    } catch (e) {
      print("Erro ao carregar exercícios: $e");
    } finally {
      setState(() {
        _isLoading = false; // Finaliza o carregamento
      });
    }
  }
  
  // --- FIM DAS NOVAS FUNÇÕES ---

  void _addExercise() {
    setState(() {
      chestAndTricepsWorkout.add(
        Exercise(name: 'Novo Exercício Adicionado', series: '3 séries de 12'),
      );
    });
    _saveExercises(); // NOVO: Salva após adicionar
  }

  void _navigateToEditPage(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExercisePage(
          exercise: chestAndTricepsWorkout[index],
        ),
      ),
    );

    bool shouldSave = false; // Flag para saber se precisa salvar

    if (result == 'DELETE') {
      setState(() {
        chestAndTricepsWorkout.removeAt(index);
      });
      shouldSave = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercício apagado com sucesso.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (result != null && result is Exercise) {
      setState(() {
        chestAndTricepsWorkout[index] = result;
      });
      shouldSave = true;
    }

    if (shouldSave) {
      _saveExercises(); // NOVO: Salva após editar ou apagar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino de Peito e Tríceps'),
        backgroundColor: Colors.blueAccent,
      ),
      // NOVO: Mostra um indicador de carregamento enquanto os dados não chegam
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    itemCount: chestAndTricepsWorkout.length,
                    itemBuilder: (BuildContext context, int index) {
                      final exercise = chestAndTricepsWorkout[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[100],
                            child: Text('${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                          title: Text(exercise.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(exercise.series),
                          trailing: const Icon(Icons.edit), // Ícone alterado
                          onTap: () => _navigateToEditPage(context, index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Exercício'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}