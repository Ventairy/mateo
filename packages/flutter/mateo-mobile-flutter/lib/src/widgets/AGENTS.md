# Mateo Widget Implementation

These instructions apply to all Flutter widgets under this directory and
extend the package-level `AGENTS.md` rules.

## Member Scope

- Do not declare widget-specific constants, variables, getters, or helper
  functions at library scope.
- For a `StatefulWidget`, place its implementation constants and helpers on
  the corresponding `State` class. Use static members when they do not depend
  on one state instance.
- For a `StatelessWidget`, place its implementation constants and helpers on
  the widget class.
- Keep top-level declarations only when Dart requires a separate type or when
  the declaration is intentionally shared by multiple widgets in the library.
