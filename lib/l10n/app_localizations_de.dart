// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get homeTitle =>
      'Internet funktioniert nicht?\nInstabil? Funktioniert nur teilweise?';

  @override
  String get homeDiagnoseButton => 'Problem finden und Lösung anzeigen';

  @override
  String get homeUrlPrompt =>
      'Eine bestimmte Website oder ein Dienst funktioniert nicht?\nFüge den Link (URL) hier ein:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Prüfen';

  @override
  String get homeSettingsTooltip => 'Einstellungen';

  @override
  String get homeRunningDiagnosis => 'Umfassende Prüfung läuft…';

  @override
  String get homeRunningUrlCheck => 'Website wird geprüft…';

  @override
  String get homeCheckFailedTitle =>
      'Die Prüfung konnte nicht abgeschlossen werden';

  @override
  String get homeUnknownError => 'Unbekannter Fehler';

  @override
  String get homeTryAgain => 'Erneut versuchen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageCaption =>
      'Die gesamte App ist übersetzt, einschließlich der Diagnoseergebnisse und ihrer technischen Details.';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsFontSize => 'Schriftgröße';

  @override
  String get settingsFontSmall => 'Klein';

  @override
  String get settingsFontNormal => 'Normal';

  @override
  String get settingsFontLarge => 'Groß';

  @override
  String get settingsCheckForUpdate => 'Nach Updates suchen';

  @override
  String get settingsBuyMeACoffee => 'Spendier mir einen Kaffee';

  @override
  String get resultWhatToDo => 'Was zu tun ist';

  @override
  String get resultDialogNotNow => 'Nicht jetzt';

  @override
  String get resultDialogYes => 'Ja';

  @override
  String get resultNothingToOpen =>
      'Für diesen Schritt gibt es nichts zu öffnen.';

  @override
  String resultActionFailed(String error) {
    return 'Diese Aktion konnte nicht abgeschlossen werden: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Was Ihre Verbindung leisten kann ($fits von $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Der Upload konnte nicht gemessen werden und wurde daher nicht bewertet.';

  @override
  String get techDetailsTitle => 'Technische Details';

  @override
  String get techDetailsCopy => 'Kopieren';

  @override
  String get techDetailsCopied => 'Technische Details kopiert.';

  @override
  String get urlOpenInBrowser => 'Im Browser öffnen';

  @override
  String get urlCheckAnother => 'Weitere prüfen';

  @override
  String get urlCouldNotOpenBrowser =>
      'Der Browser konnte nicht geöffnet werden.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Öffnen fehlgeschlagen: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Nichts zum erneuten Testen vorhanden.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Die Einstellungen konnten nicht geöffnet werden: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Über mobile Daten testen';

  @override
  String get crossMediumTestOverWifi => 'Über WLAN testen';

  @override
  String get crossMediumHintMobile =>
      'Schalte WLAN aus und komm dann zurück – die Prüfung läuft automatisch erneut.';

  @override
  String get crossMediumHintWifi =>
      'Schalte WLAN ein und komm dann zurück – die Prüfung läuft automatisch erneut.';

  @override
  String get verdictFlightModeTitle => 'Du bist im Flugmodus';

  @override
  String get verdictFlightModeDetail =>
      'Die Drahtlosverbindung ist ausgeschaltet, daher kann im Flugmodus nichts das Internet erreichen.';

  @override
  String get solutionFlightModeMessage =>
      'Schalte den Flugmodus aus und versuche es erneut.';

  @override
  String get verdictNotConnectedTitle => 'Mit keinem Netzwerk verbunden';

  @override
  String get verdictNotConnectedDetail =>
      'WLAN und mobile Daten scheinen beide aus zu sein, daher gibt es keinen Weg ins Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Schalte WLAN oder mobile Daten ein und versuche es erneut.';

  @override
  String get verdictRouterNotRespondingTitle => 'Der Router antwortet nicht';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Du bist mit dem Netzwerk verbunden, aber $where antwortet nicht. Er ist möglicherweise abgestürzt oder ohne Strom.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'dein Router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'dein Router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Starte deinen Router neu: Ziehe den Stecker, warte 30 Sekunden, stecke ihn wieder ein und gib ihm etwa 2–5 Minuten zum Hochfahren. Führe den Test dann erneut aus.';

  @override
  String get verdictCaptivePortalTitle =>
      'Anmeldung erforderlich (Captive Portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'Das Netzwerk verlangt, dass du dich auf einer Webseite anmeldest oder Nutzungsbedingungen akzeptierst, bevor du online gehen kannst – üblich in Hotels, Cafés und an Flughäfen.';

  @override
  String get solutionCaptivePortalMessage =>
      'Öffne die Anmeldeseite und schließe die Anmeldung ab, führe den Test dann erneut aus.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Mit mobilen Daten verbunden, aber kein Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'Dein Telefon erreicht das Netz auf einer grundlegenden Ebene, hat aber keinen funktionierenden Weg ins Internet. Das deutet auf ein Problem im Netz deines Anbieters hin, nicht auf deinem Telefon.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Schalte den Flugmodus einmal ein und wieder aus oder starte dein Telefon neu, um dich mit einem frischen Funkmast zu verbinden.\n2. Wenn der Test nach 2–5 Minuten weiterhin fehlschlägt, wende dich an deinen Mobilfunkanbieter – die Störung liegt auf seiner Seite.';

  @override
  String get verdictNoInternetIspTitle =>
      'Mit dem Router verbunden, aber kein Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'Dein Router funktioniert, hat aber keine funktionierende Verbindung zu deinem Internetanbieter (ISP). Das Problem liegt außerhalb deines Zuhauses.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Prüfe, ob dein Router mit der Telefon-/DSL-Dose an der Wand verbunden ist.\n2. Prüfe, ob das Kabel nicht beschädigt oder locker ist.\n3. Wenn du ein Festnetztelefon hast, nimm den Hörer ab und höre auf das Freizeichen. Hörst du kein Freizeichen, wende dich an deine Telefongesellschaft und/oder deinen Internetanbieter, um deine Leitung reparieren zu lassen.\n4. Starte deinen Router einmal neu, um die ISP-Verbindung wiederherzustellen. Wenn der Test nach 2–5 Minuten weiterhin fehlschlägt, wende dich an deinen Internetanbieter – die Störung liegt auf seiner Seite.';

  @override
  String get verdictMobileNoDataTitle =>
      'Mobile Daten sind verbunden, funktionieren aber nicht';

  @override
  String get verdictMobileNoDataDetail =>
      'Dein Telefon ist im Mobilfunknetz, aber es kommen keine Daten durch. Das bedeutet meist, dass Daten-Roaming aus ist, dein Datenvolumen aufgebraucht ist oder dein Anbieter eine lokale Störung hat.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Wenn du im Ausland oder in einem anderen Netz bist, schalte Daten-Roaming in den Mobilfunkeinstellungen ein.\n2. Prüfe, ob dein Tarif noch Datenvolumen übrig hat.\n3. $reception\n4. Wenn es weiterhin fehlschlägt, wende dich an deinen Mobilfunkanbieter.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Schalte die mobilen Daten einmal aus und wieder ein.',
      'weak':
          'Dein Signal ist schwach: Geh an einen Ort mit besserem Empfang und schalte die mobilen Daten einmal aus und wieder ein.',
      'other':
          'Geh an einen Ort mit besserem Signal oder schalte die mobilen Daten einmal aus und wieder ein.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS-Problem';

  @override
  String get verdictDnsProblemDetail =>
      'Das Internet ist erreichbar, aber Website-Namen werden nicht in Adressen übersetzt. Das ist ein DNS-Problem und lässt sich meist leicht beheben, indem man auf einen öffentlichen DNS-Resolver wechselt.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Stelle dein privates DNS auf einen zuverlässigen öffentlichen Resolver wie 1.1.1.1 (Cloudflare) oder 8.8.8.8 (Google) um und teste erneut.\n2. Wenn es weiterhin fehlschlägt, schalte die mobilen Daten einmal aus und wieder ein oder starte dein Telefon neu, um eine frische Verbindung zu bekommen.\n3. Wenn es weiterhin fehlschlägt, wende dich an deinen Mobilfunkanbieter – manche Anbieter betreiben eigene DNS-Resolver, die selbst Störungen haben.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Stelle dein privates DNS auf einen zuverlässigen öffentlichen Resolver wie 1.1.1.1 (Cloudflare) oder 8.8.8.8 (Google) um und teste erneut.\n2. Wenn du in einem verwalteten Netzwerk bist (Arbeit, Schule, öffentliches WLAN), wende dich an die Netzwerkadministration, um das DNS zu reparieren.\n3. Wenn du in deinem eigenen Netzwerk bist, prüfe deine Routereinstellungen. Es ist gute Praxis, auch das sekundäre DNS auf einen öffentlichen Resolver zu setzen (Beispiele: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), falls das primäre (dein Internetanbieter) ausfällt.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Port $port ist blockiert';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'Der allgemeine Internetzugang funktioniert, aber $service-Verkehr auf Port $port wird blockiert – wahrscheinlich durch eine Firewall in diesem Netzwerk. Manche Apps, die auf diesen Port angewiesen sind, funktionieren nicht.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Dein Mobilfunkanbieter blockiert ihn wahrscheinlich per Richtlinie – probiere stattdessen WLAN oder ein VPN, oder wende dich an deinen Anbieter, wenn du diesen Port über Mobilfunk offen brauchst.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Wenn du gerade mit einem verwalteten Netzwerk verbunden bist (Arbeit, Schule, öffentliches WLAN), ist Port $port per Richtlinie blockiert – probiere stattdessen mobile Daten oder ein VPN. In deinem eigenen Netzwerk prüfe die Firewall-Regeln in deinen Routereinstellungen.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Netzwerkpfad-Problem bei deinem Anbieter';

  @override
  String get verdictIspPathIspTitle => 'Netzwerkpfad-Problem bei deinem ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Deine Verbindung erreicht das Internet, aber der Verkehr bleibt unterwegs stehen, nach $hop. Der Fehler liegt bei deinem Mobilfunkanbieter oder auf der Backbone-Route, nicht auf deinem Telefon.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Deine Verbindung erreicht das Internet, aber der Verkehr bleibt unterwegs stehen, nach $hop. Der Fehler liegt bei deinem Internetanbieter oder auf der Backbone-Route, nicht auf deinem Gerät oder Router.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'einem Knoten innerhalb deines Mobilfunkanbieters';

  @override
  String get verdictIspPathHopGenericFixed =>
      'einem Knoten innerhalb deines Internetanbieters';

  @override
  String get solutionIspPathMessageMobile =>
      'Auf deinem Gerät oder in deinem Netzwerk gibt es nichts zu reparieren. Melde die fehlerhafte Route deinem Mobilfunkanbieter (erwähne, dass Traceroute unterwegs abbricht). Sie verschwindet meist, sobald die Route repariert ist.';

  @override
  String get solutionIspPathMessageFixed =>
      'Auf deinem Gerät oder in deinem Netzwerk gibt es nichts zu reparieren. Melde die fehlerhafte Route deinem Internetanbieter (erwähne, dass Traceroute unterwegs abbricht). Sie verschwindet meist, sobald die Route repariert ist.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Dein $medium ist gut für $uses – und mehr';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Wenn sich trotzdem etwas falsch anfühlt, liegt es höchstwahrscheinlich an einer App oder Website – nicht an deiner Verbindung.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Dein $medium ist für alles gut außer für $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Dein $medium ist zu schwach für $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Gemessen über $medium:\nDownload $down Mbps, Upload $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Gemessen über $medium:\nDownload $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Gemessen über $medium:\nUpload $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Gemessen über $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Der Upload-Test konnte nicht ausgeführt werden und wurde daher nicht bewertet.';

  @override
  String get verdictCauseGatewayWeak =>
      'Dein Router antwortet langsam oder verliert Pakete, was auf das WLAN selbst hindeutet und nicht auf deinen Anbieter.';

  @override
  String get verdictCauseSaturated =>
      'Die Verbindung wird deutlich langsamer, während sie ausgelastet ist. Jemand oder etwas anderes in deinem Netzwerk (ein Download, ein Backup, ein Fernseher) nutzt die Leitung.';

  @override
  String get verdictCauseThroughput =>
      'Die Verbindungsgeschwindigkeit reicht nicht aus. Entweder ist dein Internettarif zu langsam oder dein Anbieter drosselt die Leitung.';

  @override
  String get verdictCauseGeneric =>
      'Antwortzeiten und Paketverlust schwanken zu stark für die anspruchsvollsten Echtzeit-Aktivitäten.';

  @override
  String get adviceMoveCloser =>
      'Geh näher an den Router oder nutze das 5-GHz-Netz, falls dein Router eines anbietet.';

  @override
  String get advicePauseTheHog =>
      'Finde heraus, wer oder was die Leitung stark nutzt, und bitte darum, es zu pausieren. Andernfalls warte oder starte dein WLAN neu – das trennt deren Verbindung ebenfalls.';

  @override
  String get adviceDropTheCamera =>
      'Schalte deine Kamera aus – deine Verbindung kann den Ton trotzdem übertragen.';

  @override
  String get actionTestAgain => 'Erneut testen';

  @override
  String get actionTestAgainWifi => 'Erneut über WLAN testen';

  @override
  String get actionTestAgainMobile => 'Erneut über mobile Daten testen';

  @override
  String get actionTurnOnWifi => 'WLAN einschalten';

  @override
  String get confirmTurnOnWifi =>
      'WLAN ist aus. Einstellungen öffnen, um es einzuschalten?';

  @override
  String get actionTurnOnMobileData => 'Mobile Daten einschalten';

  @override
  String get confirmTurnOnMobileData =>
      'Mobile Daten sind aus. Einstellungen öffnen, um sie einzuschalten?';

  @override
  String get actionOpenFlightSettings => 'Flugmodus-Einstellungen öffnen';

  @override
  String get confirmFlightMode =>
      'Du bist im Flugmodus. Einstellungen öffnen, um ihn auszuschalten?';

  @override
  String get actionOpenSignInPage => 'Anmeldeseite öffnen';

  @override
  String get confirmCaptivePortal =>
      'Du wirst von einer Anmeldeseite blockiert. Jetzt öffnen?';

  @override
  String get actionOpenMobileDataSettings =>
      'Einstellungen für mobile Daten öffnen';

  @override
  String get confirmMobileDataSettings =>
      'Einstellungen für mobile Daten öffnen, um Roaming und Datenvolumen zu prüfen?';

  @override
  String get actionOpenPrivateDns => 'Einstellungen für privates DNS öffnen';

  @override
  String get confirmPrivateDns =>
      'Einstellungen für privates DNS öffnen, damit du zu 1.1.1.1 wechseln kannst?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'WLAN',
      'mobile': 'mobile Daten',
      'ethernet': 'kabelgebundene Verbindung',
      'vpn': 'VPN-Verbindung',
      'other': 'Verbindung',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'Musik-Streaming',
      'voiceCalls': 'Sprachanrufe',
      'webBrowsing': 'Surfen im Web',
      'losslessMusic': 'verlustfreie Musik',
      'videoCalls720': 'Videoanrufe (720p)',
      'teamGames': 'Team-Spiele',
      'videoCallsHd': 'Videoanrufe (HD)',
      'hdVideo': 'HD-Video (1080p)',
      'fastGames': 'schnelle Online-Spiele',
      'video4k': '4K-Video',
      'other': 'diese Aktivität',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'alles Anspruchsvolle';

  @override
  String listTwo(String a, String b) {
    return '$a und $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head und $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'Download $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'Upload $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'Latenz $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'Jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'Paketverlust $value%';
  }

  @override
  String get logHeadDeviceLink => 'Geräteverbindung';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Internet-Erreichbarkeit';

  @override
  String get logHeadPorts => 'Ports';

  @override
  String get logHeadPopularSites => 'Beliebte Websites';

  @override
  String get logHeadMeasurements => 'Messungen';

  @override
  String get logHeadGoodFor => 'Gut für';

  @override
  String get logHeadNotGoodFor => 'Nicht gut genug für';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Durchgeführte Tests ($count)';
  }

  @override
  String get logYes => 'ja';

  @override
  String get logNo => 'nein';

  @override
  String get logUnknown => 'unbekannt';

  @override
  String get logNotApplicable => 'n. v.';

  @override
  String get logNotMeasured => 'nicht gemessen';

  @override
  String get logNotReported => 'nicht gemeldet';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Konnektivität: $kind, Flugmodus: $flight';
  }

  @override
  String get logFlightOn => 'an ✈️';

  @override
  String get logFlightOff => 'aus ✅';

  @override
  String logGateway(String value) {
    return 'Gateway: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Gateway erreichbar: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'erreichbar ✅';

  @override
  String get logInternetReachableNo => 'keine Antwort ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Captive-Anmeldeseite: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Reine IP-Adresse erreichbar: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Name wird aufgelöst ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Route hat das Internet erreicht: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Route hat das Internet erreicht: $answer (letzter Hop: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Port $port/$service: $state';
  }

  @override
  String get logPortOpen => 'offen ✅';

  @override
  String get logPortBlocked => 'blockiert ❌';

  @override
  String logPopularCountry(String value) {
    return 'Land: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Beliebte Websites erreichbar: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Getestet über: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Mobile Daten wurden gemessen, weil sie die genutzte Verbindung sind (WLAN nicht verbunden oder du hast einen erneuten Test über Mobilfunk gewählt)';

  @override
  String logCellularSignalReported(int level) {
    return 'Mobilfunksignal: $level von 4';
  }

  @override
  String get logCellularSignalMissing => 'Mobilfunksignal: nicht gemeldet';

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
    return 'Vom Geschwindigkeitstest bewegt: empfangen $received, gesendet $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label-Antwortzeit: keine Antwort auf $sent Prüfpakete';
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
    return '$label-Antwortzeit: $avg ms Durchschnitt (min $min, max $max), Jitter $jitter ms, Verlust $loss% ($received/$sent Antworten)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Antwortzeit unter Last: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Antwortzeit unter Last: $ms ms ($ratio× Leerlauf)';
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
    return 'Von dieser Diagnose insgesamt genutzte Daten: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Diese Summe umfasst jeden Test oben, nicht nur den Geschwindigkeitstest';

  @override
  String logTrafficSent(String size) {
    return 'gesendet $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'empfangen $size';
  }
}
