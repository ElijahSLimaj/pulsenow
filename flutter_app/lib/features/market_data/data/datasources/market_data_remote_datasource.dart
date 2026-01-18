import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/market_data_model.dart';

abstract class MarketDataRemoteDataSource {
  Future<List<MarketDataModel>> getMarketData();
  Future<MarketDataModel> getMarketDataBySymbol(String symbol);
}

class MarketDataRemoteDataSourceImpl implements MarketDataRemoteDataSource {
  final http.Client client;

  MarketDataRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MarketDataModel>> getMarketData() async {
    try {
      final response = await client
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.marketDataEndpoint}'))
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> dataList = jsonData['data'] as List<dynamic>;
          return dataList
              .map((item) => MarketDataModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        throw const ServerException(
          message: 'Invalid response format',
          statusCode: 200,
        );
      }

      throw ServerException(
        message: 'Failed to load market data',
        statusCode: response.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<MarketDataModel> getMarketDataBySymbol(String symbol) async {
    try {
      final encodedSymbol = Uri.encodeComponent(symbol);
      final response = await client
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.marketDataEndpoint}/$encodedSymbol'))
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return MarketDataModel.fromJson(jsonData['data'] as Map<String, dynamic>);
        }

        throw const ServerException(
          message: 'Invalid response format',
          statusCode: 200,
        );
      }

      if (response.statusCode == 404) {
        throw ServerException(
          message: 'Symbol not found: $symbol',
          statusCode: 404,
        );
      }

      throw ServerException(
        message: 'Failed to load market data for $symbol',
        statusCode: response.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
