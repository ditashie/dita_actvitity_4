import 'package:flutter/material.dart';

/// The Product entity. Mirrors exactly what the starter's Map<String,
/// dynamic> carried: id, name, price, category, an icon, and an optional
/// description (the seven hardcoded starter products never had a
/// 'description' key at all — only products added through the form do —
/// so [description] is nullable rather than defaulted to an empty
/// string, to preserve that distinction).
///
/// Deliberately not a widget, and deliberately never imported by the
/// Template — only the Page and the organisms/molecules that render
/// product data may reference it.
class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final IconData icon;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.icon,
    this.description,
  });
}
