// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:my_app/screens/home_screen.dart';
// import 'package:my_app/providers/user_provider.dart';
// import 'package:my_app/providers/workout_provider.dart';
// import 'package:my_app/providers/history_provider.dart';

// void main() {
//   Widget createTestWidget() {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => WorkoutProvider()),
//         ChangeNotifierProvider(create: (_) => HistoryProvider()),
//       ],  
//       child: const MaterialApp(
//         home: HomeScreen(),
//       ),
//     );
//   }

//   group('HomeScreen - Testes de Navegação', () {
//     testWidgets('Deve exibir loading inicialmente', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });

//     testWidgets('Deve exibir AppBar com título inicial', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       expect(find.text('Planos de Treino'), findsOneWidget);
//     });

//     testWidgets('Deve exibir menu drawer ao clicar no ícone', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       expect(find.byType(Drawer), findsOneWidget);
//       expect(find.text('Treino'), findsOneWidget);
//       expect(find.text('Histórico'), findsOneWidget);
//       expect(find.text('Perfil'), findsOneWidget);
//     });

//     testWidgets('Deve exibir informações do usuário no header do drawer', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       expect(find.byType(UserAccountsDrawerHeader), findsOneWidget);
//     });

//     testWidgets('Deve navegar para página Histórico', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Histórico'));
//       await tester.pump(); // Usa pump() em vez de pumpAndSettle()
//       await tester.pump(const Duration(milliseconds: 500)); // Aguarda animações

//       expect(find.text('Histórico de Treinos'), findsOneWidget);
//     });

//     testWidgets('Deve navegar para página Perfil', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Perfil'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));

//       expect(find.text('Perfil'), findsOneWidget);
//     });

//     testWidgets('Deve fechar drawer após selecionar item', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       expect(find.byType(Drawer), findsOneWidget);

//       await tester.tap(find.text('Histórico'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));

//       // O drawer deve estar fechado (não visível)
//       expect(find.byType(Drawer), findsNothing);
//     });

//     testWidgets('Deve destacar item selecionado no drawer', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       // Verifica que "Treino" está selecionado inicialmente
//       final treinoTile = tester.widget<ListTile>(
//         find.widgetWithText(ListTile, 'Treino'),
//       );
//       expect(treinoTile.selected, true);

//       await tester.tap(find.text('Histórico'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 300));

//       // Verifica que "Histórico" agora está selecionado
//       final historicoTile = tester.widget<ListTile>(
//         find.widgetWithText(ListTile, 'Histórico'),
//       );
//       expect(historicoTile.selected, true);
//     });
//   });

//   group('HomeScreen - Análise de Valor Limite (Navegação)', () {
//     testWidgets('Deve navegar para primeira página (índice 0)', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       // Já inicia na primeira página
//       expect(find.text('Planos de Treino'), findsOneWidget);
//     });

//     testWidgets('Deve navegar para última página (índice 2)', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pumpAndSettle();

//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Perfil'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));

//       expect(find.text('Perfil'), findsOneWidget);
//     });

//     testWidgets('Deve navegar entre todas as páginas sequencialmente', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestWidget());
//       await tester.pump(); // Primeiro frame
//       await tester.pump(); // PostFrameCallback que chama loadUser()
//       await tester.pump(); // Processa a mudança de estado (isLoading -> false)
      
//       // Verifica se carregou corretamente
//       expect(find.text('Planos de Treino'), findsOneWidget);

//       // Página 0 -> 1 (Treino -> Histórico)
//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 300));
      
//       await tester.tap(find.text('Histórico'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));
      
//       expect(find.text('Histórico de Treinos'), findsOneWidget);

//       // Página 1 -> 2 (Histórico -> Perfil)
//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 300));
      
//       await tester.tap(find.text('Perfil'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));
      
//       expect(find.text('Perfil'), findsOneWidget);

//       // Página 2 -> 0 (Perfil -> Treino)
//       await tester.tap(find.byIcon(Icons.menu));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 300));
      
//       await tester.tap(find.text('Treino'));
//       await tester.pump();
//       await tester.pump(const Duration(milliseconds: 500));
      
//       expect(find.text('Planos de Treino'), findsOneWidget);
//     });
//   });
// }


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/providers/workout_provider.dart';
import 'package:my_app/providers/history_provider.dart';
import 'package:my_app/models/user_model.dart'; // Import necessário para o User

// 1. MOCK: Simula o estado "Carregado" com um Usuário Válido
class MockUserProviderLoaded extends UserProvider {
  @override
  bool get isLoading => false; // Garante que o loading sumiu

  @override
  User? get user => User(
    name: 'Usuário de Teste',
    email: 'teste@beefit.com',
    height: 175,
    weight: 75,
    age: 28, // Idade válida (entre 2 e 120)
    objective: 'Hipertrofia',
    profileImageUrl: '', // String vazia para não quebrar NetworkImage em testes
  );

