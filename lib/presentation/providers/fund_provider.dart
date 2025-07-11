import 'package:flutter/material.dart';
import '../../data/models/fund_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/fund_repository.dart';

//Este es el cerebro

// "with ChangeNotifier" es lo que convierte esta clase normal en un "Cerebro"
// que puede notificar a otros de sus cambios.
class FundProvider with ChangeNotifier {
  final FundRepository _fundRepository = FundRepository();

  // ESTADO DE LA APLICACIÓN: Aquí guardamos la información. Las variables privadas empiezan con "_".
  bool _isLoading = false;
  List<Fund> _funds = [];
  String? _errorMessage;
  double _userBalance = 500000.0;
  final List<Transaction> _transactions = [];

  
  // GETTERS: Son "ventanas" de solo lectura para que la UI vea el estado.
  bool get isLoading => _isLoading;
  List<Fund> get funds => _funds;
  String? get errorMessage => _errorMessage;
  double get userBalance => _userBalance;
  List<Transaction> get transactions => _transactions;


  // CONSTRUCTOR: Cuando se crea el cerebro, inmediatamente pide los datos.
  FundProvider() {
    fetchFunds();
  }

 // --- ACCIONES ---
  Future<void> fetchFunds() async {
    _isLoading = true;
    _errorMessage = null;   // Reinicia el mensaje de error antes de empezar.
    notifyListeners(); // AVISA A LA UI: "¡Estoy ocupado, muestra 'cargando'!"

      try {
      _funds = await _fundRepository.getFunds();
    } catch (e) {
      _errorMessage = "No se pudieron cargar los fondos. Revisa tu conexión o el servidor.";
    }
    
    _isLoading = false;
    notifyListeners();
  }
  // --- La lógica para suscribirse ---
  String subscribeToFund(Fund fund, double amount) {
    // Validación 1: ¿El monto es menor al mínimo requerido?
    if (amount < fund.minimumAmount) {
      return 'El monto es menor al mínimo requerido.';
    }
    // Validación 2: ¿El usuario tiene saldo suficiente?
    if (_userBalance < amount) {
      return 'No tienes saldo suficiente.';
    }

    // Si las validaciones pasan, actualizamos el estado:
    _userBalance -= amount; // Restamos el dinero del saldo.
    fund.isSubscribed = true; // Levantamos la "banderita" del fondo.
    fund.subscribedAmount = amount; // Guardamos el monto invertido

    // Anotamos la suscripción en el diario.
    _transactions.insert(0, Transaction(
      fundName: fund.displayName,
      amount: amount,
      type: TransactionType.subscription,
      date: DateTime.now(),
    ));
    
    // AVISAMOS A LA UI: "¡Hey, el saldo y un fondo han cambiado!"
    notifyListeners();
    return '¡Suscripción exitosa!'; 
  }

  // La lógica para cancelar.
  void cancelSubscription(Fund fund) {
    if (!fund.isSubscribed || fund.subscribedAmount == null) return;

    _userBalance += fund.subscribedAmount!; // Devolvemos el monto exacto que se invirtió.
    
    // Anotamos la cancelación en el diario.
    _transactions.insert(0, Transaction(
      fundName: fund.displayName,
      amount: fund.subscribedAmount!,
      type: TransactionType.cancellation,
      date: DateTime.now(),
    ));

    fund.isSubscribed = false; // Bajamos la banderita.
    fund.subscribedAmount = null; // Limpiamos el monto guardado.
    
    notifyListeners();
  }
}
