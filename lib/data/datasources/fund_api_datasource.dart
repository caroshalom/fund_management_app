import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fund_model.dart';

// Esta clase es responsable de interactuar con la API para obtener los fondos.
// Utiliza la librería http para realizar solicitudes y manejar respuestas.
class FundApiDatasource {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Fund>> getFunds() async {
    // Simula una demora de 700 milisegundos para simular una llamada a la API y mostrar un indicador de carga 
    // (esto es útil para pruebas y desarrollo, pero se debería eliminar en producción).
    await Future.delayed(const Duration(milliseconds: 700)); 
    
    // Realiza la solicitud HTTP a la API para obtener los fondos
    final response = await http.get(Uri.parse('$_baseUrl/data'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Fund.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los fondos desde la API');
    }
  }
}