# Shared Flutter layers

- `i18n.dart` loads the original, key-for-key Arabic and English dictionaries from `assets/i18n/`.
- `format.dart` formats local sample dates and EGP values; use Latin digits for references and prices.
- `widgets.dart` holds MulkCare's reusable surfaces, notices, demo banner, status chips, empty state and local-asset image renderer.
- Models and local demo state live in `lib/data/` and `lib/state/` respectively. See `lib/CONTRACT.md` before implementing a screen.