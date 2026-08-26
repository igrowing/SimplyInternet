import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';

void main() {
  test('font scale factors increase from small to large around 1.0', () {
    expect(AppFontScale.small.scaleFactor, lessThan(1));
    expect(AppFontScale.normal.scaleFactor, 1);
    expect(AppFontScale.large.scaleFactor, greaterThan(1));
    expect(
      AppFontScale.small.scaleFactor,
      lessThan(AppFontScale.large.scaleFactor),
    );
  });
}
