// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Internet not working?\nUnstable? Works partially?';

  @override
  String get homeDiagnoseButton => 'Find the problem and give a solution';

  @override
  String get homeUrlPrompt =>
      'A particular website or service not working?\nPaste its link (URL) here:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Check it';

  @override
  String get homeSettingsTooltip => 'Settings';

  @override
  String get homeRunningDiagnosis => 'Running comprehensive check…';

  @override
  String get homeRunningUrlCheck => 'Checking the website…';

  @override
  String get homeCheckFailedTitle => 'The check could not finish';

  @override
  String get homeUnknownError => 'Unknown error';

  @override
  String get homeTryAgain => 'Try again';

  @override
  String get commonBack => 'Back';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageCaption =>
      'The whole app is translated, including the diagnosis results and their technical details.';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get settingsFontSmall => 'Small';

  @override
  String get settingsFontNormal => 'Normal';

  @override
  String get settingsFontLarge => 'Large';

  @override
  String get settingsCheckForUpdate => 'Check for update';

  @override
  String get settingsBuyMeACoffee => 'Buy me a coffee';

  @override
  String get resultWhatToDo => 'What to do';

  @override
  String get resultDialogNotNow => 'Not now';

  @override
  String get resultDialogYes => 'Yes';

  @override
  String get resultNothingToOpen => 'Nothing to open for this step.';

  @override
  String resultActionFailed(String error) {
    return 'Could not complete that action: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'What your connection can do ($fits of $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Upload could not be measured, therefore not assessed.';

  @override
  String get techDetailsTitle => 'Technical details';

  @override
  String get techDetailsCopy => 'Copy';

  @override
  String get techDetailsCopied => 'Technical details copied.';

  @override
  String get urlOpenInBrowser => 'Open in browser';

  @override
  String get urlCheckAnother => 'Check another';

  @override
  String get urlCouldNotOpenBrowser => 'Could not open the browser.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Could not open: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Nothing to test again.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Could not open the settings: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Test over mobile data';

  @override
  String get crossMediumTestOverWifi => 'Test over Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Turn Wi-Fi off, then come back — the check runs again by itself.';

  @override
  String get crossMediumHintWifi =>
      'Turn Wi-Fi on, then come back — the check runs again by itself.';

  @override
  String get verdictFlightModeTitle => 'You are in flight mode';

  @override
  String get verdictFlightModeDetail =>
      'Wireless is switched off, so nothing can reach the Internet while flight mode is on.';

  @override
  String get solutionFlightModeMessage =>
      'Turn off flight mode, then try again.';

  @override
  String get verdictNotConnectedTitle => 'Not connected to any network';

  @override
  String get verdictNotConnectedDetail =>
      'Both Wi-Fi and mobile data appear to be off, so there is no way to reach the Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Turn on Wi-Fi or mobile data, then try again.';

  @override
  String get verdictRouterNotRespondingTitle => 'Router is not responding';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'You\'re connected to the network, but $where isn\'t answering. It may have crashed or lost power.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'your router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'your router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Restart your router: unplug it, wait 30 seconds, plug it back in, and let it take about 2-5 minutes to start up. Then run the test again.';

  @override
  String get verdictCaptivePortalTitle => 'Sign-in required (captive portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'The network wants you to sign in or accept terms on a web page before it lets you online — common in hotels, cafes and airports.';

  @override
  String get solutionCaptivePortalMessage =>
      'Open the sign-in page and complete the login, then run the test again.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Connected to mobile data, but no Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'Your phone reaches the network at a basic level, but it has no working path to the Internet. This points to a problem on your carrier\'s network, not your phone.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Toggle airplane mode on and off, or restart your phone, to reconnect to a fresh tower.\n2. If the test still fails after 2-5 minutes, contact your mobile carrier — the outage is on their side.';

  @override
  String get verdictNoInternetIspTitle =>
      'Connected to router, but no Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'Your router works, but it has no working connection to your Internet provider (ISP). The problem is outside your home.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Check whether your router is connected to the wall phone/DSL socket.\n2. Check the cable is not damaged or loose.\n3. If you have a landline phone, pick up the handset and listen for the dial tone. If you hear no dial tone, contact your phone company and/or Internet provider to fix your line.\n4. Restart your router once to re-establish the ISP link. If the test still fails after 2-5 minutes, contact your Internet provider — the outage is on their side.';

  @override
  String get verdictMobileNoDataTitle =>
      'Mobile data is connected but not working';

  @override
  String get verdictMobileNoDataDetail =>
      'Your phone is on the cellular network, but no data is getting through. This usually means data roaming is off, your data allowance is used up, or your carrier has a local outage.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. If you are abroad or on another network, turn on data roaming in mobile settings.\n2. Check that you still have data allowance left on your plan.\n3. $reception\n4. If it still fails, contact your mobile carrier.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Toggle mobile data off and on.',
      'weak':
          'Your signal is weak: move to a spot with better reception and toggle mobile data off and on.',
      'other':
          'Move to a spot with better signal, or toggle mobile data off and on.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS problem';

  @override
  String get verdictDnsProblemDetail =>
      'The Internet is reachable, but website names are not being translated into addresses. This is a DNS issue and is usually easy to fix by switching to a public DNS resolver.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Switch your Private DNS to a reliable public resolver such as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.\n2. If it still fails, toggle mobile data off and on, or restart your phone, to get a fresh connection.\n3. If it still fails, contact your mobile carrier — some carriers run DNS resolvers that have outages of their own.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Switch your Private DNS to a reliable public resolver such as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.\n2. If you are on a managed network (work, school, public Wi-Fi), contact the network administrator to fix the DNS.\n3. If you are on your own network, check your router settings. It is good practice to configure the secondary DNS to a public resolver as well (examples: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), in case the primary (your Internet provider) fails.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Port $port is blocked';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'General Internet access works, but $service traffic on port $port is being blocked — likely by a firewall on this network. Some apps that rely on this port will not work.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Your mobile carrier is likely blocking it by policy — try Wi-Fi or a VPN instead, or contact your carrier if you need this port open over cellular.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'If you\'re currently connected to a managed network (work, school, public Wi-Fi), port $port is blocked by policy — try mobile data or a VPN instead. On your own network, check the firewall rules in your router settings.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Network path problem at your carrier';

  @override
  String get verdictIspPathIspTitle => 'Network path problem at your ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Your connection reaches the Internet but traffic stops along the way, after $hop. The fault is on your mobile carrier or backbone route, not on your phone.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Your connection reaches the Internet but traffic stops along the way, after $hop. The fault is on your Internet provider or backbone route, not on your device or router.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'a hop inside your mobile carrier';

  @override
  String get verdictIspPathHopGenericFixed =>
      'a hop inside your Internet provider';

  @override
  String get solutionIspPathMessageMobile =>
      'There is nothing to fix on your device or in your network. Report the failing route to your mobile carrier (mention that traceroute stops partway). It usually clears once they fix the route.';

  @override
  String get solutionIspPathMessageFixed =>
      'There is nothing to fix on your device or in your network. Report the failing route to your Internet provider (mention that traceroute stops partway). It usually clears once they fix the route.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Your $medium is good for $uses — and more';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured If something still feels wrong, it is most likely one app or website — not your connection.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Your $medium is good for everything except $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Your $medium is too weak for $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Measured over $medium:\ndownload $down Mbps, upload $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Measured over $medium:\ndownload $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Measured over $medium:\nupload $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Measured over $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'The upload test could not run, therefore not assessed.';

  @override
  String get verdictCauseGatewayWeak =>
      'Your router answers slowly or drops packets, which points at the Wi-Fi itself rather than your provider.';

  @override
  String get verdictCauseSaturated =>
      'The connection slows down sharply while it is busy. Someone or something else on your network (a download, a backup, a TV) is using the line.';

  @override
  String get verdictCauseThroughput =>
      'The connection speed is not sufficient. Either your Internet plan is too slow or your provider is throttling the line.';

  @override
  String get verdictCauseGeneric =>
      'Response times and packet loss vary too much for the most demanding real-time activities.';

  @override
  String get adviceMoveCloser =>
      'Move closer to the router, or try the 5 GHz network if your router offers one.';

  @override
  String get advicePauseTheHog =>
      'Find who or what is using the line heavily and ask them to pause. Otherwise wait, or restart your Wi-Fi — that cuts their connection too.';

  @override
  String get adviceDropTheCamera =>
      'Turn your camera off — your connection can still carry the audio.';

  @override
  String get actionTestAgain => 'Test again';

  @override
  String get actionTestAgainWifi => 'Test again over Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Test again over mobile data';

  @override
  String get actionTurnOnWifi => 'Turn on Wi-Fi';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi is off. Open settings to turn it on?';

  @override
  String get actionTurnOnMobileData => 'Turn on mobile data';

  @override
  String get confirmTurnOnMobileData =>
      'Mobile data is off. Open settings to turn it on?';

  @override
  String get actionOpenFlightSettings => 'Open flight-mode settings';

  @override
  String get confirmFlightMode =>
      'You\'re in flight mode. Open settings to turn it off?';

  @override
  String get actionOpenSignInPage => 'Open sign-in page';

  @override
  String get confirmCaptivePortal =>
      'You\'re blocked by a sign-in page. Open it now?';

  @override
  String get actionOpenMobileDataSettings => 'Open mobile data settings';

  @override
  String get confirmMobileDataSettings =>
      'Open mobile data settings to check roaming and data?';

  @override
  String get actionOpenPrivateDns => 'Open Private DNS settings';

  @override
  String get confirmPrivateDns =>
      'Open Private DNS settings so you can switch to 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'mobile data',
      'ethernet': 'wired connection',
      'vpn': 'VPN connection',
      'other': 'connection',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'music streaming',
      'voiceCalls': 'voice calls',
      'webBrowsing': 'web browsing',
      'losslessMusic': 'lossless music',
      'videoCalls720': 'video calls (720p)',
      'teamGames': 'team games',
      'videoCallsHd': 'video calls (HD)',
      'hdVideo': 'HD video (1080p)',
      'fastGames': 'fast online games',
      'video4k': '4K video',
      'other': 'this activity',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'anything demanding';

  @override
  String listTwo(String a, String b) {
    return '$a and $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head and $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'download $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'upload $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'latency $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'packet loss $value%';
  }

  @override
  String get logHeadDeviceLink => 'Device link';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Internet reachability';

  @override
  String get logHeadPorts => 'Ports';

  @override
  String get logHeadPopularSites => 'Popular sites';

  @override
  String get logHeadMeasurements => 'Measurements';

  @override
  String get logHeadGoodFor => 'Good for';

  @override
  String get logHeadNotGoodFor => 'Not good enough for';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Tests performed ($count)';
  }

  @override
  String get logYes => 'yes';

  @override
  String get logNo => 'no';

  @override
  String get logUnknown => 'unknown';

  @override
  String get logNotApplicable => 'n/a';

  @override
  String get logNotMeasured => 'not measured';

  @override
  String get logNotReported => 'not reported';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Connectivity: $kind, flight mode: $flight';
  }

  @override
  String get logFlightOn => 'on ✈️';

  @override
  String get logFlightOff => 'off ✅';

  @override
  String logGateway(String value) {
    return 'Gateway: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Gateway reachable: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'reachable ✅';

  @override
  String get logInternetReachableNo => 'no answer ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Captive sign-in page: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Raw IP address reachable: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Name resolves ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Route reached the Internet: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Route reached the Internet: $answer (last hop: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Port $port/$service: $state';
  }

  @override
  String get logPortOpen => 'open ✅';

  @override
  String get logPortBlocked => 'blocked ❌';

  @override
  String logPopularCountry(String value) {
    return 'Country: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Popular sites reachable: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Tested over: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Mobile data was measured because it is the link in use (Wi-Fi not connected, or you chose to retest over mobile)';

  @override
  String logCellularSignalReported(int level) {
    return 'Cellular signal: $level of 4';
  }

  @override
  String get logCellularSignalMissing => 'Cellular signal: not reported';

  @override
  String logDownloadLine(String value) {
    return 'Download: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Upload: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Moved by the speed test: received $received, sent $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label response time: no reply to $sent probes';
  }

  @override
  String logLatencyLine(
    String label,
    int avg,
    int min,
    int max,
    String jitter,
    int loss,
    int received,
    int sent,
  ) {
    return '$label response time: $avg ms avg (min $min, max $max), jitter $jitter ms, loss $loss% ($received/$sent replies)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Response time while busy: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Response time while busy: $ms ms (${ratio}x idle)';
  }

  @override
  String logNotGoodForItem(String name, String shortfalls) {
    return '$name — $shortfalls';
  }

  @override
  String logTestRecord(String test, String target, String traffic) {
    return '$test → $target$traffic';
  }

  @override
  String logTotalData(String traffic) {
    return 'Total data used by this diagnosis: $traffic';
  }

  @override
  String get logTotalCovers =>
      'That total covers every test above, not only the speed test';

  @override
  String logTrafficSent(String size) {
    return 'sent $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'received $size';
  }
}
