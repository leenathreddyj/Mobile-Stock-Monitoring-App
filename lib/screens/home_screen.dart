import 'package:flutter/material.dart';
import 'stock_watchlist_screen.dart';
import 'stock_data_screen.dart';
import 'financial_news_screen.dart';
import '../services/firebase_auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    StockWatchlistScreen(),
    StockDataScreen(),
    FinancialNewsScreen(),
  ];

  void _onSignOut() async {
    await _authService.logOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartTrade',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _onSignOut,
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.teal[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.teal[200],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
