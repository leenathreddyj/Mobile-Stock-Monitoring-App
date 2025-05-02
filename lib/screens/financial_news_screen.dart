import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/news_card.dart';
import '../services/news_api_service.dart';
import '../models/news.dart';

class FinancialNewsScreen extends StatefulWidget {
  const FinancialNewsScreen({super.key});

  @override
  State<FinancialNewsScreen> createState() => _FinancialNewsScreenState();
}

class _FinancialNewsScreenState extends State<FinancialNewsScreen> {
  final NewsApiService _newsService = NewsApiService();
  List<News>? _news;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await _newsService.fetchFinancialNews();
      if (!mounted) return; // prevent setState if widget disposed
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading news: $e')),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open article.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial News'),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.teal[800]),
            )
          : (_news == null || _news!.isEmpty)
              ? Center(
                  child: Text(
                    'No news available',
                    style: TextStyle(color: Colors.teal[800]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    itemCount: _news!.length,
                    itemBuilder: (context, index) {
                      final article = _news![index];
                      return NewsCard(
                        headline: article.headline,
                        source: article.source,
                        snippet: article.snippet,
                        onTap: () => _openUrl(article.url),
                      );
                    },
                  ),
                ),
    );
  }
}
