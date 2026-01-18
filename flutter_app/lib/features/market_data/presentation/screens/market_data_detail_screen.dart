import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/market_data_entity.dart';
import '../providers/market_data_detail_provider.dart';
import '../widgets/error_state_widget.dart';

class MarketDataDetailScreen extends StatelessWidget {
  final String symbol;

  const MarketDataDetailScreen({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<MarketDataDetailProvider>()..loadMarketData(symbol),
      child: Scaffold(
        appBar: AppBar(
          title: Text(symbol),
          elevation: 0,
        ),
        body: Consumer<MarketDataDetailProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.hasError) {
              return ErrorStateWidget(
                message: provider.errorMessage ?? 'Unknown error',
                onRetry: () => provider.loadMarketData(symbol),
              );
            }

            final data = provider.marketData;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }

            return RefreshIndicator(
              onRefresh: () => provider.loadMarketData(symbol),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: _DetailContent(data: data),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MarketDataEntity data;

  const _DetailContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final changeColor = data.isPositive ? AppColors.positive : AppColors.negative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceCard(changeColor),
        const SizedBox(height: 16),
        _buildStatsCard(),
        if (data.description != null) ...[
          const SizedBox(height: 16),
          _buildDescriptionCard(),
        ],
      ],
    );
  }

  Widget _buildPriceCard(Color changeColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Formatters.formatPrice(data.price),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  data.isPositive ? Icons.trending_up : Icons.trending_down,
                  color: changeColor,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  Formatters.formatPercentage(data.changePercent24h),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: changeColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '24h',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Volume', Formatters.formatVolume(data.volume)),
            if (data.high24h != null)
              _buildStatRow('24h High', Formatters.formatPrice(data.high24h!)),
            if (data.low24h != null)
              _buildStatRow('24h Low', Formatters.formatPrice(data.low24h!)),
            if (data.marketCap != null)
              _buildStatRow('Market Cap', Formatters.formatMarketCap(data.marketCap!)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
