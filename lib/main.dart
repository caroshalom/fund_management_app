import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importamos Provider
import 'presentation/providers/fund_provider.dart'; // Importamos nuestro cerebro
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

//Ahora le decimos a nuestra app que use el Cerebro
void main() {
  // Envolvemos nuestra app con el "conector" del cerebro.
  runApp(
    ChangeNotifierProvider(
      create: (context) => FundProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la cinta de "Debug".
      title: 'Fund Management App',
      // Aquí le decimos a nuestra app que use el tema que creamos.
      theme: AppTheme.theme,
      
      home: const HomeScreen(),
    );
  }
}