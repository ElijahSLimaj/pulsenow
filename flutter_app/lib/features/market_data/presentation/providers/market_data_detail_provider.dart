import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/market_data_entity.dart';
import '../../domain/usecases/get_market_data_by_symbol_usecase.dart';

enum MarketDataDetailState { initial, loading, loaded, error }

class MarketDataDetailProvider with ChangeNotifier {
  final GetMarketDataBySymbolUseCase getMarketDataBySymbolUseCase;

  MarketDataDetailProvider({required this.getMarketDataBySymbolUseCase});

  MarketDataDetailState _state = MarketDataDetailState.initial;
  MarketDataEntity? _marketData;
  String? _errorMessage;

  MarketDataDetailState get state => _state;
  MarketDataEntity? get marketData => _marketData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == MarketDataDetailState.loading;
  bool get hasError => _state == MarketDataDetailState.error;

  Future<void> loadMarketData(String symbol) async {
    _state = MarketDataDetailState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _marketData = await getMarketDataBySymbolUseCase(symbol);
      _state = MarketDataDetailState.loaded;
    } on Failure catch (e) {
      _errorMessage = e.message;
      _state = MarketDataDetailState.error;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MarketDataDetailState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = MarketDataDetailState.initial;
    _marketData = null;
    _errorMessage = null;
    notifyListeners();
  }
}
