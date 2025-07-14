import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/fund_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/fund_card.dart';
import 'history_screen.dart';

/// --- Pantalla Principal de la Aplicación ---
/// Esta pantalla muestra el saldo del usuario y una lista de fondos disponibles.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

/// --- Método de Construcción ---
/// Este método construye la pantalla principal de la aplicación.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/btg_logo.svg',
          height: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        actions: [
          Tooltip(
            message: 'Ver historial de transacciones',
            child: IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ),
        ],
      ),
      // El cuerpo principal ahora llama a un único método de construcción.
      body: _buildContent(context),
    );
  }

  /// --- Método de Construcción Principal ---
  /// Este método es responsable de construir el contenido principal de la pantalla.
  /// Utiliza `context.watch` para escuchar los cambios en el `FundProvider`.
  /// Su única responsabilidad es apilar la tarjeta de saldo y la lista de fondos.
  Widget _buildContent(BuildContext context) {
    // `context.watch` se suscribe a los cambios del FundProvider.
    // Cuando el provider llama a `notifyListeners`, este widget se reconstruye.
    final fundProvider = context.watch<FundProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Widget reutilizable para mostrar el saldo.
        BalanceCard(balance: fundProvider.userBalance),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Fondos Disponibles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        // `Expanded` hace que la lista ocupe todo el espacio vertical restante.
        Expanded(
          // Delega la lógica de qué lista mostrar (carga, error o datos)
          // a otro método especializado.
          child: _buildBodyList(context, fundProvider),
        ),
      ],
    );
  }

  /// --- Método de Construcción Condicional ---
  /// Este método tiene una única responsabilidad: decidir qué widget mostrar
  /// basándose en el estado del provider (cargando, error o éxito).
  Widget _buildBodyList(BuildContext context, FundProvider provider) {
    // --- MANEJO DE ESTADOS DE CARGA Y ERROR ---
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 60),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                // `context.read` se usa en callbacks para llamar a una función
                // sin causar una reconstrucción innecesaria.
                onPressed: () => context.read<FundProvider>().fetchFunds(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // --- MANEJO DE ESTADO EXITOSO ---
    // Si no hay errores y no está cargando, muestra la lista de fondos.
    // Usa ListView.builder para construir la lista de forma eficiente.
    // Solo renderiza los elementos que son visibles en pantalla.
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: provider.funds.length,
      itemBuilder: (context, index) {
        final fund = provider.funds[index];
        // Pasa el objeto `fund` completo al widget reutilizable.
        return FundCard(fund: fund);
      },
    );
  }
}