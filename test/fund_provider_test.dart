import 'package:flutter_test/flutter_test.dart';
import 'package:fund_management_app/data/models/fund_model.dart';
import 'package:fund_management_app/data/models/transaction_model.dart';
import 'package:fund_management_app/presentation/providers/fund_provider.dart';

void main() {
  // Agrupamos las pruebas relacionadas con el `FundProvider` para mantener el código organizado.
  group('Pruebas del FundProvider - Lógica de Negocio', () {
    // Declaramos las variables que se usarán en las pruebas.
    late FundProvider fundProvider;
    late Fund testFund;

    // `setUp` se ejecuta antes de cada prueba para inicializar el estado del provider.
    // Esto asegura que cada prueba comience con un estado limpio y predecible.
    setUp(() {
      fundProvider = FundProvider();
      testFund = Fund(
        id: '1',
        name: 'TEST_FUND',
        displayName: 'Fondo de Prueba',
        category: 'TEST',
        minimumAmount: 50000,
      );
    });

    // --- CASOS DE PRUEBA ---

    // Test 1: Verifica el estado inicial del provider.
    // Este test asegura que el provider comienza con un saldo y transacciones esperadas.
    test('El estado inicial debe ser correcto', () {
      // `expect` compara un valor actual con un valor esperado.
      expect(fundProvider.userBalance, 500000.0);
      expect(fundProvider.transactions.isEmpty, isTrue);
    });

    // Test 2: Verifica que una suscripción exitosa reduce el saldo y añade una transacción.
   
    test('Una suscripción exitosa debe reducir el saldo y añadir una transacción', () {
      const amount = 100000.0;
      
      //Ejecutamos el método que queremos probar.
      final result = fundProvider.subscribeToFund(testFund, amount, NotificationType.email);

      //Verificamos que el estado cambió como se esperaba.
      expect(fundProvider.userBalance, 400000.0);
      expect(testFund.isSubscribed, isTrue);
      expect(testFund.subscribedAmount, amount);
      expect(fundProvider.transactions.length, 1);
      expect(fundProvider.transactions.first.type, TransactionType.subscription);
      expect(result, '¡Suscripción exitosa!');
    });

    // Test 3: Verifica que una suscripción falla si el saldo es insuficiente.
    test('Una suscripción debe fallar si el saldo es insuficiente', () {
      const amount = 600000.0;
      final result = fundProvider.subscribeToFund(testFund, amount, NotificationType.sms);

      // Verificamos que el estado NO cambió y que se devolvió el mensaje de error correcto.
      expect(fundProvider.userBalance, 500000.0);
      expect(testFund.isSubscribed, isFalse);
      expect(fundProvider.transactions.isEmpty, isTrue);
      expect(result, 'No tienes saldo suficiente.');
    });

    // Test 4: Verifica que una suscripción falla si el monto es menor al mínimo requerido.
    test('Una suscripción debe fallar si el monto es menor al mínimo', () {
      const amount = 10000.0;
      final result = fundProvider.subscribeToFund(testFund, amount, NotificationType.email);

      expect(fundProvider.userBalance, 500000.0);
      expect(result, 'El monto es menor al mínimo requerido.');
    });

    // Test 5: Verifica que una cancelación exitosa restaura el saldo y añade una transacción.
    test('Una cancelación exitosa debe restaurar el saldo y añadir una transacción', () {
      //Primero nos suscribimos.
      fundProvider.subscribeToFund(testFund, 100000, NotificationType.email);
      expect(fundProvider.userBalance, 400000.0, reason: 'El saldo debería haber disminuido después de la suscripción');

      //Cancelamos la suscripción.
      fundProvider.cancelSubscription(testFund);

      //Verificamos que el estado se restauró correctamente.
      expect(fundProvider.userBalance, 500000.0);
      expect(testFund.isSubscribed, isFalse);
      expect(testFund.subscribedAmount, isNull);
      expect(fundProvider.transactions.length, 2); // Ahora hay 2 transacciones (suscripción y cancelación).
      expect(fundProvider.transactions.first.type, TransactionType.cancellation);
    });
  });
}