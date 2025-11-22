import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user_model.dart';

void main() {
  group('Avaliação A5 - Testes de Unidade no User', () {

    print('\n--- INICIANDO SUÍTE DE TESTES (A5) ---');

    // ============================================================
    // CRITÉRIO 1: ANÁLISE DE VALOR LIMITE (Boundary Value Analysis)
    // Foco: Campo 'age' (Limites aceitos: 2 a 120)
    // ============================================================
    
    group('Critério: Análise de Valor Limite (Idade)', () {
      test('CT01 - Deve rejeitar idade 1 (Limite Inferior -1)', () {
        print('\n[CT01] Executando: Testando idade 1...');
        final user = _createUser(age: 1);
        final result = user.isValid();
        
        print('  -> Resultado obtido: $result (Esperado: false)');
        expect(result, isFalse);
      });

      test('CT02 - Deve aceitar idade 2 (Limite Inferior)', () {
        print('\n[CT02] Executando: Testando idade 2...');
        final user = _createUser(age: 2);
        final result = user.isValid();
        
        print('  -> Resultado obtido: $result (Esperado: true)');
        expect(result, isTrue);
      });

      test('CT03 - Deve aceitar idade 120 (Limite Superior)', () {
        print('\n[CT03] Executando: Testando idade 120...');
        final user = _createUser(age: 120);
        final result = user.isValid();
        
        print('  -> Resultado obtido: $result (Esperado: true)');
        expect(result, isTrue);
      });

      test('CT04 - Deve rejeitar idade 121 (Limite Superior +1)', () {
        print('\n[CT04] Executando: Testando idade 121...');
        final user = _createUser(age: 121);
        final result = user.isValid();
        
        print('  -> Resultado obtido: $result (Esperado: false)');
        expect(result, isFalse);
      });
    });

    // ============================================================
    // CRITÉRIO 2: PAIRWISE (Testes em Pares)
    // Variáveis Variadas: 
    //   - Idade  (Válida / Inválida)
    //   - Peso   (Válido / Inválido)
    //   - Nome   (Válido / Inválido)
    // Objetivo: Cobrir interações entre pares sem testar todas as 8 combinações.
    // ============================================================

    group('Critério: Pairwise Testing', () {
      
      // Caso 1: Tudo Válido
      // Pares cobertos: (Idade V, Peso V), (Peso V, Nome V), (Idade V, Nome V)
      test('CT05 - Pairwise 1: Idade(V), Peso(V), Nome(V) -> Deve ser VÁLIDO', () {
        print('\n[CT05] Executando: Tudo Válido...');
        final user = _createUser(age: 25, weight: 80, name: 'Bruno');
        final result = user.isValid();
        
        print('  -> Resultado obtido: $result (Esperado: true)');
        expect(result, isTrue);
      });

      // Caso 2: Idade Válida, Peso Inválido, Nome Inválido
      // Pares cobertos: (Idade V, Peso I), (Peso I, Nome I), (Idade V, Nome I)
      test('CT06 - Pairwise 2: Idade(V), Peso(I), Nome(I) -> Deve ser INVÁLIDO', () {
        print('\n[CT06] Executando: Idade Ok, mas Peso 0 e Nome vazio...');
        final user = _createUser(age: 25, weight: 0, name: '');
        final result = user.isValid();

        print('  -> Resultado obtido: $result (Esperado: false)');
        expect(result, isFalse);
      });

      // Caso 3: Idade Inválida, Peso Válido, Nome Inválido
      // Pares cobertos: (Idade I, Peso V), (Peso V, Nome I), (Idade I, Nome I)
      test('CT07 - Pairwise 3: Idade(I), Peso(V), Nome(I) -> Deve ser INVÁLIDO', () {
        print('\n[CT07] Executando: Peso Ok, mas Idade 1 e Nome vazio...');
        final user = _createUser(age: 1, weight: 80, name: '');
        final result = user.isValid();

        print('  -> Resultado obtido: $result (Esperado: false)');
        expect(result, isFalse);
      });

      // Caso 4: Idade Inválida, Peso Inválido, Nome Válido
      // Pares cobertos: (Idade I, Peso I), (Peso I, Nome V), (Idade I, Nome V)
      test('CT08 - Pairwise 4: Idade(I), Peso(I), Nome(V) -> Deve ser INVÁLIDO', () {
        print('\n[CT08] Executando: Nome Ok, mas Idade 1 e Peso 0...');
        final user = _createUser(age: 1, weight: 0, name: 'Bruno');
        final result = user.isValid();

        print('  -> Resultado obtido: $result (Esperado: false)');
        expect(result, isFalse);
      });
    });
  });
}

// Helper para facilitar a criação de usuários nos testes
User _createUser({
  int age = 25, 
  int weight = 80, 
  String name = 'User Teste',
  int height = 180 // Valor padrão válido
}) {
  return User(
    name: name,
    email: 'teste@email.com',
    height: height,
    weight: weight,
    age: age,
    objective: 'Hipertrofia',
    profileImageUrl: '',
  );
}