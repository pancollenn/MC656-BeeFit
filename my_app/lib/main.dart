import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe o Provider
import 'screens/home_screen.dart';
import 'providers/user_provider.dart';    // Importe seu UserProvider
import 'providers/workout_provider.dart'; // Importe seu WorkoutProvider

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BeeFitApp());
}

class BeeFitApp extends StatelessWidget {
  const BeeFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MultiProvider permite "prover" vários providers de uma vez
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutProvider(),
        ),
      ],
      child: MaterialApp(
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
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}