import '../entities/market_data_entity.dart';
import '../repositories/market_data_repository.dart';

class GetMarketDataUseCase {
  final MarketDataRepository repository;

  GetMarketDataUseCase(this.repository);

  Future<List<MarketDataEntity>> call() async {
    return await repository.getMarketData();
  }
}
