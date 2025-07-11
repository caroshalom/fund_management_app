import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importamos Provider
import 'presentation/providers/fund_provider.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

//La función main ahora 'async' para poder esperar a que se carguen los datos del idioma.
void main() async{
  // Le decimos a Flutter que se asegure de que todo esté listo para funcionar.
  WidgetsFlutterBinding.ensureInitialized();

  // La aplicación no continuará hasta que esta tarea termine.
  await initializeDateFormatting('es_CO', null);
  
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
      // Aquí le decimos a nuestra app que use el tema que se creó.
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}