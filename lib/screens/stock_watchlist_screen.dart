import 'package:flutter/material.dart';

import '../models/stock.dart';
import '../services/stock_api_service.dart';
import '../widgets/add_stock_button.dart';
import '../widgets/stock_card.dart';

class StockWatchlistScreen extends StatefulWidget {
  const StockWatchlistScreen({super.key});

  @override
  State<StockWatchlistScreen> createState() => _StockWatchlistScreenState();
}

class _StockWatchlistScreenState extends State<StockWatchlistScreen> {
  final StockApiService _stockService = StockApiService();

  /// Symbols that the user is tracking.
  final List<String> _watchlistSymbols = ['AAPL', 'MSFT', 'TSLA'];

  /// Cached `Stock` data for the above symbols.
  final List<Stock> _watchlist = [];

  bool _isLoading = true;

  // ─────────────────────────── lifecycle ────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadWatchlistData();
  }

  // ─────────────────────────── data loading ─────────────────────────

  Future<void> _loadWatchlistData() async {
    setState(() => _isLoading = true);

    final List<Stock> loaded = [];
    for (final symbol in _watchlistSymbols) {
      try {
        loaded.add(await _stockService.getStockQuote(symbol));
      } catch (e) {
        debugPrint('Error loading $symbol: $e');
      }
    }

    if (!mounted) return;
    setState(() {
      _watchlist
        ..clear()
        ..addAll(loaded);
      _isLoading = false;
    });
  }

  Future<void> _addNewStock(String symbol) async {
    try {
      final stock = await _stockService.getStockQuote(symbol);
      if (!mounted) return;
      setState(() {
        _watchlist.add(stock);
        _watchlistSymbols.add(symbol);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding $symbol: $e')),
        );
      }
    }
  }

  // ───────────────────────────── UI ────────────────────────────────

  void _showAddStockDialog() {
    String newSymbol = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Stock'),
        content: TextField(
          onChanged: (v) => newSymbol = v.toUpperCase(),
          decoration: const InputDecoration(
            labelText: 'Stock Symbol',
            hintText: 'Enter stock symbol (e.g., AAPL)',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (newSymbol.isNotEmpty) {
                _addNewStock(newSymbol);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────── build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWatchlistData,
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.teal[800]),
            )
          : RefreshIndicator(
              onRefresh: _loadWatchlistData,
              child: ListView.builder(
                itemCount: _watchlist.length,
                itemBuilder: (context, index) {
                  final stock = _watchlist[index];
                  return InkWell(
                    onLongPress: () => _showRemoveDialog(stock, index),
                    child: StockCard(
                      name: stock.name,
                      symbol: stock.symbol,
                      price: stock.price,
                      percentChange: stock.percentChange,
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: AddStockButton(onTap: _showAddStockDialog),
    );
  }

  // ───────────────────────── helpers ─────────────────────────

  void _showRemoveDialog(Stock stock, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Stock'),
        content: Text('Remove ${stock.symbol} from watchlist?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                _watchlistSymbols.remove(stock.symbol);
                _watchlist.removeAt(index);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
