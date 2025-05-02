import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.teal[800],
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/logo.png', // Ensure the logo exists in assets
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'SmartTrade',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                ),
              ),
              SizedBox(height: 30),
              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.teal[700]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[800]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[700]!),
                  ),
                ),
                style: TextStyle(
                    color: Colors.black), // Input text color set to black
              ),
              SizedBox(height: 20),
              // Password Input
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.teal[700]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[800]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[700]!),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                    color: Colors.black), // Input text color set to black
              ),
              SizedBox(height: 20),
              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text('Log In'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              // Sign Up Option
              TextButton(
                onPressed: _handleSignUp,
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.teal[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Login handler
  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final user = await _authService.logIn(email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Sign-Up handler
  void _handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
