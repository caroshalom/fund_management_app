enum TransactionType { subscription, cancellation }
enum NotificationType { email, sms }

// Modelo de transacción que incluye el nombre del fondo, la cantidad, el tipo de transacción,
// la fecha de la transacción y un tipo de notificación opcional.
class Transaction {
  final String fundName;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final NotificationType? notificationType;

  Transaction({
    required this.fundName,
    required this.amount,
    required this.type,
    required this.date,
    this.notificationType,
  });
}