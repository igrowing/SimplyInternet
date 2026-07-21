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
            'Restart your router: unplug it, wait 10 seconds, plug it '
            'back in, and wait about a minute for it to start up. Then run '
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
            'Restart your router once in case it needs to re-establish '
            'the ISP link. If it still fails after a couple of minutes, '
            'contact your Internet provider — the outage is on their side.',
        actions: [
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
            'Switch your Private DNS to a reliable public resolver such '
            'as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.',
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
            'If this is a managed network (work, school, public Wi-Fi), '
            'port ${blocked.port} is blocked by policy — use a different '
            'network or a VPN. On your own network, check the firewall rules '
            'in your router settings.',
        actions: const [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  static ({Verdict verdict, Solution solution}) trafficShaping(
    double downloadMbps,
  ) {
    final mbps = downloadMbps.toStringAsFixed(1);
    return (
      verdict: Verdict(
        category: VerdictCategory.trafficShaping,
        title: 'Possible throttling',
        detail:
            'Everything is connected, but the measured speed is very low '
            '(about $mbps Mbps). Your traffic may be throttled or shaped. '
            'This is a possibility, not a certainty.',
        detailArg: mbps,
      ),
      solution: const Solution(
        message:
            'Try again at a different time, on a different network, or '
            'over a VPN to see if the speed recovers. If only certain apps '
            'are slow, your provider may be shaping that type of traffic — '
            'contact them to confirm your plan speed.',
        actions: [
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
            'There is nothing to fix on your device. Report the failing '
            'route to your Internet provider (mention that traceroute stops '
            'partway). It usually clears once they fix the route.',
        actions: [
          SolutionAction(type: SolutionActionType.retry, label: 'Test again'),
        ],
      ),
    );
  }

  static Verdict allClear() => const Verdict(
    category: VerdictCategory.allClear,
    title: 'All clear — no problem found',
    detail:
        'Your device is connected, the router responds, DNS works, '
        'no ports are blocked and the Internet is reachable at a normal '
        'speed. If something still feels wrong, it may be a specific app '
        'or website rather than your connection.',
  );
}
