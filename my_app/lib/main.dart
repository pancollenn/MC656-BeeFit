import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importa a tela principal que agora gerencia o app

void main() {
  // Garante que os bindings do Flutter sejam inicializados antes de qualquer outra coisa.
  // É uma boa prática, especialmente quando se lida com operações assíncronas antes do runApp.
  WidgetsFlutterBinding.ensureInitialized();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
      // A "home" do aplicativo agora é o HomeScreen, que controla todo o resto.
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}