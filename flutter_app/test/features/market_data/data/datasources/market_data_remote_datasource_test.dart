import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:pulsenow_flutter/core/constants/api_constants.dart';
import 'package:pulsenow_flutter/core/error/exceptions.dart';
import 'package:pulsenow_flutter/features/market_data/data/datasources/market_data_remote_datasource.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MarketDataRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MarketDataRemoteDataSourceImpl(client: mockHttpClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  group('getMarketData', () {
    final tMarketDataJson = {
      'success': true,
      'data': [
        {
          'symbol': 'BTC/USD',
          'price': 43250.50,
          'change24h': 1000.0,
          'changePercent24h': 2.5,
          'volume': 1250000000,
        },
        {
          'symbol': 'ETH/USD',
          'price': 2650.00,
          'change24h': -50.0,
          'changePercent24h': -1.2,
          'volume': 850000000,
        },
      ],
    };

    test('should return list of MarketDataModel when response is 200', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(json.encode(tMarketDataJson), 200),
      );

      final result = await dataSource.getMarketData();

      expect(result.length, equals(2));
      expect(result[0].symbol, equals('BTC/USD'));
      expect(result[1].symbol, equals('ETH/USD'));
      verify(() => mockHttpClient.get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.marketDataEndpoint}'),
          )).called(1);
    });

    test('should throw ServerException when response is not 200', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('Server error', 500),
      );

      expect(
        () => dataSource.getMarketData(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when response format is invalid', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(json.encode({'success': false}), 200),
      );

      expect(
        () => dataSource.getMarketData(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NetworkException when there is a network error', () async {
      when(() => mockHttpClient.get(any())).thenThrow(Exception('Network error'));

      expect(
        () => dataSource.getMarketData(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getMarketDataBySymbol', () {
    const tSymbol = 'BTC/USD';
    final tMarketDataJson = {
      'success': true,
      'data': {
        'symbol': 'BTC/USD',
        'price': 43250.50,
        'change24h': 1000.0,
        'changePercent24h': 2.5,
        'volume': 1250000000,
      },
    };

    test('should return MarketDataModel when response is 200', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(json.encode(tMarketDataJson), 200),
      );

      final result = await dataSource.getMarketDataBySymbol(tSymbol);

      expect(result.symbol, equals('BTC/USD'));
      expect(result.price, equals(43250.50));
    });

    test('should throw ServerException with 404 when symbol not found', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('Not found', 404),
      );

      expect(
        () => dataSource.getMarketDataBySymbol(tSymbol),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
