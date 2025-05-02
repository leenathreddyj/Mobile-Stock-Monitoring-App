import 'dart:math' show min, max;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/candle.dart';
import '../models/stock.dart';
import '../services/stock_api_service.dart';

class StockDataScreen extends StatefulWidget {
  const StockDataScreen({super.key});

  @override
  State<StockDataScreen> createState() => _StockDataScreenState();
}

class _StockDataScreenState extends State<StockDataScreen> {
  final StockApiService _api = StockApiService();
  bool _loading = true;
  String _selectedSymbol = 'AAPL';
  Stock? _currentStock;
  List<Candle>? _currentCandles;

  static const List<String> _symbols = [
    'AAPL', 'AMZN', 'MSFT', 'GOOGL', 'META',
    'TSLA', 'NVDA', 'AMD',  'NFLX', 'UBER',
  ];

  final Map<String, Stock> _quoteCache = {};
  final Map<String, List<Candle>> _candleCache = {};

  @override
  void initState() {
    super.initState();
    _reloadAll();
  }

  @override
  void dispose() {
    // Nothing to cancel here, but future expansions (timers, streams) go here.
    super.dispose();
  }

  Future<void> _reloadAll() async {
    if (!mounted) return;
    setState(() => _loading = true);

    // Use locals to avoid intermediate setState calls
    final Map<String, Stock> newQuotes = {};
    final Map<String, List<Candle>> newCandles = {};

    for (final symbol in _symbols) {
      try {
        final quote   = await _api.getStockQuote(symbol);
        final candles = await _api.getStockCandles(symbol, 'D', 0, 0);
        newQuotes[symbol]   = quote;
        newCandles[symbol]  = candles;
      } catch (_) {
        // ignore individual failures
      }
    }

    // If the widget was removed while loading, don't call setState:
    if (!mounted) return;

    // Commit everything at once
    setState(() {
      _quoteCache
        ..clear()
        ..addAll(newQuotes);
      _candleCache
        ..clear()
        ..addAll(newCandles);

      // Refresh the currently selected symbol data:
      _currentStock   = _quoteCache[_selectedSymbol];
      _currentCandles = _candleCache[_selectedSymbol];
      _loading        = false;
    });
  }

  void _selectSymbol(String symbol) {
    if (!mounted) return;
    setState(() {
      _selectedSymbol = symbol;
      _currentStock   = _quoteCache[symbol];
      _currentCandles = _candleCache[symbol];
    });
  }

  Widget _buildSidebar() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: _symbols.map((s) {
        final pct   = _quoteCache[s]?.percentChange ?? 0.0;
        final color = pct >= 0 ? Colors.green : Colors.red;
        return ListTile(
          selected: s == _selectedSymbol,
          title: Text(s),
          subtitle: Text(
            '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
            style: TextStyle(color: color),
          ),
          onTap: () => _selectSymbol(s),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    final st   = _currentStock;
    final data = _currentCandles;
    if (st == null || data == null || data.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text('No chart data')),
      );
    }

    final prevClose = st.previousClose;
    final curPrice  = st.price;
    final spots     = <FlSpot>[
      FlSpot(0, prevClose),
      FlSpot(1, (prevClose + curPrice) / 2),
      FlSpot(2, curPrice),
    ];
    final lineColor = curPrice >= prevClose ? Colors.green : Colors.red;
    const alpha10   = 25; // ≈10% opacity

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false), // non-const constructor
          minX: 0,
          maxX: 2,
          minY: min(prevClose, curPrice),
          maxY: max(prevClose, curPrice),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withAlpha(alpha10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadAll,
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(width: 120, child: _buildSidebar()),
          const VerticalDivider(width: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _currentStock == null
                    ? const Center(child: Text('Select a stock'))
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentStock!.name,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${_currentStock!.price.toStringAsFixed(2)}',
                              style:
                                  Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 24),
                            _buildChart(),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
