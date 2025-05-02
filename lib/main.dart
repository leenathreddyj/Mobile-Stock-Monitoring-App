import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TradeTrackrApp());
}

class TradeTrackrApp extends StatelessWidget {
  const TradeTrackrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TradeTrackr',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.dark, // flip to .system if you want auto light/dark
      home: const LoginScreen(),
    );
  }
}
