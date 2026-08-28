import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/l10n/app_localizations_de.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';
import 'package:simply_internet/l10n/app_localizations_ru.dart';

import 'fakes.dart';

/// Proves the injected `AppLocalizations` reaches both the verdict and the
/// technical log — the diagnosis engine now follows the app's language rather
/// than always speaking English.
void main() {
  test('an English run still reads in English (the default)', () async {
    final report = await RunDiagnosis(FakeNetworkProbe()).call();
    expect(report.verdict.category, VerdictCategory.connectionGood);
    expect(report.verdict.title, startsWith('Your Wi-Fi is good for'));
    expect(report.log.join('\n'), contains('## Measurements'));
  });

  test('a German run renders the verdict and the log in German', () async {
    final report = await RunDiagnosis(
      FakeNetworkProbe(),
    ).call(l10n: AppLocalizationsDe());

    expect(report.verdict.category, VerdictCategory.connectionGood);
    expect(report.verdict.title, startsWith('Dein WLAN ist gut für'));
    final log = report.log.join('\n');
    expect(log, contains('## Messungen'));
    expect(log, contains('Getestet über: WLAN'));
    // No English engine strings leak through.
    expect(log, isNot(contains('Tested over')));
  });

  test('a Russian run localizes a hard-failure verdict', () async {
    final probe = FakeNetworkProbe(gatewayReachable: false);
    final report = await RunDiagnosis(probe).call(l10n: AppLocalizationsRu());

    expect(report.verdict.category, VerdictCategory.routerNotResponding);
    expect(report.verdict.title, 'Роутер не отвечает');
    // The concrete fact the verdict names is still the raw gateway IP.
    expect(report.verdict.detailArg, '192.168.1.1');
  });

  test('a non-English run localizes the performed-checks list', () async {
    final probe = FakeNetworkProbe(
      usage: const DataUsage([
        ProbeRecord(test: 'DNS resolution', target: 'example.com'),
        ProbeRecord(test: 'Country detection', target: 'cloudflare.com'),
        ProbeRecord(
          test: 'Popular sites reachability (7)',
          target: 'port 443',
        ),
        ProbeRecord(test: 'Download speed', target: 'speed.cloudflare.com'),
        ProbeRecord(test: 'Port 443/HTTPS', target: 'example.com'),
      ]),
    );
    final report = await RunDiagnosis(probe).call(l10n: AppLocalizationsDe());
    final log = report.log.join('\n');

    expect(log, contains('DNS-Auflösung'));
    expect(log, contains('Landerkennung'));
    expect(log, contains('Erreichbarkeit beliebter Websites (7)'));
    expect(log, contains('Download-Geschwindigkeit'));
    // The engine's English probe labels no longer leak through …
    expect(log, isNot(contains('DNS resolution')));
    expect(log, isNot(contains('Download speed')));
    // … but a language-neutral per-port label is passed through untouched.
    expect(log, contains('Port 443/HTTPS'));
  });

  test('the fallback and an explicit English locale agree', () async {
    final fallback = await RunDiagnosis(FakeNetworkProbe()).call();
    final explicit = await RunDiagnosis(
      FakeNetworkProbe(),
    ).call(l10n: AppLocalizationsEn());
    expect(fallback.verdict, explicit.verdict);
  });
}
