import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user_model.dart';

void main() {
  group('Avaliação A5 - Testes de Unidade no User', () {

    // ============================================================
    // CRITÉRIO 1: ANÁLISE DE VALOR LIMITE (Boundary Value Analysis)
    // Foco: Campo 'age' (Limites: 2 e 120)
    // ============================================================
    
    group('Análise de Valor Limite (Idade)', () {
      test('CT01 - Deve rejeitar idade 1 (Logo abaixo do limite mínimo)', () {
        final user = _createUser(age: 1);
        expect(user.isValid(), isFalse);
      });

      test('CT02 - Deve aceitar idade 2 (Limite mínimo exato)', () {
        final user = _createUser(age: 2);
        expect(user.isValid(), isTrue);
      });

      test('CT03 - Deve aceitar idade 120 (Limite máximo exato)', () {
        final user = _createUser(age: 120);
        expect(user.isValid(), isTrue);
      });

      test('CT04 - Deve rejeitar idade 121 (Logo acima do limite máximo)', () {
        final user = _createUser(age: 121);
        expect(user.isValid(), isFalse);
      });
    });

    // ============================================================
    // CRITÉRIO 2: PAIRWISE (Testes em Pares)
    // Variáveis: Idade (Válida/Inválida), Peso (Válido/Inválido), Nome (Válido/Inválido)
    // Objetivo: Cobrir interações entre campos sem exaustão combinatória
    // ============================================================

    group('Pairwise Testing (Combinação de Campos)', () {
      
      // Cenário 1: Tudo Válido
      // Pares cobertos: (Idade V, Peso V), (Peso V, Nome V), (Idade V, Nome V)
      test('CT05 - Pairwise 1: Idade Válida, Peso Válido, Nome Válido -> VÁLIDO', () {
        final user = _createUser(age: 25, weight: 80, name: 'Bruno');
        expect(user.isValid(), isTrue);
      });

      // Cenário 2: Idade Válida, mas outros Inválidos
      // Pares cobertos: (Idade V, Peso I), (Peso I, Nome I), (Idade V, Nome I)
      test('CT06 - Pairwise 2: Idade Válida, Peso Inválido, Nome Inválido -> INVÁLIDO', () {
        final user = _createUser(age: 25, weight: 0, name: '');
        expect(user.isValid(), isFalse);
      });

      // Cenário 3: Idade Inválida, Peso Válido, Nome Inválido
      // Pares cobertos: (Idade I, Peso V), (Peso V, Nome I), (Idade I, Nome I)
      test('CT07 - Pairwise 3: Idade Inválida, Peso Válido, Nome Inválido -> INVÁLIDO', () {
        final user = _createUser(age: 1, weight: 80, name: '');
        expect(user.isValid(), isFalse);
      });

      // Cenário 4: Idade Inválida, Peso Inválido, Nome Válido
      // Pares cobertos: (Idade I, Peso I), (Peso I, Nome V), (Idade I, Nome V)
      test('CT08 - Pairwise 4: Idade Inválida, Peso Inválido, Nome Válido -> INVÁLIDO', () {
        final user = _createUser(age: 1, weight: 0, name: 'Bruno');
        expect(user.isValid(), isFalse);
      });
    });
  });
}

// Helper para criar usuário facilmente nos testes (Evita repetição de código)
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