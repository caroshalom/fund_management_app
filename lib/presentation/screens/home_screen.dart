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
        // AHORA: Usamos SvgPicture.asset() para cargar desde un archivo.
        title: SvgPicture.asset(
          'assets/images/btg_logo.svg', // La ruta a nuestra imagen
          height: 30, // Le damos una altura para que no sea demasiado grande
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), // Lo pintamos de blanco
        ),
      ),  
      body: Column(
        children: [
          BalanceCard(balance: fundProvider.userBalance),
          Expanded(
            child: fundProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: fundProvider.funds.length,
                    itemBuilder: (context, index) {
                      final fund = fundProvider.funds[index];
                      return FundCard(fund: fund);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
