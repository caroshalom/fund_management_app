import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importamos Provider
import 'presentation/providers/fund_provider.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

// Este es el punto de entrada de nuestra aplicación Flutter
void main() async{
  // Aseguramos que la inicialización de Flutter esté completa antes de ejecutar cualquier código.
  WidgetsFlutterBinding.ensureInitialized();

  // La aplicación no continuará hasta que esta tarea termine.
  await initializeDateFormatting('es_CO', null);
  
  // Envolvemos nuestro widget `MyApp`con un `ChangeNotifierProvider`.
  runApp(
    ChangeNotifierProvider(
      create: (context) => FundProvider(),
      child: const MyApp(),
    ),
  );
}

// Este widget es el corazón de nuestra aplicación.
// Aquí definimos el tema y la estructura básica de la app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
/// Este método construye la aplicación y define su tema.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Fund Management App',
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}