import '../../domain/entities/market_data_entity.dart';

class MarketDataModel extends MarketDataEntity {
  const MarketDataModel({
    required super.symbol,
    super.description,
    required super.price,
    required super.change24h,
    required super.changePercent24h,
    required super.volume,
    super.high24h,
    super.low24h,
    super.marketCap,
    super.lastUpdated,
  });

  factory MarketDataModel.fromJson(Map<String, dynamic> json) {
    return MarketDataModel(
      symbol: json['symbol'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      change24h: (json['change24h'] as num).toDouble(),
      changePercent24h: (json['changePercent24h'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      high24h: json['high24h'] != null ? (json['high24h'] as num).toDouble() : null,
      low24h: json['low24h'] != null ? (json['low24h'] as num).toDouble() : null,
      marketCap: json['marketCap'] != null ? (json['marketCap'] as num).toDouble() : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'description': description,
      'price': price,
      'change24h': change24h,
      'changePercent24h': changePercent24h,
      'volume': volume,
      'high24h': high24h,
      'low24h': low24h,
      'marketCap': marketCap,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}
