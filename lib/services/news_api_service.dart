import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsApiService {
  final String baseUrl = 'https://finnhub.io/api/v1';
  final String apiKey =
      'ctcvropr01qlc0uvo470ctcvropr01qlc0uvo47g'; // Finnhub key

  // ────────────────────────── public API ──────────────────────────

  /// Latest market news
  Future<List<News>> fetchFinancialNews() async {
    final url = Uri.parse('$baseUrl/news?category=general&token=$apiKey');

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load news. HTTP ${res.statusCode}');
    }

    final List<dynamic> list = jsonDecode(res.body);
    return list.map((e) => News.fromJson(e)).toList();
  }

  /// Company‑specific news (last 7 days)
  Future<List<News>> fetchCompanyNews(String symbol) async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 7)); // ← const fixes lint

    final url = Uri.parse(
      '$baseUrl/company-news?symbol=$symbol'
      '&from=${_fmt(from)}&to=${_fmt(now)}&token=$apiKey',
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load company news. HTTP ${res.statusCode}');
    }

    final List<dynamic> list = jsonDecode(res.body);
    return list.map((e) => News.fromJson(e)).toList();
  }

  // ────────────────────────── helpers ──────────────────────────

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
