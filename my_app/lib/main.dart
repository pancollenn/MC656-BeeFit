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
        // --- CORREÇÃO APLICADA AQUI ---
        // Trocado CardTheme por CardThemeData
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
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
    Navigator.pop(context);
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
              accountName: Text("Bruno Silva"),
              accountEmail: Text("bruno.silva@email.com"),
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

class Exercise {
  final String name;
  final String series;

  const Exercise({required this.name, required this.series});
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

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
    // Usando o theme definido no MaterialApp para os cards
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      itemCount: chestAndTricepsWorkout.length,
      itemBuilder: (BuildContext context, int index) {
        final exercise = chestAndTricepsWorkout[index];
        return Card(
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
    return ListView(
      children: <Widget>[
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.amber,
          child: CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Bruno Silva',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            'bruno.silva@email.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.height, color: Colors.amber),
                title: const Text('Altura'),
                trailing: const Text('182 cm', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.monitor_weight, color: Colors.amber),
                title: const Text('Peso'),
                trailing: const Text('85 kg', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.cake, color: Colors.amber),
                title: const Text('Idade'),
                trailing: const Text('28 anos', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag, color: Colors.amber),
            title: const Text('Objetivo Principal'),
            trailing: const Text('Hipertrofia', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}