import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  // Salva o objeto User no SharedPreferences
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setInt('userHeight', user.height);
    await prefs.setInt('userWeight', user.weight);
    await prefs.setInt('userAge', user.age);
    await prefs.setString('userObjective', user.objective);
    await prefs.setString('userProfileImageUrl', user.profileImageUrl);
  }

  // Carrega o objeto User do SharedPreferences
  Future<User> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Tenta ler cada valor, se não existir, usa um valor padrão
    final name = prefs.getString('userName') ?? 'Bruno Silva';
    final email = prefs.getString('userEmail') ?? 'bruno.silva@email.com';
    final height = prefs.getInt('userHeight') ?? 182;
    final weight = prefs.getInt('userWeight') ?? 85;
    final age = prefs.getInt('userAge') ?? 28;
    final objective = prefs.getString('userObjective') ?? 'Hipertrofia';
    final profileImageUrl = prefs.getString('userProfileImageUrl') ?? 'https://via.placeholder.com/150';

    return User(
      name: name,
      email: email,
      height: height,
      weight: weight,
      age: age,
      objective: objective,
      profileImageUrl: profileImageUrl,
    );
  }
}