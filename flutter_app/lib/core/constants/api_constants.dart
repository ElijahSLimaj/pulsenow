import 'dart:io';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static String get wsUrl {
    if (Platform.isAndroid) {
      return 'ws://10.0.2.2:3000';
    }
    return 'ws://localhost:3000';
  }

  static const String marketDataEndpoint = '/market-data';
  static const String analyticsEndpoint = '/analytics';
  static const String portfolioEndpoint = '/portfolio';

  static const Duration timeoutDuration = Duration(seconds: 30);
}
