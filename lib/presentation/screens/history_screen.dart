// Esta pantalla tiene una única responsabilidad: mostrar la lista de transacciones
// que le proporciona el "cerebro" (FundProvider).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/transaction_model.dart';
import '../providers/fund_provider.dart';

/// Pantalla de historial de transacciones
/// Esta pantalla muestra una lista de transacciones realizadas por el usuario.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  /// Método de construcción de la pantalla
  /// Aquí es donde se define cómo se verá la pantalla y qué datos mostrará.
  @override
  Widget build(BuildContext context) {
    // 1. OBTENER LAS TRANSACCIONES
    // Usamos `context.watch` para obtener las transacciones del FundProvider.
    // Esto asegura que la pantalla se reconstruya automáticamente si hay cambios en las transacciones.
    final transactions = context.watch<FundProvider>().transactions;
    
    // 2. FORMATEO DE DATOS
    // Aquí definimos cómo formatear los datos que vamos a mostrar.
    // Usamos `intl` para formatear números y fechas de manera local.
    final formatCurrency = NumberFormat('\$ #,##0', 'es_CO');
    final formatDate = DateFormat('dd/MM/yyyy hh:mm a', 'es_CO');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      // 3. LÓGICA DE VISUALIZACIÓN
      body: transactions.isEmpty
          // Si la lista de transacciones está vacía, muestra un mensaje central.
          ? const Center(
              child: Text('Aún no hay transacciones.'),
            )
          // Si hay transacciones, construye una lista.
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                // Para cada elemento en la lista, obtenemos la transacción.
                final tx = transactions[index];
                final isSubscription = tx.type == TransactionType.subscription;
                
                // Usamos una Card para cada transacción para un mejor diseño.
                return Card(
                  elevation: 1,
                  child: ListTile(
                    // El icono cambia dependiendo del tipo de transacción.
                    leading: Icon(
                      isSubscription ? Icons.add_circle : Icons.remove_circle,
                      color: isSubscription ? theme.colorScheme.tertiary : theme.colorScheme.error,
                      size: 30,
                    ),
                    title: Text(tx.fundName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    
                    // --- AQUÍ ESTÁ LA LÓGICA DE LA NOTIFICACIÓN ---
                    // El subtítulo es una Columna para poder mostrar dos líneas de texto.
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // La primera línea siempre muestra la fecha.
                        Text(formatDate.format(tx.date)),
                        
                        // --- RENDERIZADO CONDICIONAL ---
                        // Usamos un 'if' para decidir si mostrar o no esta línea.
                        // Si la transacción es una suscripción, entonces mostramos
                        // el método de notificación que guardamos.
                        if (isSubscription)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              // Usamos un operador ternario para convertir el enum a un texto legible.
                              // Es como decir: "Si el tipo es email, escribe 'Email', si no, escribe 'SMS'".
                              'Notificación: ${tx.notificationType == NotificationType.email ? 'Email' : 'SMS'}',
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                    // El texto final muestra el monto con un color y símbolo distintivo.
                    trailing: Text(
                      '${isSubscription ? '+' : '-'}${formatCurrency.format(tx.amount)}',
                      style: TextStyle(
                        color: isSubscription ? theme.colorScheme.tertiary : theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
