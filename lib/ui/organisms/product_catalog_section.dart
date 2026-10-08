import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../atoms/heading_text.dart';
import '../molecules/search_section.dart';
import '../molecules/product_card.dart';

/// Organism: the complete "browse the catalog" section — the
/// SearchSection molecule, the "Catalog" heading, and the resulting list
/// of ProductCard molecules, wired together. This is where the starter's
/// filtering line (`p['name'].toLowerCase().contains(query.toLowerCase())`)
/// now lives, as local logic computed from the [searchQuery] and
/// [products] it's handed — that's allowed at organism level. It never
/// owns either of those: [products] and [searchQuery] are both passed in
/// from the Page, and any change to the query is reported back up via
/// [onSearchChanged] rather than stored here, precisely because the Page
/// needs to be able to reset the query itself (see the Page's submit
/// handler, and the note on this in JUSTIFICATION.md).
///
/// "Add to cart" is handled right here with a SnackBar, because it never
/// touches the real product list — it's pure, local feedback, so there's
/// no need to bubble it any further. "Delete," in contrast, does mutate
/// the real list, so it's forwarded up via [onDeleteProduct] rather than
/// handled locally — this organism is not allowed to own that mutation.
class ProductCatalogSection extends StatelessWidget {
  final List<Product> products;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onDeleteProduct;

  const ProductCatalogSection({
    super.key,
    required this.products,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDeleteProduct,
  });

  List<Product> get _filtered {
    final query = searchQuery.toLowerCase();
    return products.where((p) => p.name.toLowerCase().contains(query)).toList();
  }

  void _handleAddToCart(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${product.name} to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchSection(onSearchChanged: onSearchChanged),
        const SizedBox(height: 16),
        const HeadingText('Catalog'),
        const SizedBox(height: 8),
        Column(
          children: _filtered
              .map((product) => ProductCard(
                    product: product,
                    onAddToCart: () => _handleAddToCart(context, product),
                    onDelete: () => onDeleteProduct(product.id),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
