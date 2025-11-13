import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'home_screen_widget_test.mocks.dart';

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

      await tester.pumpWidget(MaterialApp(home: HomeScreen(userService: mockUserService)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Aguarda o carregamento
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Exibe nome e email do usuário no Drawer após carregamento', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(userService: mockUserService)));
      await tester.pumpAndSettle();

      // Abre o Drawer pelo ícone padrão
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('joao@example.com'), findsOneWidget);
    });

    testWidgets('Navega para página de perfil ao clicar no item do Drawer', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(userService: mockUserService)));
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
  });
}