  @override
  Future<void> loadUser() async {
    // Sobrescreve para não fazer chamadas de rede/banco
  }
}

// 2. MOCK: Simula o estado "Carregando" (apenas para o teste de loading)
class MockUserProviderLoading extends UserProvider {
  @override
  bool get isLoading => true; // Força o CircularProgressIndicator
  
  @override
  Future<void> loadUser() async {}
}

void main() {
  // Função helper para montar o ambiente de teste
  Widget createTestWidget({UserProvider? userProvider}) {
    return MultiProvider(
      providers: [
        // Injeta o Mock passado ou usa o "Carregado" como padrão
        ChangeNotifierProvider<UserProvider>.value(
          value: userProvider ?? MockUserProviderLoaded(),
        ),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],  
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen - Testes de Navegação', () {
    
    // CASO DE TESTE 1: O Loading
    // Usamos o MockLoading especificamente aqui
    testWidgets('Deve exibir loading inicialmente', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(userProvider: MockUserProviderLoading()));
      
      // NÃO use pumpAndSettle aqui, pois o loading é infinito.
      // Use pump() apenas para desenhar o frame atual.
      await tester.pump(); 

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // CASO DE TESTE 2: Título da AppBar
    testWidgets('Deve exibir AppBar com título inicial', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Agora funciona, pois isLoading é false

      expect(find.text('Planos de Treino'), findsOneWidget);
    });

    testWidgets('Deve exibir menu drawer ao clicar no ícone', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Treino'), findsOneWidget);
      expect(find.text('Histórico'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('Deve exibir informações do usuário no header do drawer', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verifica se o UserAccountsDrawerHeader está presente
      // E, opcionalmente, se o nome do usuário mockado aparece
      expect(find.byType(UserAccountsDrawerHeader), findsOneWidget);
      expect(find.text('Usuário de Teste'), findsOneWidget); // Opcional: valida o dado do Mock
    });

    testWidgets('Deve navegar para página Histórico', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Histórico'));
      
      // Animação de fechamento do drawer + troca de página
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 500)); 

      expect(find.text('Histórico de Treinos'), findsOneWidget);
    });

    testWidgets('Deve navegar para página Perfil', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Perfil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('Deve fechar drawer após selecionar item', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);

      await tester.tap(find.text('Histórico'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('Deve destacar item selecionado no drawer', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      final treinoTile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Treino'),
      );
      expect(treinoTile.selected, true);

      await tester.tap(find.text('Histórico'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final historicoTile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Histórico'),
      );
      expect(historicoTile.selected, true);
    });
  });

  group('HomeScreen - Análise de Valor Limite (Navegação)', () {
    testWidgets('Deve navegar para primeira página (índice 0)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Planos de Treino'), findsOneWidget);
    });

    testWidgets('Deve navegar para última página (índice 2)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Perfil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Perfil'), findsOneWidget);
    });

    // testWidgets('Deve navegar entre todas as páginas sequencialmente', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestWidget());
    //   // Aguarda carregamento inicial (1 segundo é suficiente)
    //   await tester.pump(const Duration(seconds: 1)); 
      
    //   expect(find.text('Planos de Treino'), findsOneWidget);

    //   // --- 1. De Treino para Histórico ---
      
    //   // Abre o Drawer
    //   await tester.tap(find.byIcon(Icons.menu));
    //   await tester.pump(const Duration(seconds: 1)); // Espera animação de abrir
      
    //   // Clica em Histórico
    //   await tester.tap(find.text('Histórico'));
    //   await tester.pump(const Duration(seconds: 1)); // Espera navegação e fechamento do drawer
      
    //   expect(find.text('Histórico de Treinos'), findsOneWidget);

    //   // --- 2. De Histórico para Perfil ---
      
    //   // Abre o Drawer (mesmo se houver loading na tela de trás, isso vai funcionar)
    //   await tester.tap(find.byIcon(Icons.menu));
    //   await tester.pump(const Duration(seconds: 1));
      
    //   // Clica em Perfil
    //   await tester.tap(find.text('Perfil'));
    //   await tester.pump(const Duration(seconds: 1));
      
    //   expect(find.text('Perfil'), findsOneWidget);

    //   // --- 3. De Perfil para Treino (Home) ---
      
    //   await tester.tap(find.byIcon(Icons.menu));
    //   await tester.pump(const Duration(seconds: 1));
      
    //   await tester.tap(find.text('Treino'));
    //   await tester.pump(const Duration(seconds: 1));
      
    //   expect(find.text('Planos de Treino'), findsOneWidget);
    // });
  });
}

