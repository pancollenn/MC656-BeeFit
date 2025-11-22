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

  // Método de validação para o Teste
  bool isValid() {
    if (name.isEmpty) return false;
    // CRITÉRIO: Idade mínima 2, máxima 120
    if (age < 2 || age > 120) return false;
    if (weight <= 0) return false;
    if (height <= 0) return false;
    return true;
  }
}