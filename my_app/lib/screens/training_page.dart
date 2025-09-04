import 'package:flutter/material.dart';
import '../models/exercise_model.dart'; // Certifique-se de que este caminho está correto
import 'edit_exercise_page.dart';

// 1. Transformar em StatefulWidget
class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  // 2. Mover a lista de exercícios para o State e torná-la mutável
  List<Exercise> chestAndTricepsWorkout = [
    Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
    Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
    Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
    Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
    Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
    Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
  ];

  // Função para adicionar um novo exercício
  void _addExercise() {
    setState(() {
      // Aqui você pode adicionar lógica para abrir uma tela de formulário
      // para o usuário preencher os detalhes do novo exercício.
      // Por enquanto, vamos adicionar um exercício de exemplo.
      chestAndTricepsWorkout.add(
        Exercise(name: 'Novo Exercício Adicionado', series: '3 séries de 12'),
      );
    });
    // Você pode querer rolar para o final da lista após adicionar um item
    // ou exibir uma mensagem de sucesso.
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

    // MUDANÇA AQUI: Adicionamos a lógica para tratar a exclusão
    if (result == 'DELETE') {
      setState(() {
        chestAndTricepsWorkout.removeAt(index);
      });
      // Opcional: Mostrar uma mensagem de confirmação
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
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino de Peito e Tríceps'),
        backgroundColor: Colors.blueAccent, // Ou sua cor preferida
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              itemCount: chestAndTricepsWorkout.length,
              itemBuilder: (BuildContext context, int index) {
                final exercise = chestAndTricepsWorkout[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber[100],
                      child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(exercise.series),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToEditPage(context, index),
                  ),
                );
              },
            ),
          ),
          // 3. Adicionar o botão "Adicionar Exercício"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addExercise, // Chama a função para adicionar exercício
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Exercício'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Botão de largura total
                backgroundColor: Colors.green, // Cor do botão
                foregroundColor: Colors.white, // Cor do texto e ícone
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}