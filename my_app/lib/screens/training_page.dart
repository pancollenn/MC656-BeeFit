import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'workout_plan_details_page.dart'; // Importe a nova tela de detalhes

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {
  @override
  void initState() {
    super.initState();
    // Agora chama loadPlans() em vez de loadExercises()
    Provider.of<WorkoutProvider>(context, listen: false).loadPlans();
  }

  // Navega para a tela de detalhes passando o índice do plano
  void _navigateToPlanDetails(int planIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlanDetailsPage(planIndex: planIndex),
      ),
    );
  }

  // Mostra um diálogo para adicionar um novo plano
  void _showAddPlanDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Plano de Treino'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome do Plano (ex: Treino C)'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<WorkoutProvider>().addPlan(nameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showStopwatchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const StopwatchDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      // A AppBar foi movida para a tela de detalhes
      body: workoutProvider.isLoading
          ? const Center(child: Text('Carregando planos...'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: workoutProvider.plans.length,
              itemBuilder: (context, index) {
                final plan = workoutProvider.plans[index];
                return Card(
                  child: ListTile(
                    title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${plan.exercises.length} exercícios'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _navigateToPlanDetails(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanDialog,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Plano',
        backgroundColor: Colors.amber,
      ),
    );
  }
}