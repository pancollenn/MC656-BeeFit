import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'home_screen_widget_test.mocks.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/providers/workout_provider.dart';

import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/models/user_model.dart';
import 'package:my_app/services/user_service.dart';

@GenerateMocks([UserService])

void main() {
  group('HomeScreen Widget Tests', () {
    late MockUserService mockUserService;
    final mockUser = User(
      name: 'João Silva',
      email: 'joao@example.com',
      height: 180,
      weight: 75,
      age: 30,
      objective: 'Ganhar massa muscular',
      profileImageUrl: "",
    );

    setUp(() {
      mockUserService = MockUserService();
      when(mockUserService.loadUser()).thenAnswer((_) async => mockUser);
      when(mockUserService.saveUser(any)).thenAnswer((_) async {});
    });

    testWidgets('Exibe indicador de carregamento enquanto carrega usuário', (WidgetTester tester) async {
      // Simula atraso no carregamento
      when(mockUserService.loadUser()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return mockUser;
      });

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(userService: mockUserService),
          ),
          ChangeNotifierProvider<WorkoutProvider>(
            create: (_) => WorkoutProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Aguarda o carregamento
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Exibe nome e email do usuário no Drawer após carregamento', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(userService: mockUserService),
          ),
          ChangeNotifierProvider<WorkoutProvider>(
            create: (_) => WorkoutProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ));
      await tester.pumpAndSettle();

      // Abre o Drawer pelo ícone padrão
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('joao@example.com'), findsOneWidget);
    });

    testWidgets('Navega para página de perfil ao clicar no item do Drawer', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(userService: mockUserService),
          ),
          ChangeNotifierProvider<WorkoutProvider>(
            create: (_) => WorkoutProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ));
      await tester.pumpAndSettle();

      // Abre o Drawer pelo ícone padrão
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Toca no item "Perfil"
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      // Verifica se o título mudou para "Perfil"
      expect(find.text('Perfil'), findsOneWidget);
    });

    // Boundary Value Analysis: idade mínima (0 anos)
    testWidgets('Profile exibe idade mínima (BVA)', (WidgetTester tester) async {
      final minUser = User(
        name: 'Minimo',
        email: 'min@example.com',
        height: 100,
        weight: 30,
        age: 0,
        objective: 'Manter',
        profileImageUrl: '',
      );

      when(mockUserService.loadUser()).thenAnswer((_) async => minUser);

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(userService: mockUserService),
          ),
          ChangeNotifierProvider<WorkoutProvider>(
            create: (_) => WorkoutProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ));

      await tester.pumpAndSettle();

      // Navega para Perfil
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      // Verifica exibição da idade mínima
      expect(find.text('0 anos'), findsOneWidget);
    });

    // Boundary Value Analysis: idade máxima (120 anos)
    testWidgets('Profile exibe idade máxima (BVA)', (WidgetTester tester) async {
      final maxUser = User(
        name: 'Maximo',
        email: 'max@example.com',
        height: 220,
        weight: 200,
        age: 120,
        objective: 'Perda',
        profileImageUrl: '',
      );

      when(mockUserService.loadUser()).thenAnswer((_) async => maxUser);

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(userService: mockUserService),
          ),
          ChangeNotifierProvider<WorkoutProvider>(
            create: (_) => WorkoutProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ));

      await tester.pumpAndSettle();

      // Navega para Perfil
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      // Verifica exibição da idade máxima
      expect(find.text('120 anos'), findsOneWidget);
    });
  });
}
