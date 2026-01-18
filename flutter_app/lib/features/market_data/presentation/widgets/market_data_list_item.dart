import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/market_data_entity.dart';

class MarketDataListItem extends StatelessWidget {
  final MarketDataEntity data;
  final VoidCallback? onTap;

  const MarketDataListItem({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = data.isPositive ? AppColors.positive : AppColors.negative;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildSymbolSection(),
              const SizedBox(width: 16),
              Expanded(child: _buildPriceSection()),
              _buildChangeSection(changeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolSection() {
    final symbolParts = data.symbol.split('/');
    final baseSymbol = symbolParts.isNotEmpty ? symbolParts[0] : data.symbol;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getSymbolColor(baseSymbol).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          baseSymbol.length > 3 ? baseSymbol.substring(0, 3) : baseSymbol,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _getSymbolColor(baseSymbol),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.symbol,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatPrice(data.price),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildChangeSection(Color changeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: changeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Formatters.formatPercentage(data.changePercent24h),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: changeColor,
        ),
      ),
    );
  }

  Color _getSymbolColor(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'SOL':
        return const Color(0xFF00FFA3);
      case 'ADA':
        return const Color(0xFF0033AD);
      case 'DOT':
        return const Color(0xFFE6007A);
      default:
        return AppColors.primary;
    }
  }
}
