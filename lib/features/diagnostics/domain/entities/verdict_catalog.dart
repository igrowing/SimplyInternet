import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

/// Factory that turns a [VerdictCategory] (plus the one concrete fact it names)
/// into a user-facing [Verdict] and its [Solution].
///
/// Every string is resolved from an injected [AppLocalizations] so the whole
/// report follows the app's language. The branching logic (which medium, how
/// strong the signal, which capability case) only chooses *which* localized
/// sentence to use and computes its placeholder values — it never assembles a
/// sentence from translated fragments.
class VerdictCatalog {
  const VerdictCatalog._();

  /// Build the verdict + solution for "not connected". [airplane] chooses
  /// between the flight-mode wording and the Wi-Fi/data-off wording.
  static ({Verdict verdict, Solution solution}) notConnected(
    AppLocalizations l10n, {
    required bool airplane,
  }) {
    if (airplane) {
      return (
        verdict: Verdict(
          category: VerdictCategory.notConnected,
          title: l10n.verdictFlightModeTitle,
          detail: l10n.verdictFlightModeDetail,
        ),
        solution: Solution(
          message: l10n.solutionFlightModeMessage,
          actions: [
            SolutionAction(
              type: SolutionActionType.disableAirplane,
              label: l10n.actionOpenFlightSettings,
              confirmBeforeAct: true,
              confirmationPrompt: l10n.confirmFlightMode,
            ),
          ],
        ),
      );
    }
    return (
      verdict: Verdict(
        category: VerdictCategory.notConnected,
        title: l10n.verdictNotConnectedTitle,
        detail: l10n.verdictNotConnectedDetail,
      ),
      solution: Solution(
        message: l10n.solutionNotConnectedMessage,
        actions: [
          SolutionAction(
            type: SolutionActionType.enableWifi,
            label: l10n.actionTurnOnWifi,
            confirmBeforeAct: true,
            confirmationPrompt: l10n.confirmTurnOnWifi,
          ),
          SolutionAction(
            type: SolutionActionType.enableMobileData,
            label: l10n.actionTurnOnMobileData,
            confirmBeforeAct: true,
            confirmationPrompt: l10n.confirmTurnOnMobileData,
          ),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) routerNotResponding(
    AppLocalizations l10n,
    String? gatewayIp,
  ) {
    final where = gatewayIp == null
        ? l10n.verdictRouterWhereUnnamed
        : l10n.verdictRouterWhereNamed(gatewayIp);
    return (
      verdict: Verdict(
        category: VerdictCategory.routerNotResponding,
        title: l10n.verdictRouterNotRespondingTitle,
        detail: l10n.verdictRouterNotRespondingDetail(where),
        detailArg: gatewayIp,
      ),
      solution: Solution(
        message: l10n.solutionRouterNotRespondingMessage,
        actions: [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) captivePortal(
    AppLocalizations l10n,
    String? url,
  ) {
    return (
      verdict: Verdict(
        category: VerdictCategory.captivePortal,
        title: l10n.verdictCaptivePortalTitle,
        detail: l10n.verdictCaptivePortalDetail,
      ),
      solution: Solution(
        message: l10n.solutionCaptivePortalMessage,
        actions: [
          SolutionAction(
            type: SolutionActionType.openCaptivePortal,
            label: l10n.actionOpenSignInPage,
            confirmBeforeAct: true,
            confirmationPrompt: l10n.confirmCaptivePortal,
            payload: url,
          ),
        ],
      ),
    );
  }

  /// [medium] picks the wording: a mobile link has no router, DSL socket or
  /// landline to point at, so that advice is replaced with carrier-side steps.
  static ({Verdict verdict, Solution solution}) noInternetIsp(
    AppLocalizations l10n, {
    required ConnectivityKind medium,
  }) {
    if (medium == ConnectivityKind.mobile) {
      return (
        verdict: Verdict(
          category: VerdictCategory.noInternetIsp,
          title: l10n.verdictNoInternetMobileTitle,
          detail: l10n.verdictNoInternetMobileDetail,
        ),
        solution: Solution(
          message: l10n.solutionNoInternetMobileMessage,
          actions: [
            SolutionAction(
              type: SolutionActionType.retry,
              label: l10n.actionTestAgain,
            ),
          ],
        ),
      );
    }
    return (
      verdict: Verdict(
        category: VerdictCategory.noInternetIsp,
        title: l10n.verdictNoInternetIspTitle,
        detail: l10n.verdictNoInternetIspDetail,
      ),
      solution: Solution(
        message: l10n.solutionNoInternetIspMessage,
        actions: [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
        ],
      ),
    );
  }

  /// [signalWeak] and [signalGood] come from the measured cellular signal, so
  /// the advice only tells the user to move when reception is actually poor.
  static ({Verdict verdict, Solution solution}) mobileDataNoInternet(
    AppLocalizations l10n, {
    bool signalWeak = false,
    bool signalGood = false,
  }) {
    final signal = signalGood
        ? 'good'
        : signalWeak
        ? 'weak'
        : 'other';
    return (
      verdict: Verdict(
        category: VerdictCategory.mobileNoData,
        title: l10n.verdictMobileNoDataTitle,
        detail: l10n.verdictMobileNoDataDetail,
      ),
      solution: Solution(
        message: l10n.solutionMobileNoDataMessage(
          l10n.solutionMobileNoDataReception(signal),
        ),
        actions: [
          SolutionAction(
            type: SolutionActionType.enableMobileData,
            label: l10n.actionOpenMobileDataSettings,
            confirmBeforeAct: true,
            confirmationPrompt: l10n.confirmMobileDataSettings,
          ),
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
        ],
      ),
    );
  }

  /// [medium] picks the follow-up steps: a mobile link has no network
  /// administrator or router to check.
  static ({Verdict verdict, Solution solution}) dnsProblem(
    AppLocalizations l10n, {
    required ConnectivityKind medium,
  }) {
    final message = medium == ConnectivityKind.mobile
        ? l10n.solutionDnsProblemMessageMobile
        : l10n.solutionDnsProblemMessageFixed;
    return (
      verdict: Verdict(
        category: VerdictCategory.dnsProblem,
        title: l10n.verdictDnsProblemTitle,
        detail: l10n.verdictDnsProblemDetail,
      ),
      solution: Solution(
        message: message,
        actions: [
          SolutionAction(
            type: SolutionActionType.changeDns,
            label: l10n.actionOpenPrivateDns,
            confirmBeforeAct: true,
            confirmationPrompt: l10n.confirmPrivateDns,
          ),
        ],
      ),
    );
  }

  /// [medium] picks the alternative offered: suggesting "switch to mobile data"
  /// is circular when the user is already on mobile data.
  static ({Verdict verdict, Solution solution}) portBlocked(
    AppLocalizations l10n,
    PortProbeResult blocked, {
    required ConnectivityKind medium,
  }) {
    final advice = medium == ConnectivityKind.mobile
        ? l10n.solutionPortBlockedMobile
        : l10n.solutionPortBlockedFixed('${blocked.port}');
    return (
      verdict: Verdict(
        category: VerdictCategory.portBlocked,
        title: l10n.verdictPortBlockedTitle('${blocked.port}'),
        detail: l10n.verdictPortBlockedDetail(
          blocked.service,
          '${blocked.port}',
        ),
        detailArg: '${blocked.port}',
      ),
      solution: Solution(
        message: advice,
        actions: [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
        ],
      ),
    );
  }

  /// [medium] only swaps the noun used for who is at fault: "carrier" reads
  /// more naturally than "ISP" for a cellular link.
  static ({Verdict verdict, Solution solution}) ispPathProblem(
    AppLocalizations l10n,
    IspPathResult path, {
    required ConnectivityKind medium,
  }) {
    final isMobile = medium == ConnectivityKind.mobile;
    final hop =
        path.lastRespondingHop ??
        (isMobile
            ? l10n.verdictIspPathHopGenericMobile
            : l10n.verdictIspPathHopGenericFixed);
    return (
      verdict: Verdict(
        category: VerdictCategory.ispPathProblem,
        title: isMobile
            ? l10n.verdictIspPathMobileTitle
            : l10n.verdictIspPathIspTitle,
        detail: isMobile
            ? l10n.verdictIspPathDetailMobile(hop)
            : l10n.verdictIspPathDetailFixed(hop),
        detailArg: path.lastRespondingHop,
      ),
      solution: Solution(
        message: isMobile
            ? l10n.solutionIspPathMessageMobile
            : l10n.solutionIspPathMessageFixed,
        actions: [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
        ],
      ),
    );
  }

  /// The verdict for a connection that is not broken: what it can and cannot
  /// carry.
  static ({Verdict verdict, Solution? solution}) capability(
    AppLocalizations l10n, {
    required CapabilityAssessment assessment,
    required ConnectivityKind medium,
    required SpeedResult speed,
    required LinkQuality quality,
  }) {
    final mediumName = mediumLabel(l10n, medium);

    switch (assessment.kind) {
      case CapabilityCase.good:
        final uses = _names(l10n, _mostDemanding(assessment.supported, 4));
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionGood,
            title: l10n.verdictCapabilityGoodTitle(mediumName, uses),
            detail: l10n.verdictCapabilityGoodDetail(
              _measured(l10n, medium, speed),
            ),
          ),
          solution: null,
        );

      case CapabilityCase.mostlyGood:
        final failing = _names(l10n, assessment.unsupported.take(3).toList());
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionMostlyGood,
            title: l10n.verdictCapabilityMostlyGoodTitle(mediumName, failing),
            detail: _detail(l10n, assessment, medium, quality),
            detailArg: failing,
          ),
          solution: _advice(l10n, assessment, medium, quality),
        );

      case CapabilityCase.degraded:
        final failing = _names(l10n, assessment.unsupported.take(4).toList());
        return (
          verdict: Verdict(
            category: VerdictCategory.connectionDegraded,
            title: l10n.verdictCapabilityDegradedTitle(mediumName, failing),
            detail: _detail(l10n, assessment, medium, quality),
            detailArg: failing,
          ),
          solution: _advice(l10n, assessment, medium, quality),
        );
    }
  }

  /// How the tested link is named in every sentence the user reads.
  static String mediumLabel(AppLocalizations l10n, ConnectivityKind kind) {
    switch (kind) {
      case ConnectivityKind.wifi:
        return l10n.mediumLabel('wifi');
      case ConnectivityKind.mobile:
        return l10n.mediumLabel('mobile');
      case ConnectivityKind.ethernet:
        return l10n.mediumLabel('ethernet');
      case ConnectivityKind.vpn:
        return l10n.mediumLabel('vpn');
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return l10n.mediumLabel('other');
    }
  }

  /// The figures for a healthy link: what it delivers, nothing else.
  static String _measured(
    AppLocalizations l10n,
    ConnectivityKind medium,
    SpeedResult speed,
  ) {
    final name = mediumLabel(l10n, medium);
    final hasDown = speed.ok;
    final hasUp = speed.uploadMbps != null;
    if (hasDown && hasUp) {
      return l10n.verdictMeasuredBoth(
        name,
        _rate(speed.downloadMbps),
        _rate(speed.uploadMbps!),
      );
    }
    if (hasDown) {
      return l10n.verdictMeasuredDownOnly(name, _rate(speed.downloadMbps));
    }
    if (hasUp) {
      return l10n.verdictMeasuredUpOnly(name, _rate(speed.uploadMbps!));
    }
    return l10n.verdictMeasuredNone(name);
  }

  /// Why the connection falls short: the missing-upload note plus the one
  /// sentence that explains the cause. Measured shortfall figures are kept out
  /// of the verdict — they belong to the capability list and the technical log.
  static String _detail(
    AppLocalizations l10n,
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    final parts = <String>[
      if (!assessment.uploadMeasured) l10n.verdictUploadNotAssessed,
      _because(l10n, assessment, medium, quality),
    ]..removeWhere((s) => s.isEmpty);
    return parts.join(' ');
  }

  /// The cause, with no instruction in it.
  static String _because(
    AppLocalizations l10n,
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    if (medium == ConnectivityKind.wifi && _gatewayWeak(quality)) {
      return l10n.verdictCauseGatewayWeak;
    }
    if (medium == ConnectivityKind.wifi && _saturated(quality)) {
      return l10n.verdictCauseSaturated;
    }
    if (assessment.throughputOnlyProblem) {
      return l10n.verdictCauseThroughput;
    }
    return l10n.verdictCauseGeneric;
  }

  /// What to do — instructions only, and never a repeat of the cause.
  static Solution _advice(
    AppLocalizations l10n,
    CapabilityAssessment assessment,
    ConnectivityKind medium,
    LinkQuality quality,
  ) {
    final steps = <String>[
      if (medium == ConnectivityKind.wifi && _gatewayWeak(quality))
        l10n.adviceMoveCloser
      else if (medium == ConnectivityKind.wifi && _saturated(quality))
        l10n.advicePauseTheHog,
      if (assessment.voiceCallStillFits) l10n.adviceDropTheCamera,
    ];

    return Solution(
      message: steps.join(' '),
      actions: retestActions(l10n, medium),
    );
  }

  /// Offers a fresh test on the same medium and one on the alternative medium.
  static List<SolutionAction> retestActions(
    AppLocalizations l10n,
    ConnectivityKind medium,
  ) {
    switch (medium) {
      case ConnectivityKind.wifi:
        return [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgainWifi,
          ),
          SolutionAction(
            type: SolutionActionType.retestOverMobile,
            label: l10n.crossMediumTestOverMobile,
          ),
        ];
      case ConnectivityKind.mobile:
        return [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgainMobile,
          ),
          SolutionAction(
            type: SolutionActionType.retestOverWifi,
            label: l10n.crossMediumTestOverWifi,
          ),
        ];
      case ConnectivityKind.ethernet:
      case ConnectivityKind.vpn:
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return [
          SolutionAction(
            type: SolutionActionType.retry,
            label: l10n.actionTestAgain,
          ),
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

  static String _names(AppLocalizations l10n, List<UseCaseOutcome> outcomes) {
    final names = outcomes
        .map((o) => l10n.useCaseName(o.id.name))
        .toList();
    if (names.isEmpty) return l10n.useCaseNoneDemanding;
    if (names.length == 1) return names.first;
    if (names.length == 2) return l10n.listTwo(names.first, names.last);
    final head = names.sublist(0, names.length - 1).join(', ');
    return l10n.listAnd(head, names.last);
  }

  static String _rate(double value) =>
      value >= 10 ? value.round().toString() : value.toStringAsFixed(1);
}
