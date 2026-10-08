/// The exact validation rules from the starter's inline
/// `validator: (value) { ... }` closures, moved out of the widget tree.
/// Plain functions, no Flutter dependency. Note the starter's description
/// field has NO validator at all (it's optional) — that's preserved by
/// simply never calling a description validator anywhere, not by adding
/// one that always returns null.
class ProductFormValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
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
  }
}
