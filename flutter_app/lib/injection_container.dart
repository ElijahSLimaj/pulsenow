import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/market_data/data/datasources/market_data_remote_datasource.dart';
import 'features/market_data/data/repositories/market_data_repository_impl.dart';
import 'features/market_data/domain/repositories/market_data_repository.dart';
import 'features/market_data/domain/usecases/get_market_data_by_symbol_usecase.dart';
import 'features/market_data/domain/usecases/get_market_data_usecase.dart';
import 'features/market_data/presentation/providers/market_data_detail_provider.dart';
import 'features/market_data/presentation/providers/market_data_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _initMarketData();
  _initExternal();
}

void _initMarketData() {
  sl.registerFactory(
    () => MarketDataProvider(getMarketDataUseCase: sl()),
  );

  sl.registerFactory(
    () => MarketDataDetailProvider(getMarketDataBySymbolUseCase: sl()),
  );

  sl.registerLazySingleton(() => GetMarketDataUseCase(sl()));
  sl.registerLazySingleton(() => GetMarketDataBySymbolUseCase(sl()));

  sl.registerLazySingleton<MarketDataRepository>(
    () => MarketDataRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MarketDataRemoteDataSource>(
    () => MarketDataRemoteDataSourceImpl(client: sl()),
  );
}

void _initExternal() {
  sl.registerLazySingleton(() => http.Client());
}
