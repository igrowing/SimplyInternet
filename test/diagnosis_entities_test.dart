// The models here are all const-constructible, and `const` would let the
// compiler fold every value in this file into a literal — which is precisely
// what these tests must not allow, since a folded constructor is never run and
// never counted. The values are therefore built at runtime on purpose.
// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/use_case_requirements.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';

/// Value-equality tests for the diagnosis domain models.
///
/// These are not ceremony: the controller and the widgets compare reports and
/// verdicts to decide whether to rebuild, and a field left out of `props` makes
/// two genuinely different results compare equal — a stale screen that shows
/// the previous run's answer. Every test below changes exactly one field and
/// insists the result is no longer equal.
///
/// The values are built from runtime variables rather than as constants on
/// purpose, so the constructors are actually executed instead of folded away.
void main() {
  group('Verdict', () {
    Verdict build({
      VerdictCategory category = VerdictCategory.connectionGood,
      String title = 'Your connection is good',
      String detail = 'Everything fits.',
      String? detailArg,
    }) => Verdict(
      category: category,
      title: title,
      detail: detail,
      detailArg: detailArg,
    );

    test('a healthy verdict is one where the link carries traffic', () {
      // "Degraded" is still healthy: the connection works, it is just not good
      // enough for everything. Only the broken categories are unhealthy.
      const healthy = [
        VerdictCategory.connectionGood,
        VerdictCategory.connectionMostlyGood,
        VerdictCategory.connectionDegraded,
      ];
      for (final category in VerdictCategory.values) {
        expect(
          build(category: category).isHealthy,
          healthy.contains(category),
          reason: '$category',
        );
      }
    });

    test('compares by value, down to the fact it names', () {
      expect(build(), build());
      expect(build(), isNot(build(category: VerdictCategory.dnsProblem)));
      expect(build(), isNot(build(title: 'Something else')));
      expect(build(), isNot(build(detail: 'Something else')));
      // The detail argument is the concrete fact — the port number, the hop
      // address — so two verdicts that differ only there are different.
      expect(build(detailArg: '443'), isNot(build(detailArg: '80')));
      expect(build(), isNot(build(detailArg: '443')));
    });
  });

  group('SolutionAction', () {
    SolutionAction build({
      SolutionActionType type = SolutionActionType.enableWifi,
      String label = 'Turn on Wi-Fi',
      bool confirmBeforeAct = false,
      String? confirmationPrompt,
      String? payload,
    }) => SolutionAction(
      type: type,
      label: label,
      confirmBeforeAct: confirmBeforeAct,
      confirmationPrompt: confirmationPrompt,
      payload: payload,
    );

    test('asks for no confirmation and carries no data by default', () {
      final action = build();
      expect(action.confirmBeforeAct, isFalse);
      expect(action.confirmationPrompt, isNull);
      expect(action.payload, isNull);
    });

    test('compares by value, including whether it must be confirmed', () {
      expect(build(), build());
      expect(build(), isNot(build(type: SolutionActionType.retry)));
      expect(build(), isNot(build(label: 'Open settings')));
      // The same button that suddenly acts without asking is a different
      // action, however identical it looks.
      expect(build(), isNot(build(confirmBeforeAct: true)));
      expect(
        build(confirmBeforeAct: true, confirmationPrompt: 'Turn it on?'),
        isNot(build(confirmBeforeAct: true, confirmationPrompt: 'Sure?')),
      );
      // The payload is the captive-portal address: two "open the sign-in page"
      // buttons pointing at different pages are not the same button.
      expect(
        build(payload: 'http://a.example'),
        isNot(build(payload: 'http://b.example')),
      );
    });
  });

  group('Solution', () {
    Solution build({
      String message = 'Turn Wi-Fi back on.',
      List<SolutionAction> actions = const [],
    }) => Solution(message: message, actions: actions);

    test('offers no actions unless it was given some', () {
      expect(build().actions, isEmpty);
    });

    test('compares by value, actions included', () {
      final action = SolutionAction(
        type: SolutionActionType.enableWifi,
        label: 'Turn on Wi-Fi',
      );
      expect(build(), build());
      expect(build(), isNot(build(message: 'Ask your provider.')));
      expect(build(actions: [action]), build(actions: [action]));
      expect(build(actions: [action]), isNot(build()));
    });
  });

  group('DiagnosisReport', () {
    final verdict = Verdict(
      category: VerdictCategory.connectionGood,
      title: 'Your connection is good',
      detail: 'Everything fits.',
    );

    DiagnosisReport build({
      Verdict? overrideVerdict,
      Solution? solution,
      CapabilityAssessment? capability,
      List<String> log = const ['## Device link'],
    }) => DiagnosisReport(
      verdict: overrideVerdict ?? verdict,
      solution: solution,
      capability: capability,
      log: log,
    );

    test('a healthy report carries neither solution nor log by default', () {
      final bare = DiagnosisReport(verdict: verdict);
      expect(bare.solution, isNull);
      expect(bare.capability, isNull);
      expect(bare.log, isEmpty);
    });

    test('compares by value across every part it holds', () {
      final solution = Solution(message: 'Turn Wi-Fi back on.');
      final capability = CapabilityAssessment(
        kind: CapabilityCase.good,
        outcomes: const [],
        uploadMeasured: true,
        latencyMeasured: true,
      );

      expect(build(), build());
      expect(
        build(),
        isNot(
          build(
            overrideVerdict: Verdict(
              category: VerdictCategory.dnsProblem,
              title: 'Names are not resolving',
              detail: 'DNS is broken.',
            ),
          ),
        ),
      );
      expect(build(), isNot(build(solution: solution)));
      expect(build(), isNot(build(capability: capability)));
      // The log is what the user pastes into a support ticket; two reports
      // with different evidence are different reports.
      expect(build(), isNot(build(log: const ['## Ports'])));
    });
  });

  group('UseCaseRequirement', () {
    UseCaseRequirement build({
      String name = 'video calls (HD)',
      double downMbps = 4,
      double upMbps = 3,
      double? maxRttMs = 100,
      double? maxJitterMs = 30,
      double? maxLossPercent = 1,
    }) => UseCaseRequirement(
      name: name,
      downMbps: downMbps,
      upMbps: upMbps,
      maxRttMs: maxRttMs,
      maxJitterMs: maxJitterMs,
      maxLossPercent: maxLossPercent,
    );

    test('compares by value across every limit', () {
      expect(build(), build());
      expect(build(), isNot(build(name: 'team games')));
      expect(build(), isNot(build(downMbps: 6)));
      expect(build(), isNot(build(upMbps: 1)));
      expect(build(), isNot(build(maxRttMs: 50)));
      expect(build(), isNot(build(maxJitterMs: 10)));
      expect(build(), isNot(build(maxLossPercent: 0.5)));
    });

    test('a null limit means the activity does not care about it', () {
      // Not the same as a limit of zero, which nothing could ever meet.
      final indifferent = build(maxRttMs: null);
      expect(indifferent.maxRttMs, isNull);
      expect(indifferent, isNot(build(maxRttMs: 0)));
    });

    test('the catalogue names each activity once', () {
      final names = kUseCaseRequirements.map((r) => r.name).toList();
      expect(names.toSet(), hasLength(names.length));
    });

    test('the catalogue runs from least to most demanding', () {
      // "The worst affected activity" is read straight off this order, so a
      // row inserted out of place would name the wrong one.
      final downloads = kUseCaseRequirements.map((r) => r.downMbps).toList();
      expect(downloads.first, lessThan(downloads.last));
    });

    test('the call fallbacks point at rows that exist', () {
      final names = kUseCaseRequirements.map((r) => r.name).toSet();
      expect(names, contains(kVoiceCallUseCase));
      expect(names, containsAll(kVideoCallUseCases));
      // Voice must be cheaper than video, or "turn your camera off" is not
      // advice, it is just a different way to fail.
      final voice = kUseCaseRequirements.firstWhere(
        (r) => r.name == kVoiceCallUseCase,
      );
      for (final video in kVideoCallUseCases) {
        final row = kUseCaseRequirements.firstWhere((r) => r.name == video);
        expect(voice.upMbps, lessThan(row.upMbps), reason: video);
        expect(voice.downMbps, lessThan(row.downMbps), reason: video);
      }
    });
  });

  group('ConnectivityStatus', () {
    ConnectivityStatus build({
      ConnectivityKind kind = ConnectivityKind.wifi,
      bool airplaneMode = false,
      int? mobileSignalLevel,
    }) => ConnectivityStatus(
      kind: kind,
      airplaneMode: airplaneMode,
      mobileSignalLevel: mobileSignalLevel,
    );

    test('a link is anything but none and other', () {
      const linked = [
        ConnectivityKind.wifi,
        ConnectivityKind.mobile,
        ConnectivityKind.ethernet,
        ConnectivityKind.vpn,
      ];
      for (final kind in ConnectivityKind.values) {
        expect(
          build(kind: kind).hasLink,
          linked.contains(kind),
          reason: '$kind',
        );
      }
    });

    test('grades the cellular signal on the 0-4 scale', () {
      const weak = {0: true, 1: true, 2: false, 3: false, 4: false};
      const good = {0: false, 1: false, 2: false, 3: true, 4: true};
      for (var level = 0; level <= 4; level++) {
        final status = build(
          kind: ConnectivityKind.mobile,
          mobileSignalLevel: level,
        );
        expect(status.mobileSignalWeak, weak[level], reason: '$level');
        expect(status.mobileSignalGood, good[level], reason: '$level');
      }
    });

    test('an unmeasured signal is neither weak nor good', () {
      // Both must be false, or an unknown signal would be blamed for (or clear
      // of) a fault it was never measured for.
      final status = build(kind: ConnectivityKind.mobile);
      expect(status.mobileSignalWeak, isFalse);
      expect(status.mobileSignalGood, isFalse);
    });

    test('compares by value', () {
      expect(build(), build());
      expect(build(), isNot(build(kind: ConnectivityKind.mobile)));
      expect(build(), isNot(build(airplaneMode: true)));
      expect(build(), isNot(build(mobileSignalLevel: 4)));
      expect(
        build(mobileSignalLevel: 1),
        isNot(build(mobileSignalLevel: 4)),
      );
    });
  });

  group('CaptivePortalResult', () {
    test('the three outcomes are each distinct', () {
      final clear = CaptivePortalResult.clear();
      final none = CaptivePortalResult.noInternet();
      final portal = CaptivePortalResult.portal('http://login.example/');

      expect(clear.internetOk, isTrue);
      expect(clear.portalDetected, isFalse);
      expect(clear.portalUrl, isNull);

      // No Internet is not a portal: one is a dead path, the other a page the
      // user can sign in to, and they lead to opposite advice.
      expect(none.internetOk, isFalse);
      expect(none.portalDetected, isFalse);
      expect(none.portalUrl, isNull);

      expect(portal.internetOk, isFalse);
      expect(portal.portalDetected, isTrue);
      expect(portal.portalUrl, 'http://login.example/');

      expect({clear, none, portal}, hasLength(3));
    });

    test('compares by value, sign-in address included', () {
      final internetOk = false;
      final portalDetected = true;
      expect(
        CaptivePortalResult(
          internetOk: internetOk,
          portalDetected: portalDetected,
          portalUrl: 'http://login.example/',
        ),
        CaptivePortalResult.portal('http://login.example/'),
      );
      expect(
        CaptivePortalResult.portal('http://a.example/'),
        isNot(CaptivePortalResult.portal('http://b.example/')),
      );
    });
  });

  group('PortProbeResult', () {
    test('compares by value', () {
      PortProbeResult build({int port = 443, bool reachable = true}) =>
          PortProbeResult(port: port, service: 'HTTPS', reachable: reachable);
      expect(build(), build());
      expect(build(), isNot(build(port: 80)));
      expect(build(), isNot(build(reachable: false)));
    });
  });

  group('SpeedResult', () {
    SpeedResult build({
      double downloadMbps = 50,
      bool ok = true,
      double? uploadMbps = 20,
      int bytesReceived = 6000000,
      int bytesSent = 3000000,
      double? loadedRttMs = 22,
    }) => SpeedResult(
      downloadMbps: downloadMbps,
      ok: ok,
      uploadMbps: uploadMbps,
      bytesReceived: bytesReceived,
      bytesSent: bytesSent,
      loadedRttMs: loadedRttMs,
    );

    test('an unavailable result measured nothing at all', () {
      final unavailable = SpeedResult.unavailable();
      expect(unavailable.ok, isFalse);
      expect(unavailable.downloadMbps, 0);
      expect(unavailable.uploadMbps, isNull);
      expect(unavailable.bytesReceived, 0);
      expect(unavailable.bytesSent, 0);
      expect(unavailable.loadedRttMs, isNull);
    });

    test('a measured zero is not the same as no measurement', () {
      // A link that really did move nothing is a finding; a probe that could
      // not run is not, and the report says different things about them.
      expect(
        build(downloadMbps: 0, uploadMbps: 0, bytesReceived: 0, bytesSent: 0),
        isNot(SpeedResult.unavailable()),
      );
    });

    test('compares by value across every figure', () {
      expect(build(), build());
      expect(build(), isNot(build(downloadMbps: 51)));
      expect(build(), isNot(build(ok: false)));
      expect(build(), isNot(build(uploadMbps: null)));
      expect(build(), isNot(build(bytesReceived: 1)));
      expect(build(), isNot(build(bytesSent: 1)));
      // The busy-line round trip is what exposes saturation, so it counts.
      expect(build(), isNot(build(loadedRttMs: 300)));
    });
  });

  group('IspPathResult', () {
    IspPathResult build({
      bool reachedDestination = false,
      String? lastRespondingHop = '10.0.0.1',
      int? firstDeadHop = 4,
    }) => IspPathResult(
      reachedDestination: reachedDestination,
      lastRespondingHop: lastRespondingHop,
      firstDeadHop: firstDeadHop,
    );

    test('compares by value, including where the route went dark', () {
      expect(build(), build());
      expect(build(), isNot(build(reachedDestination: true)));
      expect(build(), isNot(build(lastRespondingHop: '10.0.0.2')));
      expect(build(), isNot(build(firstDeadHop: 5)));
      expect(build(), isNot(build(lastRespondingHop: null)));
    });
  });

  group('SiteReachability', () {
    test('compares by value', () {
      SiteReachability build({String host = 'google.com', bool ok = true}) =>
          SiteReachability(host: host, label: 'Google', reachable: ok);
      expect(build(), build());
      expect(build(), isNot(build(host: 'amazon.com')));
      expect(build(), isNot(build(ok: false)));
    });
  });
}
