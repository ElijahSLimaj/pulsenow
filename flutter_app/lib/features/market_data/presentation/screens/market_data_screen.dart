import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_data_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/market_data_list_item.dart';
import '../widgets/market_data_search_bar.dart';
import '../widgets/market_data_sort_button.dart';
import 'market_data_detail_screen.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({super.key});

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketDataProvider>().loadMarketData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Data'),
        elevation: 0,
        actions: [
          Consumer<MarketDataProvider>(
            builder: (context, provider, _) => MarketDataSortButton(
              currentOption: provider.sortOption,
              onChanged: provider.setSortOption,
            ),
          ),
        ],
      ),
      body: Consumer<MarketDataProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              MarketDataSearchBar(
                value: provider.searchQuery,
                onChanged: provider.setSearchQuery,
                onClear: provider.clearSearch,
              ),
              Expanded(child: _buildBody(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(MarketDataProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError) {
      return ErrorStateWidget(
        message: provider.errorMessage ?? 'Unknown error',
        onRetry: provider.loadMarketData,
      );
    }

    if (provider.isEmpty) {
      return EmptyStateWidget(
        title: 'No market data',
        subtitle: 'Pull to refresh',
        icon: Icons.show_chart,
        onAction: provider.loadMarketData,
        actionLabel: 'Refresh',
      );
    }

    final data = provider.marketData;

    if (data.isEmpty && provider.searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No results found',
        subtitle: 'Try a different search term',
        icon: Icons.search_off,
        onAction: provider.clearSearch,
        actionLabel: 'Clear search',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadMarketData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: data.length,
        itemExtent: 88,
        itemBuilder: (context, index) {
          final item = data[index];
          return MarketDataListItem(
            data: item,
            onTap: () => _navigateToDetail(item.symbol),
          );
        },
      ),
    );
  }

  void _navigateToDetail(String symbol) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MarketDataDetailScreen(symbol: symbol),
      ),
    );
  }
}
