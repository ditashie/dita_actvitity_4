# Messy Catalog — Atomic Design Refactor

Refactor of the `MessyCatalogScreen` starter file into Atomic Design layers,
with no change to behavior.

## Structure

```
lib/
  main.dart                             # MyApp / MaterialApp, unchanged from starter
  models/
    product.dart                        # Product data model (not a widget)
  utils/
    validators.dart                     # exact validation rules, extracted from inline closures
  ui/
    atoms/
      heading_text.dart                 # shared bold-20 heading style (AppBar title + 3 section headings)
      search_text_field.dart            # uncontrolled search input (see note below)
      product_icon_tile.dart
      product_name_text.dart
      product_category_text.dart
      product_price_text.dart
      filled_action_button.dart         # shared indigo/white button (Add to Cart + Submit Product)
      delete_icon_button.dart
      app_text_form_field.dart          # wraps TextFormField (Name / Price / Description)
      category_dropdown_field.dart      # wraps DropdownButtonFormField
    molecules/
      product_info_block.dart           # name + category + price, stacked
      product_actions_column.dart       # Add to Cart button + delete icon, stacked
      product_card.dart                 # the full card row
      search_section.dart               # "Search Products" heading + search field
    organisms/
      product_catalog_section.dart      # search + "Catalog" heading + filtered card list
      add_product_form.dart             # the whole Add New Product form
    templates/
      catalog_template.dart             # Scaffold/AppBar/scroll layout, slot-based
    pages/
      product_catalog_page.dart         # owns _products, _nextId, _searchQuery
starter_reference/
  main.dart                             # your original starter file, saved verbatim
JUSTIFICATION.md                        # per-widget justification + uncertainty notes
```

## Important caveat

I wasn't able to run `flutter pub get` / `flutter run` in the sandbox this
was built in (no Flutter SDK installed, and its network access doesn't
extend to pub.dev), so this hasn't been execution-verified. Before treating
it as done:

```
flutter pub get
flutter run
```

and confirm against the starter, side by side:

- **Search**: typing filters the catalog by **name only** (not category),
  case-insensitive substring match; clearing the box shows everything again.
- **Validation**: Name required ("Product name is required"); Price
  required ("Price is required"), must parse as a number ("Price must be a
  number"), must be > 0 ("Price must be greater than zero"); Category always
  has a value (defaults to "Electronics"); Description has **no**
  validation — it's optional.
- **Submit**: on success, the new product appears at the bottom of the
  catalog with the generic inventory icon, the form clears, the category
  resets to "Electronics", the search filter resets to show everything, and
  a green SnackBar reads `"<name> added to catalog!"`.
- **Add to Cart**: shows a SnackBar reading `"Added <name> to cart"` — this
  never actually adds anything to a cart; there is no cart state in the
  starter, and none was added here.
- **Delete**: the trash icon removes that product from the catalog
  immediately, matched by id.

One quirk carried over on purpose, not fixed: the search box has no
`TextEditingController` in the starter, so resetting the search filter (on
submit) doesn't visually clear whatever text is still typed in the search
box — it only changes what's shown in the list. See point 3 in
`JUSTIFICATION.md` if you'd rather this be treated as a bug to fix.

## Layer rules applied

- **Atoms**: `StatelessWidget`, no logic beyond rendering. Includes the
  `TextFormField`/`DropdownButtonFormField` wrappers — they render whatever
  validator/value they're given but never invoke or evaluate it themselves.
- **Molecules**: group atoms into small reusable units (a card, a labeled
  search box); no business logic or data-fetching.
- **Organisms**: `ProductCatalogSection` holds the search-filter logic;
  `AddProductForm` holds the form's validation-and-submit logic. Neither
  owns `_products` — both receive it (or affect it) only through the Page.
- **Template**: `CatalogTemplate` takes two widget slots and never imports
  `Product`.
- **Page**: `ProductCatalogPage` is the only place holding the real product
  list, the id counter, and (see `JUSTIFICATION.md` point 1 for the
  reasoning) the search query, since resetting it has to be coordinated
  from the submit handler.

See `JUSTIFICATION.md` for the full widget-by-widget reasoning and three
specific classification calls I flagged as uncertain.
