import 'package:flutter/material.dart';

/// Floating action button for adding a new stock to the watch‑list.
class AddStockButton extends StatelessWidget {
  const AddStockButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add), // child last, const for efficiency
    );
  }
}
