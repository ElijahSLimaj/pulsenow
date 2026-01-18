import 'package:flutter/material.dart';

class MarketDataSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const MarketDataSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search symbols...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
