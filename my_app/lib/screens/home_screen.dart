import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe
import '../providers/user_provider.dart'; // Importe
import './profile_page.dart';
import './training_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Carrega o usuário assim que o app é iniciado
    // context.read<...>() pega o provider sem "ouvir" mudanças
    // Usamos 'listen: false' fora do build para evitar reconstruções
    Provider.of<UserProvider>(context, listen: false).loadUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fecha o Drawer
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<...>() "ouve" as mudanças no provider
    // Quando 'notifyListeners()' é chamado, este 'build' será refeito.
    final userProvider = context.watch<UserProvider>();

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Se não está carregando e o usuário é nulo (erro), mostre um erro
    if (userProvider.user == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar usuário.')),
      );
    }

    final user = userProvider.user!;

    // As páginas não precisam mais receber o usuário por parâmetro!
    final List<Widget> pages = [
      const TrainingPage(),
      const ProfilePage(),
    ];

    final List<String> pageTitles = ['Treino do Dia: Peito e Tríceps', 'Perfil'];

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.name),    // Pega do provider
              accountEmail: Text(user.email), // Pega do provider
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("B", style: TextStyle(fontSize: 40.0, color: Colors.amber)),
              ),
              decoration: const BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Treino'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}