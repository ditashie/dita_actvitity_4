# Justification — Atomic Design Refactor of `MessyCatalogScreen`

Baseline: `starter_reference/main.dart` is the exact file you provided
(`MyApp` / `MessyCatalogScreen`), saved verbatim. Everything below preserves
its behavior exactly: search matches on **name only** (not category), the
name/price validation rules and their exact messages, the description field
staying **optional with no validator at all**, the category dropdown
defaulting to `'Electronics'`, the id/icon assignment for new products
(`Icons.inventory_2`, `_nextId` starting at 8), the "Added X to cart" and
green "X added to catalog!" messages, and the delete-by-id removal. I was
not able to run `flutter pub get` / `flutter run` in this sandbox (no
Flutter SDK, and its network allowlist doesn't reach pub.dev), so this is
reviewed-by-inspection, not execution-verified — please run the baseline
check yourself before grading.

## Atoms

**`HeadingText`** — Atom. The starter hand-wrote the identical
`TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ...)` four separate
times — the AppBar title and three section headings — differing only in
color and string. One `StatelessWidget` with a `color` parameter replaces
all four; it renders whatever text/color it's given and decides nothing.

**`SearchTextField`** — Atom. Wraps the bare `TextField` used for search.
The one thing worth flagging: the starter's search field has **no
`TextEditingController`** — it's driven purely by `onChanged`. I kept that
exactly, rather than "fixing" it by adding a controller, because it produces
a real, observable behavior (see the uncertainty note below) that "must
match exactly" requires me to preserve, not improve.

**`ProductIconTile`** — Atom. The 56×56 rounded indigo-tinted box with an
icon inside. Takes an `IconData`, renders the box — no knowledge of which
product it's for.

**`ProductNameText`**, **`ProductCategoryText`**, **`ProductPriceText`** —
Three atoms, one per distinct piece of text on a card. Each takes a raw
primitive (a `String` or a `double`), not a `Product`, specifically so none
of them could reach past the one value they're given. `ProductPriceText` is
also where the starter's `'PHP ${price.toStringAsFixed(2)}'` formatting now
lives, as pure rendering with no branching logic.

**`FilledActionButton`** — Atom. The starter's "Add to Cart" and "Submit
Product" buttons use the identical `ElevatedButton.styleFrom(backgroundColor:
Colors.indigo, foregroundColor: Colors.white)`, differing only in label,
full-width-or-not, text style, and padding. One parameterized atom replaces
both; it has no idea what pressing it does.

**`DeleteIconButton`** — Atom. The red delete icon button. Callback in, icon
button out.

**`AppTextFormField`** — Atom. A thin wrapper around Flutter's own
`TextFormField`, reused for Name, Price, and Description with different
label/keyboard-type/line-count/validator. This one is worth being precise
about: the widget itself runs no logic — the `validator` it's given is a
plain function reference that *Flutter's own `FormState`* calls when
`.validate()` runs, not something this widget invokes itself. That's what
keeps it an atom rather than a molecule, even though it's standing in for
what used to be a hand-written `TextFormField` with an inline closure.
Passing `validator: null` for the Description field (no `validator:` key at
all in the original) reproduces the starter's actual behavior — that field
was never required.

**`CategoryDropdownField`** — Atom, for the same reason as
`AppTextFormField`: a thin, stateless wrapper around
`DropdownButtonFormField<String>`. It's handed the current value, the list
of categories, and a callback; it doesn't own the list of valid categories
or decide what happens when one is picked.

## Molecules

**`ProductInfoBlock`** — Molecule. Groups `ProductNameText`,
`ProductCategoryText`, and `ProductPriceText` into the vertical block a card
shows — three atoms functioning together as one reusable unit. It reads a
single `Product` but does no fetching, filtering, or mutation, which is
what keeps it a molecule rather than an organism.

**`ProductActionsColumn`** — Molecule. Groups the "Add to Cart"
`FilledActionButton` and the `DeleteIconButton` into the action column each
card shows. It forwards both callbacks upward and makes no decision about
what either action does — it's a pure grouping of two atoms for one
purpose.

**`ProductCard`** — Molecule (see the uncertainty note below — this is the
one I went back and forth on most). It combines the `ProductIconTile` atom
with the `ProductInfoBlock` and `ProductActionsColumn` molecules into the
starter's exact card decoration (white background, rounded border, subtle
shadow). It takes one `Product` and two callbacks and renders itself,
doing no fetching, filtering, or storage of its own.

**`SearchSection`** — Molecule. Groups the `HeadingText('Search Products')`
atom with the `SearchTextField` atom — two atoms working together for a
single purpose (a labeled search box), the textbook molecule example. It
reports raw text changes upward and has no idea what a "match" is.

## Organisms

**`ProductCatalogSection`** — Organism. Assembles the `SearchSection`
molecule, the "Catalog" heading, and the resulting list of `ProductCard`
molecules into the complete, recognizable "browse and manage the catalog"
section — several molecules joined into one distinct part of the screen,
the organism definition. It contains the starter's actual filtering rule
(`name.toLowerCase().contains(query.toLowerCase())`) as local logic
computed from the `products` and `searchQuery` it's handed — allowed at
organism level. It also handles "Add to Cart" directly with a `SnackBar`,
because that action never touches the real catalog; there's nothing to
protect by bubbling it further. "Delete" is different — it *does* mutate
the real list — so it's forwarded up via `onDeleteProduct` rather than
performed here, which is exactly the boundary the rule ("organisms...
should not directly own the app's core data") is drawing: local logic that
merely *reads* the data is fine, logic that *mutates* the canonical list is
not.

**`AddProductForm`** — Organism, and the piece the task calls out
specifically ("make sure the submit logic doesn't stay dumped in the
Page"). It owns the `Form`/`GlobalKey`, the three text controllers, the
selected-category state, and the act of calling `.validate()` — all local
to the form, so all of it belongs here. What it deliberately does **not**
do is decide the new product's `id` or default `icon`, or touch
`_products`/`_nextId` — those are core-data decisions the starter made in
the exact place it also owned the product list, so in this refactor they
stay together, on the Page. A valid submit here only ever calls
`onSubmit(name:, price:, category:, description:)` with raw values, then
resets its own fields — mirroring the starter's `_nameController.clear()` /
`_selectedCategory = 'Electronics'` reset exactly.

## Template

**`CatalogTemplate`** — Template. The `Scaffold`, the indigo `AppBar`, the
scrollable padded body, the `Divider`, and the static "Add New Product"
heading between the two sections. It takes two widget slots (`catalogSlot`,
`formSlot`) and never imports `Product` — it has no idea what a "product"
is, only how to arrange two pre-built sections around a fixed heading and
divider. Both the AppBar title text and the "Add New Product" heading are
included directly here as `HeadingText` atoms rather than passed in as
slots, because neither one varies with the data — they're static UI copy,
not a data model, so hardcoding them doesn't violate "must never import a
data model directly." (An alternative, more slot-heavy design would make
the title a third parameter too; I chose not to, since it never changes and
adding a slot for something that's never actually swapped would be
churn without payoff — happy to add it back if the rubric wants every
piece of text passed in as a slot on principle.)

## Page

**`ProductCatalogPage`** — Page. The only widget holding
`List<Product> _products` (the seven hardcoded starter items, each with its
original icon) and `int _nextId` (starting at 8, exactly as the starter
had it). `_handleSubmit` is where a submitted form's raw values become an
actual `Product` — assigning the id, defaulting the icon to
`Icons.inventory_2`, adding it to the real list, incrementing `_nextId`,
and showing the green "`<name> added to catalog!`" `SnackBar` — because
that confirmation is a direct reaction to the real catalog changing, and
only the Page can see that it did. `_handleDeleteProduct` and
`_handleSearchChanged` are equally thin: they mutate/update the one thing
the Page owns and nothing else. This Page builds `CatalogTemplate` from
`ProductCatalogSection` and `AddProductForm` — never straight from atoms —
so no level gets skipped.

## Where I was genuinely unsure

1. **The search query lives on the Page, not inside `ProductCatalogSection`.**
   This is the deviation I'm least certain the rubric wants. The natural
   home for "current search text" is local UI state inside the search
   organism itself — the rules explicitly allow that kind of thing at
   organism level. I lifted it to the Page instead, for one specific
   reason: the starter's `_submitNewProduct` resets `_searchQuery = ''` in
   the *same* `setState` call that adds the new product. That's a genuine
   cross-organism coupling — something happening in the form has to reach
   into the search section's state — and a `StatefulWidget`'s private
   state can't be reset from outside itself without either lifting it up
   (what I did) or threading a reset signal down through a changing
   `Key` or an explicit `reset()` callback. I judged "lift the shared,
   coordinating piece of state to the nearest common ancestor" as the
   cleaner of those options, but it does mean the Page now holds a piece
   of state that isn't, strictly, "the actual product list." I'd treat
   this as a legitimate architectural call rather than an obviously wrong
   one, but it's exactly the kind of thing I'd want confirmed against the
   lecture's stance on whether Pages may hold *any* coordinating state
   beyond the core data, or only the core data itself.

2. **`ProductCard`: molecule or organism?** The same tension as before: a
   card combining an icon tile, three text atoms, and two action controls
   feels substantial. I kept it at molecule level because the
   organism/molecule line is about whether something is *a distinct
   section of the interface* versus *a simple functional group of atoms*
   — and a single card isn't a section on its own; it only becomes part of
   one (the catalog browsing section) once several of them sit inside
   `ProductCatalogSection` alongside the search box. If a card grew real
   interactive behavior of its own — an expand/collapse animation with
   local state, say — I'd still keep it a molecule (local UI state is
   explicitly allowed there), not promote it to organism, since "has some
   internal state" isn't the same test as "is a distinct section."

3. **The uncontrolled search `TextField`.** I flagged this in the
   `SearchTextField` atom's own doc comment, but it's worth restating here:
   because the starter's search box was never bound to a controller, the
   starter has a real (if minor) UI quirk — submitting the add-product form
   resets what's *filtered* (back to showing everything) without visually
   clearing whatever text is still sitting in the search box. I chose to
   reproduce that quirk exactly rather than quietly fix it, since the
   brief says the refactor "must match it exactly," and a `TextEditingController`
   fix — however small — would be a behavior change I wasn't asked to make.
   If that quirk is actually meant to be treated as a bug worth fixing during
   the refactor rather than a baseline to preserve, that's an easy one-line
   change (add a controller to `SearchTextField`, clear it alongside
   `_searchQuery` in the Page's `_handleSubmit`), and I can make it if
   that's the expectation.
