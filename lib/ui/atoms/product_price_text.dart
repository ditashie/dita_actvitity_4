import 'package:flutter/material.dart';

/// Atom: formats a raw price double into the starter's "PHP X.XX" string
/// and renders it. Takes a double, not a Product, so it can't reach for
/// anything beyond the single value it needs.
class ProductPriceText extends StatelessWidget {
  final double price;
  const ProductPriceText(this.price, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'PHP ${price.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
    );
  }
}
