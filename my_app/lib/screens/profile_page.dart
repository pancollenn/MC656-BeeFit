import 'package:flutter/material.dart';
import '../models/user_model.dart';
import './edit_profile_page.dart';

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
            backgroundImage: widget.user.profileImageUrl.isEmpty
                ? null
                : NetworkImage(widget.user.profileImageUrl),
            child: widget.user.profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 55)
                : null,
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