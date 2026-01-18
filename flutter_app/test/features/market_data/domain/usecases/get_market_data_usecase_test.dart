import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulsenow_flutter/features/market_data/domain/entities/market_data_entity.dart';
import 'package:pulsenow_flutter/features/market_data/domain/repositories/market_data_repository.dart';
import 'package:pulsenow_flutter/features/market_data/domain/usecases/get_market_data_usecase.dart';

class MockMarketDataRepository extends Mock implements MarketDataRepository {}

void main() {
  late GetMarketDataUseCase useCase;
  late MockMarketDataRepository mockRepository;

  setUp(() {
    mockRepository = MockMarketDataRepository();
    useCase = GetMarketDataUseCase(mockRepository);
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

  test('should get market data from the repository', () async {
    when(() => mockRepository.getMarketData())
        .thenAnswer((_) async => tMarketDataList);

    final result = await useCase();

    expect(result, equals(tMarketDataList));
    verify(() => mockRepository.getMarketData()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
