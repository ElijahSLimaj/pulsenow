import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulsenow_flutter/core/error/failures.dart';
import 'package:pulsenow_flutter/features/market_data/domain/entities/market_data_entity.dart';
import 'package:pulsenow_flutter/features/market_data/domain/usecases/get_market_data_usecase.dart';
import 'package:pulsenow_flutter/features/market_data/presentation/providers/market_data_provider.dart';

class MockGetMarketDataUseCase extends Mock implements GetMarketDataUseCase {}

void main() {
  late MarketDataProvider provider;
  late MockGetMarketDataUseCase mockGetMarketDataUseCase;

  setUp(() {
    mockGetMarketDataUseCase = MockGetMarketDataUseCase();
    provider = MarketDataProvider(getMarketDataUseCase: mockGetMarketDataUseCase);
  });

  final tMarketDataList = [
    const MarketDataEntity(
      symbol: 'BTC/USD',
      price: 43250.50,
      change24h: 1000.0,
      changePercent24h: 2.5,
      volume: 1250000000,
    ),
    const MarketDataEntity(
      symbol: 'ETH/USD',
      price: 2650.00,
      change24h: -50.0,
      changePercent24h: -1.2,
      volume: 850000000,
    ),
  ];

  group('loadMarketData', () {
    test('should have initial state', () {
      expect(provider.state, equals(MarketDataState.initial));
      expect(provider.marketData, isEmpty);
      expect(provider.errorMessage, isNull);
    });

    test('should emit loading then loaded state when data is fetched successfully',
        () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      final states = <MarketDataState>[];
      provider.addListener(() => states.add(provider.state));

      await provider.loadMarketData();

      expect(states, [MarketDataState.loading, MarketDataState.loaded]);
      expect(provider.marketData, equals(tMarketDataList));
      expect(provider.errorMessage, isNull);
    });

    test('should emit loading then error state when fetching fails', () async {
      when(() => mockGetMarketDataUseCase())
          .thenThrow(const ServerFailure('Server error'));

      final states = <MarketDataState>[];
      provider.addListener(() => states.add(provider.state));

      await provider.loadMarketData();

      expect(states, [MarketDataState.loading, MarketDataState.error]);
      expect(provider.errorMessage, equals('Server error'));
    });
  });

  group('search', () {
    test('should filter market data by symbol', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSearchQuery('BTC');

      expect(provider.marketData.length, equals(1));
      expect(provider.marketData.first.symbol, equals('BTC/USD'));
    });

    test('should return all data when search query is empty', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSearchQuery('BTC');
      provider.clearSearch();

      expect(provider.marketData.length, equals(2));
    });
  });

  group('sort', () {
    test('should sort by price descending', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSortOption(MarketDataSortOption.priceDesc);

      expect(provider.marketData.first.symbol, equals('BTC/USD'));
    });

    test('should sort by price ascending', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSortOption(MarketDataSortOption.priceAsc);

      expect(provider.marketData.first.symbol, equals('ETH/USD'));
    });

    test('should sort by change descending', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSortOption(MarketDataSortOption.changeDesc);

      expect(provider.marketData.first.symbol, equals('BTC/USD'));
    });

    test('should sort by change ascending', () async {
      when(() => mockGetMarketDataUseCase())
          .thenAnswer((_) async => tMarketDataList);

      await provider.loadMarketData();
      provider.setSortOption(MarketDataSortOption.changeAsc);

      expect(provider.marketData.first.symbol, equals('ETH/USD'));
    });
  });

  group('convenience getters', () {
    test('isLoading should return true when state is loading', () async {
      when(() => mockGetMarketDataUseCase()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return tMarketDataList;
      });

      final future = provider.loadMarketData();
      await Future.delayed(const Duration(milliseconds: 10));

      expect(provider.isLoading, isTrue);
      await future;
    });

    test('hasError should return true when state is error', () async {
      when(() => mockGetMarketDataUseCase())
          .thenThrow(const ServerFailure('Error'));

      await provider.loadMarketData();

      expect(provider.hasError, isTrue);
    });

    test('isEmpty should return true when loaded with empty data', () async {
      when(() => mockGetMarketDataUseCase()).thenAnswer((_) async => []);

      await provider.loadMarketData();

      expect(provider.isEmpty, isTrue);
    });
  });
}
