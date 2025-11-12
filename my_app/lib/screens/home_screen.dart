// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import './profile_page.dart';
import './training_page.dart';
import './history_page.dart'; // 1. IMPORTA A NOVA TELA

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O 'Treino' (TrainingPage) agora é o índice 0
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Carrega o usuário assim que o app é iniciado
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
    final userProvider = context.watch<UserProvider>();

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Se não está carregando e o usuário é nulo (erro)
    if (userProvider.user == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar usuário.')),
      );
    }

    final user = userProvider.user!;

    // 2. ADICIONA A TELA E O TÍTULO ÀS LISTAS
    // A ordem aqui deve bater com a ordem do Drawer
    final List<Widget> pages = [
      const TrainingPage(),
      const HistoryPage(), // Adicionada
      const ProfilePage(),
    ];

    final List<String> pageTitles = [
      'Planos de Treino', // Título atualizado
      'Histórico de Treinos', // Adicionado
      'Perfil',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("B", style: TextStyle(fontSize: 40.0, color: Colors.amber)),
              ),
              decoration: const BoxDecoration(color: Colors.amber),
            ),
            
            // Item "Treino"
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Treino'),
              selected: _selectedIndex == 0, // Destaque visual
              onTap: () => _onItemTapped(0),
            ),
            
            // 3. ADICIONA O ITEM NO MENU DRAWER
            // Item "Histórico"
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              selected: _selectedIndex == 1, // Destaque visual
              onTap: () => _onItemTapped(1),
            ),
            
            // Item "Perfil"
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _selectedIndex == 2, // Destaque visual
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}