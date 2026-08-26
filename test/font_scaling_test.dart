import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';

import 'fakes.dart';

const _verdict = Verdict(
  category: VerdictCategory.notConnected,
  title: 'You are not connected',
  detail: 'Wi-Fi and mobile data are both off.',
);

/// One heading (theme.textTheme.titleSmall) and one bullet line (a hardcoded
/// TextStyle(fontSize: 12.5) — see TechnicalDetails._LogLine) so the test
/// covers both ways this app sizes text, not just theme-relative styles.
const _report = DiagnosisReport(
  verdict: _verdict,
  log: ['## Checks', '- Sample technical detail line'],
);

/// Mirrors exactly how `SimplyInternetApp` applies the font-scale setting
/// (see main.dart): one `TextScaler` on the root `MediaQuery`, nothing
/// widget-specific beyond that.
Widget _wrapAt(double scale) {
  final controller = DiagnosisController(
    runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
    deviceActions: FakeDeviceActions(),
  );
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: Scaffold(
      body: ResultView(report: _report, controller: controller),
    ),
  );
}

TextScaler _scalerOf(WidgetTester tester, Finder finder) =>
    tester.renderObject<RenderParagraph>(finder).textScaler;

Future<void> _pumpExpanded(WidgetTester tester, double scale) async {
  // Pumping straight from one scale to the other reuses the previous
  // ExpansionTile's State (same widget shape, no new mount), so the tap
  // below would toggle it closed instead of opening it fresh. Tearing the
  // tree down first forces a real remount.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(_wrapAt(scale));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Technical details'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'the font-scale setting reaches the verdict title (headlineSmall), the '
    'verdict detail (bodyLarge), and a technical-details log line (a '
    'hardcoded TextStyle) proportionally',
    (tester) async {
      // Height is only a valid proxy for "scaled proportionally" while the
      // line count stays the same between measurements. A narrow default
      // test surface combined with a big scale spread can tip a string onto
      // a second line and double its height independently of font size, so
      // widen the surface well beyond what any of the sample strings need
      // even at a generous scale factor.
      tester.view.physicalSize = const Size(2400, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final small = AppFontScale.small.scaleFactor;
      final large = AppFontScale.large.scaleFactor;

      final title = find.text('You are not connected');
      final detail = find.text('Wi-Fi and mobile data are both off.');
      final logLine = find.textContaining('Sample technical detail line');

      await _pumpExpanded(tester, small);
      expect(_scalerOf(tester, title), TextScaler.linear(small));
      expect(_scalerOf(tester, detail), TextScaler.linear(small));
      expect(_scalerOf(tester, logLine), TextScaler.linear(small));
      final titleAtSmall = tester.getSize(title);
      final detailAtSmall = tester.getSize(detail);
      final logAtSmall = tester.getSize(logLine);

      await _pumpExpanded(tester, large);
      expect(_scalerOf(tester, title), TextScaler.linear(large));
      expect(_scalerOf(tester, detail), TextScaler.linear(large));
      expect(_scalerOf(tester, logLine), TextScaler.linear(large));
      final titleAtLarge = tester.getSize(title);
      final detailAtLarge = tester.getSize(detail);
      final logAtLarge = tester.getSize(logLine);

      // All three grew, and by the same ratio as each other — proportional,
      // not just "some text got bigger somewhere." Line boxes round to whole
      // device pixels, and that rounding is a bigger relative error on the
      // smallest of the three (the 12.5px log line, ~9px at the small
      // factor) than on the other two, so it gets a wider tolerance.
      final expectedRatio = large / small;
      expect(
        titleAtLarge.height / titleAtSmall.height,
        closeTo(expectedRatio, 0.05),
      );
      expect(
        detailAtLarge.height / detailAtSmall.height,
        closeTo(expectedRatio, 0.05),
      );
      expect(
        logAtLarge.height / logAtSmall.height,
        closeTo(expectedRatio, 0.1),
      );
    },
  );
}
