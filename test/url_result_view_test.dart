import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/features/urlcheck/presentation/widgets/url_check_result_view.dart';

import 'fakes.dart';

Widget wrap(UrlCheckReport report) => MaterialApp(
  home: Scaffold(
    body: UrlCheckResultView(
      report: report,
      controller: UrlCheckController(
        checkUrl: CheckUrl(FakeUrlInspector()),
        deviceActions: FakeDeviceActions(),
      ),
    ),
  ),
);

void main() {
  group('UrlCheckResultView', () {
    testWidgets('gathers the instructions and buttons in one block', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const UrlCheckReport(
            url: 'https://example.com/missing',
            reachable: false,
            headline: 'The website answered with a problem (404).',
            findings: [
              UrlFinding(
                severity: UrlSeverity.warning,
                title: 'Page not found (404).',
                detail: 'The server is up but this exact page does not exist.',
              ),
            ],
            advice: ['Check the address for a typo.'],
          ),
        ),
      );

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text('• Check the address for a typo.'), findsOneWidget);
      // The buttons live inside that same block, not in a group of their own.
      final block = find.ancestor(
        of: find.text('What to do'),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(of: block, matching: find.text('Open in browser')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: block,
          matching: find.text('Test over mobile data'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('still offers the buttons when there is nothing to say', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const UrlCheckReport(
            url: 'https://example.com',
            reachable: true,
            headline: 'The website works',
            findings: [
              UrlFinding(
                severity: UrlSeverity.ok,
                detail: 'The page answered normally (code 200).',
              ),
            ],
          ),
        ),
      );

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text('Open in browser'), findsOneWidget);
    });
  });
}
