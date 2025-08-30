import 'package:flutter/material.dart';

void main() {
  runApp(const BeeFitApp());
}

class BeeFitApp extends StatelessWidget {
  const BeeFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeFit',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TrainingPage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Treino do Dia: Peito e Tríceps',
    'Perfil',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fecha o menu lateral após a seleção
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Nome do Usuário"),
              accountEmail: Text("usuario@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "B",
                  style: TextStyle(fontSize: 40.0, color: Colors.amber),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Treino'),
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                _onItemTapped(1);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// Modelo de dados para um exercício
class Exercise {
  final String name;
  final String series;

  // --- CORREÇÃO APLICADA AQUI ---
  // Adicionado 'const' ao construtor
  const Exercise({required this.name, required this.series});
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  // Agora a lista pode ser 'const' porque a classe Exercise também tem um construtor 'const'
  final List<Exercise> chestAndTricepsWorkout = const [
    Exercise(name: 'Supino Reto com Barra', series: '4 séries'),
    Exercise(name: 'Supino Inclinado com Halteres', series: '4 séries'),
    Exercise(name: 'Crucifixo na Máquina (Voador)', series: '3 séries'),
    Exercise(name: 'Mergulho nas Paralelas (Dips)', series: '3 séries'),
    Exercise(name: 'Tríceps na Polia Alta com Corda', series: '4 séries'),
    Exercise(name: 'Tríceps Francês com Halter', series: '3 séries'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: chestAndTricepsWorkout.length,
      itemBuilder: (BuildContext context, int index) {
        final exercise = chestAndTricepsWorkout[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            leading: CircleAvatar(
              backgroundColor: Colors.amber[100],
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(exercise.series),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Ação futura: Navegar para uma tela de detalhes do exercício
              print('Exercício selecionado: ${exercise.name}');
            },
          ),
        );
      },
    );
  }
}


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Página de Perfil',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}