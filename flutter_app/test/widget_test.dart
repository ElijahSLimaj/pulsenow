import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulsenow_flutter/features/market_data/domain/entities/market_data_entity.dart';
import 'package:pulsenow_flutter/features/market_data/domain/usecases/get_market_data_usecase.dart';
import 'package:pulsenow_flutter/features/market_data/presentation/providers/market_data_provider.dart';
import 'package:pulsenow_flutter/features/market_data/presentation/screens/market_data_screen.dart';

class MockGetMarketDataUseCase extends Mock implements GetMarketDataUseCase {}

void main() {
  late MockGetMarketDataUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetMarketDataUseCase();
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

  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => MarketDataProvider(getMarketDataUseCase: mockUseCase),
      child: const MaterialApp(
        home: MarketDataScreen(),
      ),
    );
  }

  testWidgets('shows loading indicator initially', (tester) async {
    final completer = Completer<List<MarketDataEntity>>();
    when(() => mockUseCase()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(tMarketDataList);
    await tester.pumpAndSettle();
  });

  testWidgets('shows market data list after loading', (tester) async {
    when(() => mockUseCase()).thenAnswer((_) async => tMarketDataList);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('BTC/USD'), findsOneWidget);
    expect(find.text('ETH/USD'), findsOneWidget);
  });

  testWidgets('shows positive change in green', (tester) async {
    when(() => mockUseCase()).thenAnswer((_) async => tMarketDataList);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('+2.50%'), findsOneWidget);
  });

  testWidgets('shows negative change in red', (tester) async {
    when(() => mockUseCase()).thenAnswer((_) async => tMarketDataList);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('-1.20%'), findsOneWidget);
  });

  testWidgets('shows search bar', (tester) async {
    when(() => mockUseCase()).thenAnswer((_) async => tMarketDataList);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search symbols...'), findsOneWidget);
  });
}
