// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;
  
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // O construtor agora pode receber o service
  UserProvider({UserService? userService}) : _userService = userService ?? UserService();

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners(); // Notifica a UI que estamos carregando
    _user = await _userService.loadUser();
    _isLoading = false;
    notifyListeners(); // Notifica a UI que os dados chegaram
  }

  Future<void> updateUser(User updatedUser) async {
    await _userService.saveUser(updatedUser);
    _user = updatedUser;
    notifyListeners(); // Notifica a UI sobre a mudança
  }
}