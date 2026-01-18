import 'package:flutter_test/flutter_test.dart';
import 'package:pulsenow_flutter/features/market_data/data/models/market_data_model.dart';
import 'package:pulsenow_flutter/features/market_data/domain/entities/market_data_entity.dart';

void main() {
  group('MarketDataModel', () {
    const tMarketDataModel = MarketDataModel(
      symbol: 'BTC/USD',
      description: 'Bitcoin',
      price: 43250.50,
      change24h: 1000.0,
      changePercent24h: 2.5,
      volume: 1250000000,
      high24h: 44500,
      low24h: 42000,
      marketCap: 850000000000,
    );

    test('should be a subclass of MarketDataEntity', () {
      expect(tMarketDataModel, isA<MarketDataEntity>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final json = {
          'symbol': 'BTC/USD',
          'description': 'Bitcoin',
          'price': 43250.50,
          'change24h': 1000.0,
          'changePercent24h': 2.5,
          'volume': 1250000000,
          'high24h': 44500,
          'low24h': 42000,
          'marketCap': 850000000000,
          'lastUpdated': '2024-01-15T10:00:00.000Z',
        };

        final result = MarketDataModel.fromJson(json);

        expect(result.symbol, equals('BTC/USD'));
        expect(result.description, equals('Bitcoin'));
        expect(result.price, equals(43250.50));
        expect(result.change24h, equals(1000.0));
        expect(result.changePercent24h, equals(2.5));
        expect(result.volume, equals(1250000000));
        expect(result.high24h, equals(44500));
        expect(result.low24h, equals(42000));
        expect(result.marketCap, equals(850000000000));
        expect(result.lastUpdated, isNotNull);
      });

      test('should handle null optional fields', () {
        final json = {
          'symbol': 'BTC/USD',
          'price': 43250.50,
          'change24h': 1000.0,
          'changePercent24h': 2.5,
          'volume': 1250000000,
        };

        final result = MarketDataModel.fromJson(json);

        expect(result.symbol, equals('BTC/USD'));
        expect(result.description, isNull);
        expect(result.high24h, isNull);
        expect(result.low24h, isNull);
        expect(result.marketCap, isNull);
        expect(result.lastUpdated, isNull);
      });

      test('should handle integer values for numeric fields', () {
        final json = {
          'symbol': 'BTC/USD',
          'price': 43250,
          'change24h': 1000,
          'changePercent24h': 2,
          'volume': 1250000000,
        };

        final result = MarketDataModel.fromJson(json);

        expect(result.price, equals(43250.0));
        expect(result.change24h, equals(1000.0));
        expect(result.changePercent24h, equals(2.0));
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tMarketDataModel.toJson();

        expect(result['symbol'], equals('BTC/USD'));
        expect(result['description'], equals('Bitcoin'));
        expect(result['price'], equals(43250.50));
        expect(result['change24h'], equals(1000.0));
        expect(result['changePercent24h'], equals(2.5));
        expect(result['volume'], equals(1250000000));
        expect(result['high24h'], equals(44500));
        expect(result['low24h'], equals(42000));
        expect(result['marketCap'], equals(850000000000));
      });
    });

    group('isPositive', () {
      test('should return true when changePercent24h is positive', () {
        const model = MarketDataModel(
          symbol: 'BTC/USD',
          price: 43250.50,
          change24h: 1000.0,
          changePercent24h: 2.5,
          volume: 1250000000,
        );

        expect(model.isPositive, isTrue);
      });

      test('should return true when changePercent24h is zero', () {
        const model = MarketDataModel(
          symbol: 'BTC/USD',
          price: 43250.50,
          change24h: 0,
          changePercent24h: 0,
          volume: 1250000000,
        );

        expect(model.isPositive, isTrue);
      });

      test('should return false when changePercent24h is negative', () {
        const model = MarketDataModel(
          symbol: 'BTC/USD',
          price: 43250.50,
          change24h: -1000.0,
          changePercent24h: -2.5,
          volume: 1250000000,
        );

        expect(model.isPositive, isFalse);
      });
    });
  });
}
