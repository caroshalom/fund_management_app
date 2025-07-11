import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fund_model.dart';

//Este es el mensajero que habla con la API
class FundApiDatasource {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Fund>> getFunds() async {
    final response = await http.get(Uri.parse('$_baseUrl/data'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Fund.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los fondos desde la API');
    }
  }
}