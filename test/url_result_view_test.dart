import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/features/urlcheck/presentation/widgets/url_check_result_view.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

import 'fakes.dart';

/// A controller that has already run a check over [medium], so the view can be
/// built against a known link rather than whatever the default happens to be.
Future<UrlCheckController> _checkedOver(ConnectivityKind medium) async {
  final controller = UrlCheckController(
    checkUrl: CheckUrl(FakeUrlInspector()),
    deviceActions: FakeDeviceActions(),
    networkProbe: FakeNetworkProbe(
      connectivityResult: ConnectivityStatus(kind: medium, airplaneMode: false),
    ),
    urlHistory: FakeUrlHistory(),
  );
  await controller.check('example.com');
  return controller;
}

Widget wrap(UrlCheckReport report, UrlCheckController controller) =>
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: UrlCheckResultView(report: report, controller: controller),
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
          await _checkedOver(ConnectivityKind.wifi),
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
          await _checkedOver(ConnectivityKind.wifi),
        ),
      );

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text('Open in browser'), findsOneWidget);
    });

    group('the cross-medium button names the medium in use', () {
      const report = UrlCheckReport(
        url: 'https://example.com',
        reachable: true,
        headline: 'The website works',
        findings: [
          UrlFinding(
            severity: UrlSeverity.ok,
            detail: 'The page answered normally (code 200).',
          ),
        ],
      );

      testWidgets('on Wi-Fi it offers mobile data', (tester) async {
        await tester.pumpWidget(
          wrap(report, await _checkedOver(ConnectivityKind.wifi)),
        );
        expect(find.text('Test over mobile data'), findsOneWidget);
        expect(find.byIcon(Icons.signal_cellular_alt), findsOneWidget);
      });

      testWidgets('on mobile data it offers Wi-Fi', (tester) async {
        // Offering "test over mobile data" to someone already on mobile data
        // is what this replaced.
        await tester.pumpWidget(
          wrap(report, await _checkedOver(ConnectivityKind.mobile)),
        );
        expect(find.text('Test over Wi-Fi'), findsOneWidget);
        expect(find.text('Test over mobile data'), findsNothing);
        expect(find.byIcon(Icons.wifi), findsOneWidget);
      });

      testWidgets('on a wired link it offers neither', (tester) async {
        await tester.pumpWidget(
          wrap(report, await _checkedOver(ConnectivityKind.ethernet)),
        );
        expect(find.textContaining('Test over'), findsNothing);
        // The rest of the block is untouched — only the offer that makes no
        // sense here is absent.
        expect(find.text('Open in browser'), findsOneWidget);
      });
    });
  });
}
