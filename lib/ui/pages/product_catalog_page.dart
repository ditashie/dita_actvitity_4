import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../organisms/product_catalog_section.dart';
import '../organisms/add_product_form.dart';
import '../templates/catalog_template.dart';

/// Page: the only widget allowed to hold the real product list. It owns
/// the seven hardcoded starter products (each with its original icon),
/// the `_nextId` counter, and — deliberately — the search query too. The
/// search query isn't "core product data," but it has to live somewhere
/// both the catalog section and the submit handler can reach: the
/// starter resets it as a side effect of successfully adding a product,
/// so something has to coordinate across those two otherwise-independent
/// sections. Lifting it to the Page is that coordination point (see the
/// note on this specific call in JUSTIFICATION.md).
///
/// This is also the only place that assigns a new product's id and icon
/// (Icons.inventory_2, exactly as the starter hardcoded it for submitted
/// products) and the only place that decides what "added successfully"
/// feedback looks like, because that feedback is a direct reaction to
/// the real catalog changing — something only the Page can see happened.
class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final List<Product> _products = [
    const Product(id: 1, name: 'Wireless Mouse', price: 599.0, category: 'Electronics', icon: Icons.mouse),
    const Product(id: 2, name: 'Mechanical Keyboard', price: 2499.0, category: 'Electronics', icon: Icons.keyboard),
    const Product(id: 3, name: 'Ceramic Mug', price: 149.0, category: 'Home', icon: Icons.coffee),
    const Product(id: 4, name: 'Notebook', price: 79.0, category: 'Office', icon: Icons.book),
    const Product(id: 5, name: 'Desk Lamp', price: 899.0, category: 'Home', icon: Icons.lightbulb),
    const Product(id: 6, name: 'Backpack', price: 1299.0, category: 'Accessories', icon: Icons.backpack),
    const Product(id: 7, name: 'Water Bottle', price: 299.0, category: 'Accessories', icon: Icons.local_drink),
  ];

  String _searchQuery = '';
  int _nextId = 8;

  void _handleSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _handleDeleteProduct(int id) {
    setState(() {
      _products.removeWhere((p) => p.id == id);
    });
  }

  void _handleSubmit({
    required String name,
    required double price,
    required String category,
    required String description,
  }) {
    final newProduct = Product(
      id: _nextId,
      name: name,
      price: price,
      category: category,
      icon: Icons.inventory_2,
      description: description,
    );

    setState(() {
      _products.add(newProduct);
      _nextId += 1;
      _searchQuery = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newProduct.name} added to catalog!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CatalogTemplate(
      catalogSlot: ProductCatalogSection(
        products: _products,
        searchQuery: _searchQuery,
        onSearchChanged: _handleSearchChanged,
        onDeleteProduct: _handleDeleteProduct,
      ),
      formSlot: AddProductForm(onSubmit: _handleSubmit),
    );
  }
}
