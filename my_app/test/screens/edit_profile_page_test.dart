// O arquivo testa:
// Se a página renderiza com os dados iniciais corretos.
// Se a página atualiza os dados após a edição e retorna o usuário atualizado ao ser salva.

// test/pages/edit_profile_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importe os arquivos que você precisa testar
import 'package:my_app/models/user_model.dart'; // Mude 'seu_projeto' para o nome do seu pacote
import 'package:my_app/screens/edit_profile_page.dart';

void main() {
  // O 'group' ajuda a organizar testes relacionados
  group('EditProfilePage Widget Tests', () {

    // Cria um usuário mock para ser usado nos testes
    final mockUser = User(
      name: 'João Silva',
      email: 'joao@example.com',
      height: 180,
      weight: 75,
      age: 30,
      objective: 'Ganhar massa muscular',
      profileImageUrl: "",
    );

    // Função auxiliar para criar o widget sob teste dentro de um MaterialApp
    // Isso é necessário para que o widget tenha acesso a coisas como Navigator, Theme, etc.
    Widget createTestableWidget(User user) {
      return MaterialApp(
        home: EditProfilePage(user: user),
      );
    }

    // TESTE 1: Verifica se os campos são preenchidos com os dados iniciais do usuário
    testWidgets('deve renderizar os campos com os dados iniciais do usuário', (WidgetTester tester) async {
      // Arrange: Monta o widget
      await tester.pumpWidget(createTestableWidget(mockUser));

      // Assert: Verifica se os widgets de texto com os dados iniciais existem
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('180'), findsOneWidget);
      expect(find.text('75'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('Ganhar massa muscular'), findsOneWidget);
    });

    // TESTE 2: Verifica a edição dos campos e a funcionalidade de salvar
    testWidgets('deve atualizar os dados do usuário e fechar a tela ao salvar', (WidgetTester tester) async {
      // Arrange: Prepara um lugar para armazenar o resultado do Navigator.pop
      User? updatedUserResult;

      // Monta o widget dentro de um MaterialApp com um Builder para ter acesso a um context válido
      // e poder "capturar" o valor retornado pelo Navigator.pop
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  child: const Text('Abrir Editor'),
                  onPressed: () async {
                    final result = await Navigator.push<User>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: mockUser),
                      ),
                    );
                    updatedUserResult = result;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Abre a página de edição
      await tester.tap(find.text('Abrir Editor'));
      await tester.pumpAndSettle(); // Espera a animação de transição da página terminar

      // Act: Simula a interação do usuário
      // 1. Encontra os TextFields (vamos usar o labelText para encontrá-los)
      final nameField = find.widgetWithText(TextField, 'Nome');
      final heightField = find.widgetWithText(TextField, 'Altura (cm)');
      final weightField = find.widgetWithText(TextField, 'Peso (kg)');

      // 2. Garante que os campos foram encontrados
      expect(nameField, findsOneWidget);
      expect(heightField, findsOneWidget);
      expect(weightField, findsOneWidget);

      // 3. Simula a digitação de novos valores
      await tester.enterText(nameField, 'Maria Souza');
      await tester.enterText(heightField, '165');
      await tester.enterText(weightField, '60');
      
      // 4. Encontra e toca no botão de salvar (pode ser o ElevatedButton ou o IconButton na AppBar)
      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar Alterações'));
      await tester.pumpAndSettle(); // Espera a animação de fechar a página (pop)

      // Assert: Verifica o resultado
      // 1. A página de edição não deve mais estar visível
      expect(find.byType(EditProfilePage), findsNothing);

      // 2. O resultado capturado (updatedUserResult) não deve ser nulo
      expect(updatedUserResult, isNotNull);
      expect(updatedUserResult, isA<User>());

      // 3. Verifica se os dados no objeto retornado estão corretos
      expect(updatedUserResult!.name, 'Maria Souza');
      expect(updatedUserResult!.height, 165);
      expect(updatedUserResult!.weight, 60);
      
      // 4. Verifica se os dados não alterados permaneceram os mesmos
      expect(updatedUserResult!.age, mockUser.age);
      expect(updatedUserResult!.email, mockUser.email);
    });
  });
}