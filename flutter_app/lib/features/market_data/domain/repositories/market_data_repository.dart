import '../entities/market_data_entity.dart';

abstract class MarketDataRepository {
  Future<List<MarketDataEntity>> getMarketData();
  Future<MarketDataEntity> getMarketDataBySymbol(String symbol);
}
