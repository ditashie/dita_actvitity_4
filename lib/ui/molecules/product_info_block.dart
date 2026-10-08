import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../atoms/product_name_text.dart';
import '../atoms/product_category_text.dart';
import '../atoms/product_price_text.dart';

/// Molecule: groups ProductNameText, ProductCategoryText, and
/// ProductPriceText into the vertical info block used inside a product
/// card — three atoms functioning together as one reusable unit. It
/// takes a single Product to read from, but does no fetching, filtering,
/// or mutation of anything, so it stays a stateless molecule rather than
/// an organism.
class ProductInfoBlock extends StatelessWidget {
  final Product product;
  const ProductInfoBlock({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductNameText(product.name),
        const SizedBox(height: 4),
        ProductCategoryText(product.category),
        const SizedBox(height: 4),
        ProductPriceText(product.price),
      ],
    );
  }
}
