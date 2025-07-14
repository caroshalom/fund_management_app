import 'package:flutter/material.dart';

// Esta clase contendrá toda la configuración de nuestro tema.
class AppTheme {
  // Definimos los colores corporativos de BTG Pactual.
  static const Color primaryBlue = Color(0xFF0033A1); // El azul oscuro principal
  static const Color secondaryBlue = Color(0xFF00A9E0); // El azul claro para acentos
  static const Color accentGreen = Color(0xFF8DC63F); // El verde para éxito o datos positivos
  static const Color darkText = Color(0xFF333333); // Un gris oscuro para texto legible

  // Esta es nuestra "paleta de pintura" principal.
  static ThemeData get theme {
    return ThemeData(
      // Esquema de colores principal de la app.
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryBlue,
        tertiary: accentGreen,
      ),

      // Estilo de la barra de aplicación (AppBar).
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white, // Color del título y los iconos
        elevation: 2,
        centerTitle: true,
      ),

      // Estilo de los botones elevados (ElevatedButton).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Estilo de las tarjetas (Card). No el widget Card, sino el tema de las tarjetas.
      // Esto define cómo se verán las tarjetas en toda la app.
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Estilo de los campos de texto del formulario.
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
      ),

      // Usar Material 3 para un look más moderno.
      useMaterial3: true,
    );
  }
}