import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/market_data_entity.dart';
import '../../domain/usecases/get_market_data_usecase.dart';

enum MarketDataState { initial, loading, loaded, error }

class MarketDataProvider with ChangeNotifier {
  final GetMarketDataUseCase getMarketDataUseCase;

  MarketDataProvider({required this.getMarketDataUseCase});

  MarketDataState _state = MarketDataState.initial;
  List<MarketDataEntity> _marketData = [];
  String? _errorMessage;
  String _searchQuery = '';
  MarketDataSortOption _sortOption = MarketDataSortOption.none;

  MarketDataState get state => _state;
  List<MarketDataEntity> get marketData => _filteredAndSortedData;
  List<MarketDataEntity> get allMarketData => _marketData;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  MarketDataSortOption get sortOption => _sortOption;
  bool get isLoading => _state == MarketDataState.loading;
  bool get hasError => _state == MarketDataState.error;
  bool get isEmpty => _marketData.isEmpty && _state == MarketDataState.loaded;

  List<MarketDataEntity> get _filteredAndSortedData {
    var data = _marketData.toList();

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      data = data.where((item) {
        return item.symbol.toLowerCase().contains(query) ||
            (item.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_sortOption) {
      case MarketDataSortOption.priceAsc:
        data.sort((a, b) => a.price.compareTo(b.price));
      case MarketDataSortOption.priceDesc:
        data.sort((a, b) => b.price.compareTo(a.price));
      case MarketDataSortOption.changeAsc:
        data.sort((a, b) => a.changePercent24h.compareTo(b.changePercent24h));
      case MarketDataSortOption.changeDesc:
        data.sort((a, b) => b.changePercent24h.compareTo(a.changePercent24h));
      case MarketDataSortOption.symbolAsc:
        data.sort((a, b) => a.symbol.compareTo(b.symbol));
      case MarketDataSortOption.symbolDesc:
        data.sort((a, b) => b.symbol.compareTo(a.symbol));
      case MarketDataSortOption.none:
        break;
    }

    return data;
  }

  Future<void> loadMarketData() async {
    _state = MarketDataState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _marketData = await getMarketDataUseCase();
      _state = MarketDataState.loaded;
    } on Failure catch (e) {
      _errorMessage = e.message;
      _state = MarketDataState.error;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = MarketDataState.error;
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setSortOption(MarketDataSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearSort() {
    _sortOption = MarketDataSortOption.none;
    notifyListeners();
  }
}

enum MarketDataSortOption {
  none,
  priceAsc,
  priceDesc,
  changeAsc,
  changeDesc,
  symbolAsc,
  symbolDesc,
}
