import 'package:flutter/material.dart';

/// Atom: the red delete icon button on each product card. Callback in,
/// icon button out — it doesn't know what gets deleted or how.
class DeleteIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
    );
  }
}
