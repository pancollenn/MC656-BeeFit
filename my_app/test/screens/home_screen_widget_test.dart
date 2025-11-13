import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart'; // 1. Import do Provider
import 'home_screen_widget_test.mocks.dart';

import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/models/user_model.dart';
import 'package:my_app/services/user_service.dart';
// 2. Import do UserProvider (caminho confirmado)
import 'package:my_app/providers/user_provider.dart'; 

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

    // 3. Função helper para construir o widget com o Provider
    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<UserProvider>(
        // 4. Instancia o UserProvider real injetando o mockUserService
        create: (context) => UserProvider(userService: mockUserService),
        child: const MaterialApp(
          // 5. O construtor da HomeScreen agora está correto (sem parâmetros)
          home: HomeScreen(), 
        ),
      );
    }

    testWidgets('Exibe indicador de carregamento enquanto carrega usuário', (WidgetTester tester) async {
      // Simula atraso no carregamento
      when(mockUserService.loadUser()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return mockUser;
      });

      // 6. Usa a função helper para construir o widget
      await tester.pumpWidget(createWidgetUnderTest());
      
      // O primeiro pump (sem 'andSettle') mostra o estado de carregamento
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Aguarda o carregamento
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Exibe nome e email do usuário no Drawer após carregamento', (WidgetTester tester) async {
      // 6. Usa a função helper
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Espera o carregamento

      // Abre o Drawer pelo ícone padrão
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle(); // Espera a animação do drawer

      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('joao@example.com'), findsOneWidget);
    });

    testWidgets('Navega para página de perfil ao clicar no item do Drawer', (WidgetTester tester) async {
      // 6. Usa a função helper
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Espera o carregamento

      // Abre o Drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Toca no item "Perfil"
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle(); // Espera a navegação

      // Verifica se a tela mudou (ex: procurando um título 'Perfil')
      expect(find.text('Perfil'), findsOneWidget);
    });
  });
}