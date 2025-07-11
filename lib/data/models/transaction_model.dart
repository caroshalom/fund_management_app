// Se definen dos tipos de transacciones: 'subscription' y 'cancellation'.
enum TransactionType { subscription, cancellation }

class Transaction {
  final String fundName;
  final double amount;
  final TransactionType type;
  final DateTime date;

  Transaction({
    required this.fundName,
    required this.amount,
    required this.type,
    required this.date,
  });
}