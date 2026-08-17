import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/technical_details.dart';

import 'fakes.dart';

void main() {
  group('TechnicalDetails', () {
    const log = ['## Device link', '- Connectivity: wifi', '', '## Ports'];

    testWidgets('renders headings and bullets, not raw markers', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TechnicalDetails(log: log)),
        ),
      );
      await tester.tap(find.text('Technical details'));
      await tester.pumpAndSettle();

      expect(find.text('Device link'), findsOneWidget);
      expect(find.text('• Connectivity: wifi'), findsOneWidget);
      expect(find.text('## Device link'), findsNothing);
    });

    testWidgets('copies the whole log to the clipboard', (tester) async {
      final copied = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TechnicalDetails(log: log)),
        ),
      );
      await tester.tap(find.text('Technical details'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(copied.single, log.join('\n'));
      expect(find.text('Technical details copied.'), findsOneWidget);
    });

    testWidgets('indents a detail under the item it belongs to', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TechnicalDetails(
              log: [
                '- Internet: reachable',
                '  - Captive sign-in page: none',
                'a plain line with no marker',
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Technical details'));
      await tester.pumpAndSettle();

      expect(find.text('• Internet: reachable'), findsOneWidget);
      expect(find.text('◦ Captive sign-in page: none'), findsOneWidget);
      // A line with no marker is shown as written, not decorated with one.
      expect(find.text('a plain line with no marker'), findsOneWidget);

      // The nested detail sits further in than the item it qualifies, so the
      // relationship is visible and not just implied by the order.
      double leftOf(String text) => tester
          .widget<Padding>(
            find
                .ancestor(of: find.text(text), matching: find.byType(Padding))
                .first,
          )
          .padding
          .resolve(TextDirection.ltr)
          .left;

      expect(
        leftOf('◦ Captive sign-in page: none'),
        greaterThan(leftOf('• Internet: reachable')),
      );
      expect(
        leftOf('• Internet: reachable'),
        greaterThan(leftOf('a plain line with no marker')),
      );
    });

    testWidgets('shows nothing when there is no log', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TechnicalDetails(log: [])),
        ),
      );
      expect(find.text('Technical details'), findsNothing);
    });
  });

  group('diagnosis log', () {
    test('is structured and names the tests with their data cost', () async {
      final report = await RunDiagnosis(FakeNetworkProbe()).call();
      expect(report.log.first, '## Device link');
      expect(report.log, contains('## Measurements'));
      expect(report.log, contains('## Good for'));
      final content = report.log.where((l) => l.trim().isNotEmpty);
      expect(
        content.every(
          (l) =>
              l.startsWith('## ') || l.startsWith('- ') || l.startsWith('  - '),
        ),
        isTrue,
        reason: report.log.join('\n'),
      );
      // The captive-portal answer belongs under the Internet line it
      // qualifies, not beside it as a separate top-level fact.
      expect(report.log, contains(startsWith('  - Captive sign-in page:')));
    });
  });
}
