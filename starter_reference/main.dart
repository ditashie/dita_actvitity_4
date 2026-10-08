import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messy Catalog',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MessyCatalogScreen(),
    );
  }
}

class MessyCatalogScreen extends StatefulWidget {
  const MessyCatalogScreen({super.key});

  @override
  State<MessyCatalogScreen> createState() => _MessyCatalogScreenState();
}

class _MessyCatalogScreenState extends State<MessyCatalogScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Wireless Mouse',
      'price': 599.0,
      'category': 'Electronics',
      'icon': Icons.mouse,
    },
    {
      'id': 2,
      'name': 'Mechanical Keyboard',
      'price': 2499.0,
      'category': 'Electronics',
      'icon': Icons.keyboard,
    },
    {
      'id': 3,
      'name': 'Ceramic Mug',
      'price': 149.0,
      'category': 'Home',
      'icon': Icons.coffee,
    },
    {
      'id': 4,
      'name': 'Notebook',
      'price': 79.0,
      'category': 'Office',
      'icon': Icons.book,
    },
    {
      'id': 5,
      'name': 'Desk Lamp',
      'price': 899.0,
      'category': 'Home',
      'icon': Icons.lightbulb,
    },
    {
      'id': 6,
      'name': 'Backpack',
      'price': 1299.0,
      'category': 'Accessories',
      'icon': Icons.backpack,
    },
    {
      'id': 7,
      'name': 'Water Bottle',
      'price': 299.0,
      'category': 'Accessories',
      'icon': Icons.local_drink,
    },
  ];

  String _searchQuery = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Electronics';

  int _nextId = 8;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitNewProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = {
        'id': _nextId,
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'icon': Icons.inventory_2,
        'description': _descriptionController.text,
      };

      setState(() {
        _products.add(newProduct);
        _nextId = _nextId + 1;
        _searchQuery = '';
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _selectedCategory = 'Electronics';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newProduct['name']} added to catalog!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((p) {
      return p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messy Catalog',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Type a product name...',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Catalog',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Column(
              children: filteredProducts.map((product) {
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
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          product['icon'] as IconData,
                          size: 32,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['category'] as String,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PHP ${(product['price'] as double).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added ${product['name']} to cart')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add to Cart'),
                          ),
                          const SizedBox(height: 6),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _products.removeWhere((p) => p['id'] == product['id']);
                              });
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Add New Product',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Price is required';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null) {
                        return 'Price must be a number';
                      }
                      if (parsed <= 0) {
                        return 'Price must be greater than zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['Electronics', 'Home', 'Office', 'Accessories']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value ?? 'Electronics';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitNewProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Submit Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
