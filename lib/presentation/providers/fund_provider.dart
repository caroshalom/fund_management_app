import 'package:flutter/material.dart';
import '../../data/models/fund_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/fund_repository.dart';

// FundProvider es el encargado de manejar el estado de los fondos y las transacciones.
// Utiliza ChangeNotifier para notificar a la UI cuando hay cambios en el estado.
class FundProvider with ChangeNotifier {
  final FundRepository _fundRepository = FundRepository();

  // ESTADO DE LA APLICACIÓN: Aquí guardamos la información. 
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


  // CONSTRUCTOR 
  FundProvider() {
    fetchFunds();
  }

 // --- ACCIONES ---    
  // Método para obtener los fondos desde el repositorio.
  // Aquí es donde se inicia la comunicación con la API.
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
  // Este método maneja la lógica de suscripción a un fondo.   
  String subscribeToFund(Fund fund, double amount, NotificationType notificationType) {
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

    // Anotamos la suscripción en el diario de transacciones.
    // Aquí usamos el displayName del fondo para que sea más amigable en el registro.
    _transactions.insert(0, Transaction(
      fundName: fund.displayName,
      amount: amount,
      type: TransactionType.subscription,
      date: DateTime.now(),
      notificationType: notificationType,
    ));
    
    // AVISAMOS A LA UI: "¡Hey, el saldo y un fondo han cambiado!"
    notifyListeners();
    return '¡Suscripción exitosa!'; 
  }

  //Metodo para cancelar la suscripción
  // Este método maneja la lógica de cancelación de una suscripción a un fondo.
  void cancelSubscription(Fund fund) {
    // si el fondo no está suscrito o no tiene monto, no hacemos nada.
    if (!fund.isSubscribed || fund.subscribedAmount == null) return;

    _userBalance += fund.subscribedAmount!; // Devolvemos el monto exacto que se invirtió.
    
    // Anotamos la cancelación en el diario de transacciones.
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
