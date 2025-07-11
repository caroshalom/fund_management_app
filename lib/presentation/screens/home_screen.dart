import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ¡IMPORTANTE! Importamos el paquete SVG.
import 'package:provider/provider.dart';
import '../providers/fund_provider.dart';
import '../widgets/fund_card.dart';
import '../widgets/balance_card.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fundProvider = context.watch<FundProvider>();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/btg_logo.svg',
          height: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceCard(balance: fundProvider.userBalance),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Fondos Disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            child: _buildBody(context, fundProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FundProvider provider) {
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
                onPressed: () => context.read<FundProvider>().fetchFunds(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: provider.funds.length,
      itemBuilder: (context, index) {
        final fund = provider.funds[index];
        return FundCard(fund: fund);
      },
    );
  }
}