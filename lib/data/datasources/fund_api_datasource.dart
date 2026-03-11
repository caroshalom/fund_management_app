import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fund_model.dart';

// Esta clase es responsable de interactuar con la API para obtener los fondos.
// Utiliza la librería http para realizar solicitudes y manejar respuestas.
class FundApiDatasource {
  // Al estar en la carpeta 'web', el archivo es accesible de forma relativa
  final String _baseUrl = 'db_funds.json'; 

Future<List<Fund>> getFunds() async {
  final response = await http.get(Uri.parse(_baseUrl));
  
  if (response.statusCode == 200) {
    final dynamic decodedData = jsonDecode(response.body);
    
    List<dynamic> listToMap;
    
    // Si el JSON es un Mapa (ej. {"data": [...]}), extraemos la lista
    if (decodedData is Map && decodedData.containsKey('data')) {
      listToMap = decodedData['data'];
    } 
    // Si el JSON es directamente la lista [...]
    else if (decodedData is List) {
      listToMap = decodedData;
    } 
    else {
      throw Exception('Formato de JSON no reconocido');
    }

    return listToMap.map((item) => Fund.fromJson(item)).toList();
  } else {
    throw Exception('Error al cargar los fondos: ${response.statusCode}');
  }
}
}