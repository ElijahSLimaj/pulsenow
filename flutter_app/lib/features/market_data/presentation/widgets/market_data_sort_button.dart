import 'package:flutter/material.dart';
import '../providers/market_data_provider.dart';

class MarketDataSortButton extends StatelessWidget {
  final MarketDataSortOption currentOption;
  final ValueChanged<MarketDataSortOption> onChanged;

  const MarketDataSortButton({
    super.key,
    required this.currentOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MarketDataSortOption>(
      icon: Icon(
        Icons.sort,
        color: currentOption != MarketDataSortOption.none
            ? Theme.of(context).primaryColor
            : null,
      ),
      tooltip: 'Sort',
      onSelected: onChanged,
      itemBuilder: (context) => [
        _buildMenuItem(
          MarketDataSortOption.none,
          'Default',
          Icons.remove,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          MarketDataSortOption.priceDesc,
          'Price: High to Low',
          Icons.arrow_downward,
        ),
        _buildMenuItem(
          MarketDataSortOption.priceAsc,
          'Price: Low to High',
          Icons.arrow_upward,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          MarketDataSortOption.changeDesc,
          'Change: High to Low',
          Icons.trending_up,
        ),
        _buildMenuItem(
          MarketDataSortOption.changeAsc,
          'Change: Low to High',
          Icons.trending_down,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          MarketDataSortOption.symbolAsc,
          'Symbol: A to Z',
          Icons.sort_by_alpha,
        ),
        _buildMenuItem(
          MarketDataSortOption.symbolDesc,
          'Symbol: Z to A',
          Icons.sort_by_alpha,
        ),
      ],
    );
  }

  PopupMenuItem<MarketDataSortOption> _buildMenuItem(
    MarketDataSortOption option,
    String label,
    IconData icon,
  ) {
    final isSelected = currentOption == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : null,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(Icons.check, size: 20, color: Colors.blue),
          ],
        ],
      ),
    );
  }
}
