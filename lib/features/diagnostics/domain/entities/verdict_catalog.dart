import 'package:simply_internet/core/retest/cross_medium_retest.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';

/// Pure factory that turns a [VerdictCategory] (plus the one concrete fact it
/// names) into a user-facing [Verdict] and its [Solution]. Kept free of any
/// platform dependency so the whole mapping can be unit-tested.
class VerdictCatalog {
  const VerdictCatalog._();

  /// Build the verdict + solution for "not connected". [airplane] chooses
  /// between the flight-mode wording and the Wi-Fi/data-off wording.
  static ({Verdict verdict, Solution solution}) notConnected({
    required bool airplane,
  }) {
    if (airplane) {
      return (
        verdict: const Verdict(
          category: VerdictCategory.notConnected,
          title: 'You are in flight mode',
          detail:
              'Wireless is switched off, so nothing can reach the '
              'Internet while flight mode is on.',
        ),
        solution: const Solution(
          message: 'Turn off flight mode, then try again.',
          actions: [
            SolutionAction(
              type: SolutionActionType.disableAirplane,
              label: 'Open flight-mode settings',
              confirmBeforeAct: true,
              confirmationPrompt:
                  "You're in flight mode. Open settings to turn it off?",
            ),
          ],
        ),
      );
    }
    return (
      verdict: const Verdict(
        category: VerdictCategory.notConnected,
        title: 'Not connected to any network',
        detail:
            'Both Wi-Fi and mobile data appear to be off, so there is no '
            'way to reach the Internet.',
      ),
      solution: const Solution(
        message: 'Turn on Wi-Fi or mobile data, then try again.',
        actions: [
          SolutionAction(
            type: SolutionActionType.enableWifi,
            label: 'Turn on Wi-Fi',
            confirmBeforeAct: true,
            confirmationPrompt: 'Wi-Fi is off. Open settings to turn it on?',
          ),
          SolutionAction(
            type: SolutionActionType.enableMobileData,
            label: 'Turn on mobile data',
            confirmBeforeAct: true,
            confirmationPrompt:
                'Mobile data is off. Open settings to turn it on?',
          ),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) routerNotResponding(
    String? gatewayIp,
  ) {
    final where = gatewayIp == null
        ? 'your router'
        : 'your router ($gatewayIp)';
    return (
      verdict: Verdict(
        category: VerdictCategory.routerNotResponding,
        title: 'Router is not responding',
        detail:
            "You're connected to the network, but $where isn't "
            'answering. It may have crashed or lost power.',
        detailArg: gatewayIp,
      ),
      solution: const Solution(
        message:
            'Restart your router: unplug it, wait 30 seconds, plug it '
            'back in, and let it about 2-5 minutes to start up. Then run '
            'the test again.',
        actions: [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) captivePortal(String? url) {
    return (
      verdict: const Verdict(
        category: VerdictCategory.captivePortal,
        title: 'Sign-in required (captive portal)',
        detail:
            'The network wants you to sign in or accept terms on a web '
            'page before it lets you online — common in hotels, cafes and '
            'airports.',
      ),
      solution: Solution(
        message:
            'Open the sign-in page and complete the login, then run the '
            'test again.',
        actions: [
          SolutionAction(
            type: SolutionActionType.openCaptivePortal,
            label: 'Open sign-in page',
            confirmBeforeAct: true,
            confirmationPrompt:
                "You're blocked by a sign-in page. Open it now?",
            payload: url,
          ),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) noInternetIsp() {
    return (
      verdict: const Verdict(
        category: VerdictCategory.noInternetIsp,
        title: 'Connected to router, but no Internet',
        detail:
            'Your router works, but it has no working connection to your '
            'Internet provider (ISP). The problem is outside your home.',
      ),
      solution: const Solution(
        message:
            '1. Check whether your router is connected to the wall '
            'phone/DSL socket.\n'
            '2. Check the cable is not damaged or loose.\n'
            '3. If you have a landline phone, pick up the handset and '
            'listen for the dial tone. If you hear no dial tone, contact '
            'your phone company and/or Internet provider to fix your '
            'line.\n'
            '4. Restart your router once to re-establish the ISP link. '
            'If the test still fails after 2-5 minutes, contact your '
            'Internet provider — the outage is on their side.',
        actions: [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  /// [signalWeak] and [signalGood] come from the measured cellular signal, so
  /// the advice only tells the user to move when reception is actually poor.
  static ({Verdict verdict, Solution solution}) mobileDataNoInternet({
    bool signalWeak = false,
    bool signalGood = false,
  }) {
    final String reception;
    if (signalGood) {
      reception = 'Toggle mobile data off and on.';
    } else if (signalWeak) {
      reception =
          'Your signal is weak: move to a spot with better reception and '
          'toggle mobile data off and on.';
    } else {
      reception =
          'Move to a spot with better signal, or toggle mobile data '
          'off and on.';
    }
    return (
      verdict: const Verdict(
        category: VerdictCategory.mobileNoData,
        title: 'Mobile data is connected but not working',
        detail:
            'Your phone is on the cellular network, but no data is getting '
            'through. This usually means data roaming is off, your data '
            'allowance is used up, or your carrier has a local outage.',
      ),
      solution: Solution(
        message:
            '1. If you are abroad or on another network, turn on data '
            'roaming in mobile settings.\n'
            '2. Check that you still have data allowance left on your plan.\n'
            '3. $reception\n'
            '4. If it still fails, contact your mobile carrier.',
        actions: const [
          SolutionAction(
            type: SolutionActionType.enableMobileData,
            label: 'Open mobile data settings',
            confirmBeforeAct: true,
            confirmationPrompt:
                'Open mobile data settings to check roaming and data?',
          ),
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) dnsProblem() {
    return (
      verdict: const Verdict(
        category: VerdictCategory.dnsProblem,
        title: 'DNS problem',
        detail:
            'The Internet is reachable, but website names are not being '
            'translated into addresses. This is a DNS issue and is usually '
            'easy to fix by switching to a public DNS resolver.',
      ),
      solution: const Solution(
        message:
            '1. Switch your Private DNS to a reliable public resolver such '
            'as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.\n'
            '2. If you are on a managed network (work, school, public '
            'Wi-Fi), contact the network administrator to fix the DNS.\n'
            '3. If you are on your own network, check your router settings. '
            'It is good practice to configure the secondary DNS to a public '
            'resolver as well (examples: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), '
            'in case the primary (your Internet provider) fails.',
        actions: [
          SolutionAction(
            type: SolutionActionType.changeDns,
            label: 'Open Private DNS settings',
            confirmBeforeAct: true,
            confirmationPrompt:
                'Open Private DNS settings so you can switch to 1.1.1.1?',
          ),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) portBlocked(
    PortProbeResult blocked,
  ) {
    return (
      verdict: Verdict(
        category: VerdictCategory.portBlocked,
        title: 'Port ${blocked.port} is blocked',
        detail:
            'General Internet works, but ${blocked.service} traffic on '
            'port ${blocked.port} is being blocked — likely by a firewall on '
            'this network. Some apps that rely on this port will not work.',
        detailArg: '${blocked.port}',
      ),
      solution: Solution(
        message:
            'If you connected now to a managed network (work, school, '
            'public Wi-Fi), port ${blocked.port} is blocked by policy — '
            'use a different network, or mobile data (not WiFi), or a '
            'VPN. On your own network, check the firewall rules in your '
            'router settings.',
        actions: const [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) ispPathProblem(
    IspPathResult path,
  ) {
    final hop = path.lastRespondingHop ?? 'a hop inside your provider';
    return (
      verdict: Verdict(
        category: VerdictCategory.ispPathProblem,
        title: 'Network path problem at your ISP',
        detail:
            'Your connection reaches the Internet but traffic stops along '
            'the way, after $hop. The fault is on your provider or backbone '
            'route, not on your device or router.',
        detailArg: path.lastRespondingHop,
      ),
      solution: const Solution(
        message:
            'There is nothing to fix on your device and in your '
            'network. Report the failing route to your Internet provider '
            '(mention that traceroute stops '
            'partway). It usually clears once they fix the route.',
        actions: [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  /// The verdict for a connection that is not broken: what it can and cannot
  /// carry, rather than a bare "no problem found" that says nothing about a
  /// link which is technically alive but too weak to use.
  static ({Verdict verdict, Solution? solution}) capability({
    required CapabilityAssessment assessment,
    required ConnectivityKind medium,
    required SpeedResult speed,
    required LinkQuality quality,
  }) {
    final mediumName = mediumLabel(medium);

    switch (assessment.kind) {
      case CapabilityCase.good:
        final uses = _names(_mostDemanding(assessment.supported, 4));
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionGood,
            title: 'Your $mediumName is good for $uses — and more',
            detail:
                '${_measured(medium, speed)} If something still feels wrong, '
                'it is most likely that one app or website, not your '
                'connection.',
          ),
          solution: null,
        );

      case CapabilityCase.mostlyGood:
        final failing = _names(assessment.unsupported.take(3).toList());
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionMostlyGood,
            title: 'Your $mediumName is good for everything except $failing',
            detail: _detail(assessment, medium, quality),
            detailArg: failing,
          ),
          solution: _advice(assessment, medium, quality),
        );

      case CapabilityCase.degraded:
        final failing = _names(assessment.unsupported.take(4).toList());
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionDegraded,
            title: 'Your $mediumName is too weak for $failing',
            detail: _detail(assessment, medium, quality),
            detailArg: failing,
          ),
          solution: _advice(assessment, medium, quality),
        );
    }
  }

  /// How the tested link is named in every sentence the user reads, so the
  /// report always states which medium the figures came from.
  static String mediumLabel(ConnectivityKind kind) {
    switch (kind) {
      case ConnectivityKind.wifi:
        return 'Wi-Fi';
      case ConnectivityKind.mobile:
        return 'mobile data';
      case ConnectivityKind.ethernet:
        return 'wired connection';
      case ConnectivityKind.vpn:
        return 'VPN connection';
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return 'connection';
    }
  }

  /// The figures for a healthy link: what it delivers, nothing else.
  static String _measured(ConnectivityKind medium, SpeedResult speed) {
    final parts = <String>[
      if (speed.ok) 'download ${_rate(speed.downloadMbps)} Mbps',
      if (speed.uploadMbps != null) 'upload ${_rate(speed.uploadMbps!)} Mbps',
    ];
    if (parts.isEmpty) return 'Measured over ${mediumLabel(medium)}.';
    return 'Measured over ${mediumLabel(medium)}:\n${parts.join(', ')}.';
  }

  /// Why the connection falls short: only the measurements that actually miss
  /// a limit, then the one sentence that explains where they come from. Every
  /// instruction belongs to the solution, so the two never mix.
  static String _detail(
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    final blame = assessment.worstShortfalls
        .take(2)
        .map((s) => s.text)
        .join(', ');
    final figures = blame.isEmpty
        ? ''
        : 'Measured over ${mediumLabel(medium)}:\n$blame. ';
    final missing = assessment.uploadMeasured
        ? ''
        : 'The upload test could not run, so upload was not judged. ';
    return '$figures$missing${_because(assessment, medium, quality)}'.trim();
  }

  /// The cause, with no instruction in it.
  static String _because(
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    if (medium == ConnectivityKind.wifi && _gatewayWeak(quality)) {
      return 'Your router answers slowly or drops packets, which points at '
          'the Wi-Fi itself rather than your provider.';
    }
    if (_saturated(quality)) {
      return 'The connection slows down sharply while it is busy. Someone or '
          'something else on your network (a download, a backup, a TV) is '
          'using the line.';
    }
    if (assessment.throughputOnlyProblem) {
      return 'The connection speed is not sufficient. Either your Internet '
          'plan is too low or your provider is throttling the line.';
    }
    return '';
  }

  /// What to do — instructions only, and never a repeat of the cause.
  static Solution _advice(
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    const moveCloser =
        'Move closer to the router, or try the 5 GHz network if your router '
        'offers one.';
    const pauseTheHog =
        'Find who or what is using the line heavily and ask them to pause. '
        'Otherwise wait, or restart your Wi-Fi — that cuts their connection '
        'too.';
    const dropTheCamera =
        'Turn your camera off — your connection can still carry the audio.';
    final steps = <String>[
      if (medium == ConnectivityKind.wifi && _gatewayWeak(quality))
        moveCloser
      else if (_saturated(quality))
        pauseTheHog,
      if (assessment.voiceCallStillFits) dropTheCamera,
    ];

    return Solution(message: steps.join(' '), actions: retestActions(medium));
  }

  /// Offers a fresh test on the same medium and one on the alternative medium,
  /// so a weak Wi-Fi result can be compared against mobile data (and back).
  /// Choosing the mobile test is the user's acknowledgement of its data use.
  static List<SolutionAction> retestActions(ConnectivityKind medium) {
    switch (medium) {
      case ConnectivityKind.wifi:
        return const [
          SolutionAction(
            type: SolutionActionType.retry,
            label: 'Test again over Wi-Fi',
          ),
          SolutionAction(
            type: SolutionActionType.retestOverMobile,
            label: kTestOverMobileLabel,
          ),
        ];
      case ConnectivityKind.mobile:
        return const [
          SolutionAction(
            type: SolutionActionType.retry,
            label: 'Test again over mobile data',
          ),
          SolutionAction(
            type: SolutionActionType.retestOverWifi,
            label: kTestOverWifiLabel,
          ),
        ];
      case ConnectivityKind.ethernet:
      case ConnectivityKind.vpn:
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return const [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ];
    }
  }

  /// A local radio hop that is slow or lossy: the Wi-Fi, not the provider.
  static bool _gatewayWeak(LinkQuality quality) =>
      quality.gateway.ok &&
      ((quality.gateway.avgMs ?? 0) > 20 ||
          (quality.gateway.lossPercent ?? 0) > 1);

  /// Response time inflating while the line is busy: something is filling it.
  static bool _saturated(LinkQuality quality) =>
      (quality.bufferbloatRatio ?? 1) > 3;

  /// The most demanding activities that do fit, so "good for …" mentions what
  /// is impressive rather than what is trivial.
  static List<UseCaseOutcome> _mostDemanding(
    List<UseCaseOutcome> outcomes,
    int count,
  ) {
    final ranked = outcomes.toList()
      ..sort(
        (a, b) => b.requirement.downMbps.compareTo(a.requirement.downMbps),
      );
    return ranked.take(count).toList();
  }

  static String _names(List<UseCaseOutcome> outcomes) {
    final names = outcomes.map((o) => o.name).toList();
    if (names.isEmpty) return 'anything demanding';
    if (names.length == 1) return names.first;
    return '${names.sublist(0, names.length - 1).join(', ')} '
        'and ${names.last}';
  }

  static String _rate(double value) =>
      value >= 10 ? value.round().toString() : value.toStringAsFixed(1);
}
