import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../providers/fund_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<FundProvider>().transactions;
    final formatCurrency = NumberFormat('\$ #,##0', 'es_CO');
    final formatDate = DateFormat('dd/MM/yyyy hh:mm a', 'es_CO');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text('Aún no hay transacciones.'),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isSubscription = tx.type == TransactionType.subscription;
                return ListTile(
                  leading: Icon(
                    isSubscription ? Icons.add_circle : Icons.remove_circle,
                    color: isSubscription ? theme.colorScheme.tertiary : theme.colorScheme.error,
                  ),
                  title: Text(tx.fundName),
                  subtitle: Text(formatDate.format(tx.date)),
                  trailing: Text(
                    '${isSubscription ? '+' : '-'}${formatCurrency.format(tx.amount)}',
                    style: TextStyle(
                      color: isSubscription ? theme.colorScheme.tertiary : theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}