import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulsenow_flutter/core/error/exceptions.dart';
import 'package:pulsenow_flutter/core/error/failures.dart';
import 'package:pulsenow_flutter/features/market_data/data/datasources/market_data_remote_datasource.dart';
import 'package:pulsenow_flutter/features/market_data/data/models/market_data_model.dart';
import 'package:pulsenow_flutter/features/market_data/data/repositories/market_data_repository_impl.dart';

class MockMarketDataRemoteDataSource extends Mock
    implements MarketDataRemoteDataSource {}

void main() {
  late MarketDataRepositoryImpl repository;
  late MockMarketDataRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockMarketDataRemoteDataSource();
    repository = MarketDataRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getMarketData', () {
    final tMarketDataModelList = [
      const MarketDataModel(
        symbol: 'BTC/USD',
        price: 43250.50,
        change24h: 1000.0,
        changePercent24h: 2.5,
        volume: 1250000000,
      ),
      const MarketDataModel(
        symbol: 'ETH/USD',
        price: 2650.00,
        change24h: -50.0,
        changePercent24h: -1.2,
        volume: 850000000,
      ),
    ];

    test('should return market data when call to remote data source is successful',
        () async {
      when(() => mockRemoteDataSource.getMarketData())
          .thenAnswer((_) async => tMarketDataModelList);

      final result = await repository.getMarketData();

      expect(result, equals(tMarketDataModelList));
      verify(() => mockRemoteDataSource.getMarketData()).called(1);
    });

    test('should throw ServerFailure when call to remote data source throws ServerException',
        () async {
      when(() => mockRemoteDataSource.getMarketData())
          .thenThrow(const ServerException(message: 'Server error'));

      expect(
        () => repository.getMarketData(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('should throw NetworkFailure when call to remote data source throws NetworkException',
        () async {
      when(() => mockRemoteDataSource.getMarketData())
          .thenThrow(const NetworkException(message: 'Network error'));

      expect(
        () => repository.getMarketData(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('getMarketDataBySymbol', () {
    const tSymbol = 'BTC/USD';
    const tMarketDataModel = MarketDataModel(
      symbol: 'BTC/USD',
      price: 43250.50,
      change24h: 1000.0,
      changePercent24h: 2.5,
      volume: 1250000000,
    );

    test('should return market data when call to remote data source is successful',
        () async {
      when(() => mockRemoteDataSource.getMarketDataBySymbol(tSymbol))
          .thenAnswer((_) async => tMarketDataModel);

      final result = await repository.getMarketDataBySymbol(tSymbol);

      expect(result, equals(tMarketDataModel));
      verify(() => mockRemoteDataSource.getMarketDataBySymbol(tSymbol)).called(1);
    });

    test('should throw ServerFailure when symbol is not found', () async {
      when(() => mockRemoteDataSource.getMarketDataBySymbol(tSymbol))
          .thenThrow(const ServerException(message: 'Symbol not found'));

      expect(
        () => repository.getMarketDataBySymbol(tSymbol),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
