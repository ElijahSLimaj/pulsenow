import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/market_data_entity.dart';
import '../../domain/repositories/market_data_repository.dart';
import '../datasources/market_data_remote_datasource.dart';

class MarketDataRepositoryImpl implements MarketDataRepository {
  final MarketDataRemoteDataSource remoteDataSource;

  MarketDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MarketDataEntity>> getMarketData() async {
    try {
      return await remoteDataSource.getMarketData();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }

  @override
  Future<MarketDataEntity> getMarketDataBySymbol(String symbol) async {
    try {
      return await remoteDataSource.getMarketDataBySymbol(symbol);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }
}
