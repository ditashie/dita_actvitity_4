import 'package:flutter/material.dart';

/// Atom: the 56x56 rounded, indigo-tinted icon box each product card
/// shows. Takes an IconData, renders the box — no idea which product
/// it belongs to.
class ProductIconTile extends StatelessWidget {
  final IconData icon;
  const ProductIconTile({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 32, color: Colors.indigo),
    );
  }
}
