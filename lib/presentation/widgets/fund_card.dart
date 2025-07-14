import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';// Importamos intl para formatear números
import '../../data/models/fund_model.dart';
import '../../data/models/transaction_model.dart';
import '../providers/fund_provider.dart';


// Este widget representa una tarjeta que muestra información sobre un fondo de inversión.
// Recibe un objeto `Fund` que contiene toda la información necesaria para mostrar en la tarjeta
class FundCard extends StatelessWidget {
  final Fund fund;
  // Constructor que recibe un objeto Fund.
  const FundCard({super.key, required this.fund});   // Este objeto contiene toda la información que necesitamos para mostrar en la tarjeta.

 // Este método construye la tarjeta que muestra la información del fondo.
  // Utiliza el paquete intl para formatear números como moneda.
  @override
  Widget build(BuildContext context) {
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
            // El botón cambia según el estado de suscripción.
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

  // Widget para el botón de suscribirse.
  // Este botón abre un diálogo para que el usuario pueda ingresar el monto y seleccionar el tipo de notificación.
  Widget _buildSubscribeButton(BuildContext context, Fund fund) {
    return ElevatedButton(
      onPressed: () => _showSubscriptionDialog(context, fund),
      child: const Text('Suscribirse'),
    );
  }

  //Widget para el botón de cancelar la suscripción.
  // Este botón abre un diálogo de confirmación antes de cancelar la suscripción.
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

  // Método para mostrar el Diálogo de confirmación para la cancelación de la suscripción.
  // Este diálogo pregunta al usuario si está seguro de que quiere cancelar su suscripción.
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
                  backgroundColor: Theme.of(context).colorScheme.error.withAlpha(230),
                  behavior: SnackBarBehavior.floating, 
                  margin: const EdgeInsets.all(16),   
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Línea 3
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
  // Este diálogo permite al usuario ingresar el monto a invertir y seleccionar el tipo de notificación
  void _showSubscriptionDialog(BuildContext context, Fund fund) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final fundProvider = context.read<FundProvider>();
    final notificationTypeNotifier = ValueNotifier<NotificationType>(NotificationType.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Suscribirse a ${fund.displayName}'),
        content: ValueListenableBuilder<NotificationType>(
          valueListenable: notificationTypeNotifier,
          builder: (context, currentSelection, child) {
            // `currentSelection` es el valor actual dentro de la "cajita mágica".
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // El formulario para el monto no cambia.
                Form(
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
                const SizedBox(height: 20),
                const Text('Método de notificación:', style: TextStyle(fontWeight: FontWeight.bold)),
                
                // --- LA UI DE SELECCIÓN ---
                // Una fila para mostrar los botones de radio.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Primer Radio Button (Email)
                    Radio<NotificationType>(
                      value: NotificationType.email, // El valor que representa este botón.
                      groupValue: currentSelection,  // El valor que está actualmente seleccionado.
                      // `onChanged` se ejecuta cuando el usuario toca este botón.
                      // 
                      onChanged: (value) => notificationTypeNotifier.value = value!,
                    ),
                    const Text('Email'),

                    // Segundo Radio Button (SMS)
                    Radio<NotificationType>(
                      value: NotificationType.sms,
                      groupValue: currentSelection,
                      onChanged: (value) => notificationTypeNotifier.value = value!,
                    ),
                    const Text('SMS'),
                  ],
                ),
              ],
            );
          },
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
                // Al confirmar, leemos el valor final de nuestra "cajita mágica".
                final notificationType = notificationTypeNotifier.value;
                // Y se lo pasamos a la función del "cerebro".
                final result = fundProvider.subscribeToFund(fund, amount, notificationType);
                
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                    backgroundColor: Theme.of(context).colorScheme.tertiary.withAlpha(230),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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