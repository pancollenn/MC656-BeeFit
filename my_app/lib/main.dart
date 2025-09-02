import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote

// A classe User permanece a mesma
class User {
  String name;
  String email;
  int height;
  int weight;
  int age;
  String objective;
  String profileImageUrl;

  User({
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.objective,
    required this.profileImageUrl,
  });
}

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
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
  // O usuário agora pode ser nulo enquanto carregamos os dados
  User? _user;

  @override
  void initState() {
    super.initState();
    // Carrega os dados do usuário ao iniciar a tela
    _loadUser();
  }

  // --- LÓGICA DE CARREGAMENTO ---
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    // Tenta ler cada valor, se não existir, usa um valor padrão
    final name = prefs.getString('userName') ?? 'Bruno Silva';
    final email = prefs.getString('userEmail') ?? 'bruno.silva@email.com';
    final height = prefs.getInt('userHeight') ?? 182;
    final weight = prefs.getInt('userWeight') ?? 85;
    final age = prefs.getInt('userAge') ?? 28;
    final objective = prefs.getString('userObjective') ?? 'Hipertrofia';
    final profileImageUrl = prefs.getString('userProfileImageUrl') ?? 'https://via.placeholder.com/150';

    // Atualiza o estado com os dados carregados
    setState(() {
      _user = User(
        name: name,
        email: email,
        height: height,
        weight: weight,
        age: age,
        objective: objective,
        profileImageUrl: profileImageUrl,
      );
    });
  }

  // --- LÓGICA DE SALVAMENTO ---
  Future<void> _updateAndSaveUser(User updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    // Salva cada valor com uma chave única
    await prefs.setString('userName', updatedUser.name);
    await prefs.setString('userEmail', updatedUser.email);
    await prefs.setInt('userHeight', updatedUser.height);
    await prefs.setInt('userWeight', updatedUser.weight);
    await prefs.setInt('userAge', updatedUser.age);
    await prefs.setString('userObjective', updatedUser.objective);
    await prefs.setString('userProfileImageUrl', updatedUser.profileImageUrl);

    // Atualiza o estado da tela
    setState(() {
      _user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se o usuário ainda não foi carregado, mostra uma tela de loading
    if (_user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Se o usuário já foi carregado, constrói a tela normal
    final List<Widget> pages = [
      const TrainingPage(),
      ProfilePage(user: _user!, onUserUpdated: _updateAndSaveUser),
    ];

    final List<String> pageTitles = ['Treino do Dia: Peito e Tríceps', 'Perfil'];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_user!.name),
              accountEmail: Text(_user!.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("B", style: TextStyle(fontSize: 40.0, color: Colors.amber)),
              ),
              decoration: const BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Treino'),
              onTap: () => onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () => onItemTapped(1),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}

// O restante do código (TrainingPage, ProfilePage, EditProfilePage)
// permanece EXATAMENTE O MESMO da versão anterior.
// Vou incluí-lo abaixo para que você possa copiar e colar tudo de uma vez.

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
              child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(exercise.series),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => print('Exercício selecionado: ${exercise.name}'),
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  final User user;
  final Function(User) onUserUpdated;

  const ProfilePage({
    Key? key,
    required this.user,
    required this.onUserUpdated,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _navigateToEditProfile(BuildContext context) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: widget.user)),
    );

    if (updatedUser != null) {
      widget.onUserUpdated(updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.amber,
          child: CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(widget.user.profileImageUrl),
          ),
        ),
        const SizedBox(height: 10),
        Center(child: Text(widget.user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
        Center(child: Text(widget.user.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]))),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.height, color: Colors.amber),
                title: const Text('Altura'),
                trailing: Text('${widget.user.height} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.monitor_weight, color: Colors.amber),
                title: const Text('Peso'),
                trailing: Text('${widget.user.weight} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.cake, color: Colors.amber),
                title: const Text('Idade'),
                trailing: Text('${widget.user.age} anos', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag, color: Colors.amber),
            title: const Text('Objetivo Principal'),
            trailing: Text(widget.user.objective, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _navigateToEditProfile(context),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  late TextEditingController _objectiveController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _heightController = TextEditingController(text: widget.user.height.toString());
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _ageController = TextEditingController(text: widget.user.age.toString());
    _objectiveController = TextEditingController(text: widget.user.objective);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _objectiveController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = User(
      name: _nameController.text,
      email: widget.user.email,
      height: int.tryParse(_heightController.text) ?? widget.user.height,
      weight: int.tryParse(_weightController.text) ?? widget.user.weight,
      age: int.tryParse(_ageController.text) ?? widget.user.age,
      objective: _objectiveController.text,
      profileImageUrl: widget.user.profileImageUrl,
    );
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 16),
          TextField(controller: _heightController, decoration: const InputDecoration(labelText: 'Altura (cm)'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextField(controller: _weightController, decoration: const InputDecoration(labelText: 'Peso (kg)'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Idade'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextField(controller: _objectiveController, decoration: const InputDecoration(labelText: 'Objetivo')),
          const SizedBox(height: 32),
          ElevatedButton(child: const Text('Salvar Alterações'), onPressed: _saveProfile),
        ],
      ),
    );
  }
}