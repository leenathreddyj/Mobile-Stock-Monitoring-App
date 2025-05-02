import 'dart:convert';
import 'dart:developer';                                 // ← add
import 'package:http/http.dart' as http;

import '../models/stock.dart';
import '../models/candle.dart';

class StockApiService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey  = 'ctcvropr01qlc0uvo470ctcvropr01qlc0uvo47g';

  // ────────────────────────── quote & profile ──────────────────────────
  Future<Stock> getStockQuote(String symbol) async {
    try {
      final quoteRes = await http.get(
        Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey'),
      );
      final profileRes = await http.get(
        Uri.parse('$_baseUrl/stock/profile2?symbol=$symbol&token=$_apiKey'),
      );

      if (quoteRes.statusCode != 200 || profileRes.statusCode != 200) {
        throw Exception('Failed to load stock data');
      }

      final q  = jsonDecode(quoteRes.body);
      final cp = jsonDecode(profileRes.body);

      return Stock(
        symbol: symbol,
        name:  cp['name'] ?? symbol,
        price:          (q['c'] as num?)?.toDouble() ?? 0,
        open:           (q['o'] as num?)?.toDouble() ?? 0,
        high:           (q['h'] as num?)?.toDouble() ?? 0,
        low:            (q['l'] as num?)?.toDouble() ?? 0,
        previousClose:  (q['pc'] as num?)?.toDouble() ?? 0,
        percentChange:  (q['dp'] as num?)?.toDouble() ?? 0,
      );
    } catch (e, st) {
      log('Error fetching stock data', error: e, stackTrace: st);
      rethrow;
    }
  }

  // ───────────────────────────── candles ─────────────────────────────
  Future<List<Candle>> getStockCandles(
      String symbol, String resolution, int from, int to) async {
    try {
      // free‑tier: use quote endpoint to synthesize a single candle
      final res = await http.get(
        Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey'),
      );

      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final data = jsonDecode(res.body);
      if (data['c'] == null) return [];

      return [
        Candle(
          timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          open:  (data['o'] as num).toDouble(),
          high:  (data['h'] as num).toDouble(),
          low:   (data['l'] as num).toDouble(),
          close: (data['c'] as num).toDouble(),
          volume: 0, // volume unavailable in quote endpoint
        )
      ];
    } catch (e, st) {
      log('Error fetching quote for $symbol', error: e, stackTrace: st);
      return [];
    }
  }
}
