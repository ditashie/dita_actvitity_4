import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../atoms/product_icon_tile.dart';
import '../molecules/product_info_block.dart';
import '../molecules/product_actions_column.dart';

/// Molecule: the complete card row for one product — a ProductIconTile
/// atom, a ProductInfoBlock molecule, and a ProductActionsColumn molecule
/// laid out in a Row with the starter's exact card decoration (white
/// background, rounded border, subtle shadow). It takes one Product plus
/// two callbacks and renders it; it never fetches, filters, or stores
/// anything itself. It's a repeated list item rather than a distinct
/// section of the screen in its own right, which is why it's placed at
/// molecule level rather than promoted to an organism — see the
/// uncertainty note in JUSTIFICATION.md for the reasoning behind that
/// specific call.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ProductIconTile(icon: product.icon),
          const SizedBox(width: 12),
          Expanded(child: ProductInfoBlock(product: product)),
          ProductActionsColumn(onAddToCart: onAddToCart, onDelete: onDelete),
        ],
      ),
    );
  }
}
