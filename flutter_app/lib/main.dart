import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/market_data/presentation/providers/market_data_provider.dart';
import 'features/market_data/presentation/screens/market_data_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const PulseNowApp());
}

class PulseNowApp extends StatelessWidget {
  const PulseNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<MarketDataProvider>(),
      child: MaterialApp(
        title: 'PulseNow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const MarketDataScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
