import 'package:flutter/material.dart';
import 'stock_watchlist_screen.dart';
import 'stock_data_screen.dart';
import 'financial_news_screen.dart';
import '../services/firebase_auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  int _idx = 0;

  static const List<Widget> _screens = [
    StockWatchlistScreen(),
    StockDataScreen(),
    FinancialNewsScreen(),
  ];

  Future<void> _signOut() async {
    await _auth.logOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TradeTrackr'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: _screens[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Watch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stocks'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
        ],
      ),
    );
  }
}
