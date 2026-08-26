/// The three app-wide text sizes offered in Settings.
///
/// Every text style in the app is already expressed through Flutter's
/// theme-relative type scale (see e.g. `theme.textTheme.titleLarge` in
/// `HomePage`), so applying one multiplier as a `TextScaler` on the root
/// `MediaQuery` scales every piece of text in the app proportionally — the
/// same mechanism the OS uses for its own "larger text" accessibility
/// setting.
enum AppFontScale {
  small(0.75, 'Small'),
  normal(1, 'Normal'),
  large(1.4, 'Large');

  const AppFontScale(this.scaleFactor, this.label);

  final double scaleFactor;
  final String label;
}
