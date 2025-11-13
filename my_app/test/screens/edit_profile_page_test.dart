import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart'; // 1. Importar Mockito
import 'package:mockito/mockito.dart';      // 1. Importar Mockito
import 'package:provider/provider.dart';  // 1. Importar Provider

import 'package:my_app/models/user_model.dart';
import 'package:my_app/screens/edit_profile_page.dart';
import 'package:my_app/services/user_service.dart';      // 1. Importar Service
import 'package:my_app/providers/user_provider.dart';    // 1. Importar Provider

// 2. Importar o mock gerado (presumindo que está no mesmo local do home_screen_test)
import '../screens/home_screen_widget_test.mocks.dart'; 

// 3. Gerar mocks para o UserService
@GenerateMocks([UserService])
void main() {
  group('EditProfilePage Widget Tests', () {

    // 4. Mover mocks para o escopo do grupo
    late MockUserService mockUserService;
    late UserProvider userProvider;
    final mockUser = User(
      name: 'João Silva',
      email: 'joao@example.com',
      height: 180,
      weight: 75,
      age: 30,
      objective: 'Ganhar massa muscular',
      profileImageUrl: "",
    );

    // 5. Configurar os mocks e o provider ANTES de cada teste
    setUp(() {
      mockUserService = MockUserService();
      // Configura o mock para salvar
      when(mockUserService.saveUser(any)).thenAnswer((_) async {});
      
      // Configura o mock para carregar (para o estado inicial)
      when(mockUserService.loadUser()).thenAnswer((_) async => mockUser);
      
      // Cria o provider real com o serviço mockado
      userProvider = UserProvider(userService: mockUserService);
    });

    // 6. Função helper refatorada
    // Ela agora recebe o provider já carregado
    Widget createTestableWidget(UserProvider provider) {
      return ChangeNotifierProvider<UserProvider>.value(
        value: provider,
        child: MaterialApp(
          // 7. Construtor da EditProfilePage agora é const (sem parâmetros)
          home: const EditProfilePage(),
        ),
      );
    }

    // TESTE 1: Verifica se os campos são preenchidos com os dados do PROVIDER
    testWidgets('deve renderizar os campos com os dados iniciais do usuário', (WidgetTester tester) async {
      // Arrange: Carrega o provider com os dados ANTES de construir o widget
      await userProvider.loadUser();
      
      // Act: Monta o widget
      await tester.pumpWidget(createTestableWidget(userProvider));

      // Assert: Verifica se os campos (TextFormField) contêm os dados
      // É melhor verificar o 'text' dentro dos TextFormFields do que 'find.text()'
      expect(find.widgetWithText(TextFormField, 'João Silva'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '180'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '75'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '30'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Ganhar massa muscular'), findsOneWidget);
    });

    // TESTE 2: Verifica a edição e se o PROVIDER é atualizado
    testWidgets('deve atualizar os dados do usuário no provider ao salvar', (WidgetTester tester) async {
      // Arrange: Carrega o provider
      await userProvider.loadUser();

      // Monta o widget
      await tester.pumpWidget(createTestableWidget(userProvider));

      // Act: Simula a interação do usuário
      // 1. Encontra os TextFields (vamos usar o labelText para encontrá-los)
      final nameField = find.widgetWithText(TextFormField, 'Nome');
      final heightField = find.widgetWithText(TextFormField, 'Altura (cm)');
      final weightField = find.widgetWithText(TextFormField, 'Peso (kg)');

      // 2. Simula a digitação
      await tester.enterText(nameField, 'Maria Souza');
      await tester.enterText(heightField, '165');
      await tester.enterText(weightField, '60');
      
      // 3. Toca no botão de salvar
      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar Alterações'));
      await tester.pumpAndSettle(); // Espera a lógica de salvar e o pop

      // Assert: Verifica o resultado
      // 1. A página de edição não deve mais estar visível
      expect(find.byType(EditProfilePage), findsNothing);

      // 2. O provider (userProvider.user) deve ter sido atualizado
      expect(userProvider.user, isNotNull);
      expect(userProvider.user!.name, 'Maria Souza');
      expect(userProvider.user!.height, 165);
      expect(userProvider.user!.weight, 60);
      
      // 3. Verifica se o mockUserService.saveUser foi chamado UMA vez
      verify(mockUserService.saveUser(any)).called(1);
    });
  });
}