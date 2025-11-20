// lib/screens/profile_page.dart (Versão corrigida com Provider)

import 'package:flutter/material.dart'; // Import padrão do material
import 'package:provider/provider.dart';  // Import do Provider
import '../models/user_model.dart';
import '../providers/user_provider.dart'; // Import do seu UserProvider
import './edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  // 1. Tornou-se um StatelessWidget (mais simples)
  // 2. Removemos 'user' e 'onUserUpdated' do construtor
  const ProfilePage({Key? key}) : super(key: key);

  // A lógica de navegação agora usa o Provider
  void _navigateToEditProfile(BuildContext context) async {
    // Usamos context.read<>() para *chamar uma ação*
    // Ele pega o provider sem "ouvir" mudanças
    final userProvider = context.read<UserProvider>();
    
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        // Passamos o usuário atual (lido do provider) para a página de edição
        builder: (context) => EditProfilePage(user: userProvider.user!),
      ),
    );

    if (updatedUser != null && updatedUser is User) {
      // Se a página de edição retornou um usuário,
      // pedimos ao provider para processar a atualização.
      userProvider.updateUser(updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch<>() para *ler dados e ouvir mudanças*
    // Sempre que o userProvider.notifyListeners() for chamado,
    // esta tela será reconstruída com os novos dados.
    final user = context.watch<UserProvider>().user;

    // Se por algum motivo o usuário for nulo (ex: erro de carregamento)
    if (user == null) {
      return const Center(child: Text('Usuário não encontrado.'));
    }

    return ListView(
      children: <Widget>[
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.amber,
          child: CircleAvatar(
            radius: 55,
            backgroundImage: user.profileImageUrl.isEmpty
                ? null
                : NetworkImage(user.profileImageUrl),
            child: user.profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 55)
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Center(child: Text(user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
        Center(child: Text(user.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]))),
        const SizedBox(height: 20),
        
        // 3. Usando o 'Card' padrão do Flutter (como no seu código original)
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.height, color: Colors.amber),
                title: const Text('Altura'),
                trailing: Text('${user.height} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.monitor_weight, color: Colors.amber),
                title: const Text('Peso'),
                trailing: Text('${user.weight} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.cake, color: Colors.amber),
                title: const Text('Idade'),
                trailing: Text('${user.age} anos', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        
        // 4. Usando o 'Card' padrão do Flutter
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag, color: Colors.amber),
            title: const Text('Objetivo Principal'),
            trailing: Text(user.objective, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            onPressed: () {
              // Lógica de Logout (ainda a ser implementada)
            },
          ),
        ),
      ],
    );
  }
}