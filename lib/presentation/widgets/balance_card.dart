import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  const BalanceCard({super.key, required this.balance});

  // Este widget representa una tarjeta que muestra el saldo del usuario.
  // Utiliza un formato de moneda específico para mostrar el saldo.
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat('\$ #,##0', 'es_CO');

    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo Disponible',
                  style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(204)),
                ),
                Text(
                  formatCurrency.format(balance),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}