import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/l10n/app_localizations_de.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';

import 'fakes.dart';

/// Proves the injected `AppLocalizations` reaches the URL-check verdict, its
/// advice and the technical log — not only the diagnosis engine.
void main() {
  test('an English URL check still reads in English (the default)', () async {
    final report = await CheckUrl(FakeUrlInspector()).call('example.com');
    expect(report.headline, 'The website works');
    expect(report.log, contains('## Address'));
  });

  test('a German URL check renders the verdict and log in German', () async {
    final report = await CheckUrl(
      FakeUrlInspector(),
    ).call('example.com', l10n: AppLocalizationsDe());

    expect(report.headline, 'Die Website funktioniert');
    final log = report.log.join('\n');
    expect(log, contains('## Adresse'));
    expect(log, contains('## Von diesem Gerät'));
    expect(log, isNot(contains('From this device')));
  });

  test('a German 404 localizes the finding and the advice', () async {
    final report = await CheckUrl(
      FakeUrlInspector(
        fetchResult: const HttpFetchResult(reached: true, statusCode: 404),
      ),
    ).call('example.com/missing', l10n: AppLocalizationsDe());

    expect(
      report.headline,
      'Die Website hat mit einem Problem geantwortet (404).',
    );
    expect(report.findings.single.title, 'Seite nicht gefunden (404).');
    expect(report.advice, [
      'Prüfe die Adresse auf einen Tippfehler.',
      'Öffne die Startseite der Website und navigiere von dort aus.',
    ]);
  });

  test('the fallback and an explicit English locale agree', () async {
    final fallback = await CheckUrl(FakeUrlInspector()).call('example.com');
    final explicit = await CheckUrl(
      FakeUrlInspector(),
    ).call('example.com', l10n: AppLocalizationsEn());
    expect(fallback, explicit);
  });
}
