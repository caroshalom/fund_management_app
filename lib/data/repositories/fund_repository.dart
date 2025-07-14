import '../models/fund_model.dart';
import '../datasources/fund_api_datasource.dart';

// Repositorio para manejar las operaciones relacionadas con los fondos.
// Este repositorio utiliza un datasource para obtener los datos de los fondos.
class FundRepository {
  final FundApiDatasource _apiDatasource = FundApiDatasource();

  Future<List<Fund>> getFunds() {
    return _apiDatasource.getFunds();
  }
}