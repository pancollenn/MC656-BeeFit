import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/providers/workout_provider.dart';
import 'package:my_app/providers/history_provider.dart';

void main() {
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],  
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen - Testes de Navegação', () {
    testWidgets('Deve exibir loading inicialmente', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve exibir AppBar com título inicial', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

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

      expect(find.byType(UserAccountsDrawerHeader), findsOneWidget);
    });

    testWidgets('Deve navegar para página Histórico', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Histórico'));
      await tester.pump(); // Usa pump() em vez de pumpAndSettle()
      await tester.pump(const Duration(milliseconds: 500)); // Aguarda animações

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

      // O drawer deve estar fechado (não visível)
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('Deve destacar item selecionado no drawer', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verifica que "Treino" está selecionado inicialmente
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

      // Verifica que "Histórico" agora está selecionado
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

      // Já inicia na primeira página
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

    testWidgets('Deve navegar entre todas as páginas sequencialmente', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Primeiro frame
      await tester.pump(); // PostFrameCallback que chama loadUser()
      await tester.pump(); // Processa a mudança de estado (isLoading -> false)
      
      // Verifica se carregou corretamente
      expect(find.text('Planos de Treino'), findsOneWidget);

      // Página 0 -> 1 (Treino -> Histórico)
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(find.text('Histórico'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Histórico de Treinos'), findsOneWidget);

      // Página 1 -> 2 (Histórico -> Perfil)
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(find.text('Perfil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Perfil'), findsOneWidget);

      // Página 2 -> 0 (Perfil -> Treino)
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(find.text('Treino'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Planos de Treino'), findsOneWidget);
    });
  });
}
