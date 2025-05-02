import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Simple fullscreen loading spinner.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});          // ← key + const

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitCircle(                     // SpinKitCircle is const‑eligible
        color: Colors.blue,
        size: 50,
      ),
    );
  }
}
