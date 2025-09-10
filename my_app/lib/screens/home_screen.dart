import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import './profile_page.dart';
import './training_page.dart';

class HomeScreen extends StatefulWidget {
  final UserService? userService;
  const HomeScreen({Key? key, this.userService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  User? _user;
  late final UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = widget.userService ?? UserService();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await _userService.loadUser();
    setState(() {
      _user = loadedUser;
    });
  }

  Future<void> _updateUser(User updatedUser) async {
    await _userService.saveUser(updatedUser);
    setState(() {
      _user = updatedUser;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      const TrainingPage(),
      ProfilePage(user: _user!, onUserUpdated: _updateUser),
    ];

    final List<String> pageTitles = ['Treino do Dia: Peito e Tríceps', 'Perfil'];

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