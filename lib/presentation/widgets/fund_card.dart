import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';// Importamos intl para formatear números
import '../../data/models/fund_model.dart';
import '../providers/fund_provider.dart';


// Este es el molde de nuestra tarjeta de fondo.
class FundCard extends StatelessWidget {
  final Fund fund;
  // Constructor que recibe un objeto Fund.
  const FundCard({super.key, required this.fund});   // Este objeto contiene toda la información que necesitamos para mostrar en la tarjeta.

 
  @override
  Widget build(BuildContext context) {
    // Aquí usamos intl para formatear el número como moneda.
    // Usamos el formato de moneda colombiano.
    final formatCurrency = NumberFormat('\$ #,##0', 'es_CO');
    // Obtenemos el tema actual de la aplicación.
    final theme = Theme.of(context);
   // Ahora construimos la tarjeta.
    // Usamos un Card widget para darle un estilo de tarjeta.
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fund.displayName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(fund.category),
                  backgroundColor: theme.colorScheme.secondary.withAlpha(25),
                  labelStyle: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w500)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Monto Mínimo', style: theme.textTheme.bodySmall),
                    Text(
                      formatCurrency.format(fund.minimumAmount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // MODIFICADO: Ahora el botón cambia según el estado de suscripción.
            Align(
              alignment: Alignment.centerRight,
              child: fund.isSubscribed
                  ? _buildCancelButton(context, fund) // Si está suscrito, muestra el botón de cancelar.
                  : _buildSubscribeButton(context, fund), // Si no, el de suscribirse.
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el botón de suscribirse 
  Widget _buildSubscribeButton(BuildContext context, Fund fund) {
    return ElevatedButton(
      onPressed: () => _showSubscriptionDialog(context, fund),
      child: const Text('Suscribirse'),
    );
  }

  //Widget para el botón de cancelar.
  Widget _buildCancelButton(BuildContext context, Fund fund) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () => _showCancellationDialog(context, fund),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.error),
        foregroundColor: theme.colorScheme.error,
      ),
      child: const Text('Cancelar Suscripción'),
    );
  }

  // Método para mostrar el Diálogo de confirmación para la cancelación.
  void _showCancellationDialog(BuildContext context, Fund fund) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Cancelación'),
        content: Text('¿Estás seguro de que quieres cancelar tu suscripción a ${fund.displayName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
          ElevatedButton(
            onPressed: () {
              context.read<FundProvider>().cancelSubscription(fund);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Suscripción cancelada con éxito.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );
  }
  // Método para mostrar el diálogo de suscripción.
  void _showSubscriptionDialog(BuildContext context, Fund fund) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final fundProvider = context.read<FundProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Suscribirse a ${fund.displayName}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto a invertir',
              prefixText: '\$ ',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese un monto.';
              }
              final amount = double.tryParse(value);
              if (amount == null) {
                return 'Monto inválido.';
              }
              if (amount < fund.minimumAmount) {
                return 'El monto es menor al mínimo.';
              }
              if (amount > fundProvider.userBalance) {
                return 'No tienes saldo suficiente.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final isValid = formKey.currentState?.validate() ?? false;
              if (isValid) {
                final amount = double.parse(amountController.text);
                final result = fundProvider.subscribeToFund(fund, amount);
                
                Navigator.of(ctx).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                    backgroundColor: Theme.of(context).colorScheme.tertiary, // Verde de nuestro tema
                  ),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

}

