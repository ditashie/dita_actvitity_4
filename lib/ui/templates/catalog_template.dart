import 'package:flutter/material.dart';
import '../atoms/heading_text.dart';

/// Template: pure layout scaffolding — the Scaffold, the indigo AppBar,
/// the scrollable padded body, the Divider, and the static "Add New
/// Product" heading between the two sections. It accepts two widget
/// slots (the catalog section and the form section) and does not import
/// Product or any other data model — it has no idea what a "product" is,
/// only how to arrange two pre-built sections around a fixed heading and
/// divider. The "Add New Product" heading itself is plain UI copy (a
/// HeadingText atom), not a data model, so keeping it here is consistent
/// with the rule: templates may not import data models, but static UI
/// text is fair game.
class CatalogTemplate extends StatelessWidget {
  final Widget catalogSlot;
  final Widget formSlot;

  const CatalogTemplate({
    super.key,
    required this.catalogSlot,
    required this.formSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeadingText('Messy Catalog', color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            catalogSlot,
            const Divider(height: 32, thickness: 1),
            const HeadingText('Add New Product'),
            const SizedBox(height: 12),
            formSlot,
          ],
        ),
      ),
    );
  }
}
