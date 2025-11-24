// lib/screens/edit_profile_page.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';

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
    // Preenche os controladores com os dados do usuário recebido
    _nameController = TextEditingController(text: widget.user.name);
    _heightController = TextEditingController(text: widget.user.height.toString());
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _ageController = TextEditingController(text: widget.user.age.toString());
    _objectiveController = TextEditingController(text: widget.user.objective);
  }

  @override
  void dispose() {
    // Sempre limpe os controladores
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _objectiveController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Cria um novo objeto User com os dados atualizados
    final updatedUser = User(
      name: _nameController.text,
      email: widget.user.email, // Preserva o email original (não editável aqui)
      height: int.tryParse(_heightController.text) ?? widget.user.height,
      weight: int.tryParse(_weightController.text) ?? widget.user.weight,
      age: int.tryParse(_ageController.text) ?? widget.user.age,
      objective: _objectiveController.text,
      profileImageUrl: widget.user.profileImageUrl, // Preserva a imagem original
    );
    
    // Retorna o objeto User atualizado para a tela anterior (ProfilePage)
    Navigator.pop(context, updatedUser);
  }

  // Extrai método para criar TextField e reduzir duplicação (Dispensables)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }

  // Extrai lista de campos para reduzir tamanho do build() (Bloaters)
  List<Widget> _buildFormFields() {
    return [
      _buildTextField(controller: _nameController, label: 'Nome'),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _heightController,
        label: 'Altura (cm)',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _weightController,
        label: 'Peso (kg)',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _ageController,
        label: 'Idade',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      _buildTextField(controller: _objectiveController, label: 'Objetivo'),
      const SizedBox(height: 32),
      ElevatedButton(
        child: const Text('Salvar Alterações'),
        onPressed: _saveProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile)
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _buildFormFields(), // Reduz complexidade do build()
      ),
    );
  }
}