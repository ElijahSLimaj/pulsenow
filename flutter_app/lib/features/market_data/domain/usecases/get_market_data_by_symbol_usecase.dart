import '../entities/market_data_entity.dart';
import '../repositories/market_data_repository.dart';

class GetMarketDataBySymbolUseCase {
  final MarketDataRepository repository;

  GetMarketDataBySymbolUseCase(this.repository);

  Future<MarketDataEntity> call(String symbol) async {
    return await repository.getMarketDataBySymbol(symbol);
  }
}
