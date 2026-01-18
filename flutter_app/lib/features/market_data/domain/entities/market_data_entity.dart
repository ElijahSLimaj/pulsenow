import 'package:equatable/equatable.dart';

class MarketDataEntity extends Equatable {
  final String symbol;
  final String? description;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;
  final double? high24h;
  final double? low24h;
  final double? marketCap;
  final DateTime? lastUpdated;

  const MarketDataEntity({
    required this.symbol,
    this.description,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
    this.high24h,
    this.low24h,
    this.marketCap,
    this.lastUpdated,
  });

  bool get isPositive => changePercent24h >= 0;

  @override
  List<Object?> get props => [
        symbol,
        description,
        price,
        change24h,
        changePercent24h,
        volume,
        high24h,
        low24h,
        marketCap,
        lastUpdated,
      ];
}
