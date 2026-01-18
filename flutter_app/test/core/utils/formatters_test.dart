import 'package:flutter_test/flutter_test.dart';
import 'package:pulsenow_flutter/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    group('formatPrice', () {
      test('should format price with 2 decimal places', () {
        expect(Formatters.formatPrice(43250.50), equals('\$43,250.50'));
      });

      test('should format small price with 4 decimal places', () {
        expect(Formatters.formatPrice(0.5198), equals('\$0.5198'));
      });

      test('should format zero', () {
        expect(Formatters.formatPrice(0), equals('\$0.0000'));
      });
    });

    group('formatPercentage', () {
      test('should format positive percentage with plus sign', () {
        expect(Formatters.formatPercentage(2.5), equals('+2.50%'));
      });

      test('should format negative percentage', () {
        expect(Formatters.formatPercentage(-1.2), equals('-1.20%'));
      });

      test('should format zero percentage with plus sign', () {
        expect(Formatters.formatPercentage(0), equals('+0.00%'));
      });
    });

    group('formatVolume', () {
      test('should format large volume in compact form', () {
        final result = Formatters.formatVolume(1250000000);
        expect(result, contains('B'));
      });

      test('should format million volume', () {
        final result = Formatters.formatVolume(850000000);
        expect(result, contains('M'));
      });
    });

    group('formatCurrency', () {
      test('should format large value in compact form', () {
        final result = Formatters.formatCurrency(850000000000);
        expect(result, contains('\$'));
      });

      test('should format small value normally', () {
        expect(Formatters.formatCurrency(43250.50), equals('\$43,250.50'));
      });
    });

    group('formatMarketCap', () {
      test('should format market cap in compact form', () {
        final result = Formatters.formatMarketCap(850000000000);
        expect(result, contains('\$'));
        expect(result, contains('B'));
      });
    });
  });
}
