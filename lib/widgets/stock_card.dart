import 'package:flutter/material.dart';

/// A small card summarising a single stock in a list.
class StockCard extends StatelessWidget {
  const StockCard({
    super.key,                 // ← named key parameter
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentChange,
  });

  final String name;
  final String symbol;
  final double price;
  final double percentChange;

  @override
  Widget build(BuildContext context) {
    final bool positive = percentChange >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(symbol),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${positive ? '+' : ''}${percentChange.toStringAsFixed(2)}%',
              style: TextStyle(
                color: positive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () =>
            Navigator.pushNamed(context, '/stock-data', arguments: symbol),
      ),
    );
  }
}
