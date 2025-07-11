import '../models/fund_model.dart';
import '../datasources/fund_api_datasource.dart';

//Este es el contratista que dirige al mensajero
class FundRepository {
  final FundApiDatasource _apiDatasource = FundApiDatasource();

  Future<List<Fund>> getFunds() {
    return _apiDatasource.getFunds();
  }
}