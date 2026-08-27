// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get homeTitle =>
      'Internet nefunguje?\nNestabilní? Funguje jen částečně?';

  @override
  String get homeDiagnoseButton => 'Najít problém a nabídnout řešení';

  @override
  String get homeUrlPrompt =>
      'Konkrétní web nebo služba nefunguje?\nVložte sem jeho odkaz (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Zkontrolovat';

  @override
  String get homeSettingsTooltip => 'Nastavení';

  @override
  String get homeRunningDiagnosis => 'Probíhá komplexní kontrola…';

  @override
  String get homeRunningUrlCheck => 'Kontroluje se web…';

  @override
  String get homeCheckFailedTitle => 'Kontrolu se nepodařilo dokončit';

  @override
  String get homeUnknownError => 'Neznámá chyba';

  @override
  String get homeTryAgain => 'Zkusit znovu';

  @override
  String get commonBack => 'Zpět';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageCaption =>
      'Celá aplikace je přeložená, včetně výsledků diagnostiky a jejich technických podrobností.';

  @override
  String get settingsTheme => 'Motiv';

  @override
  String get settingsThemeSystem => 'Systém';

  @override
  String get settingsThemeLight => 'Světlý';

  @override
  String get settingsThemeDark => 'Tmavý';

  @override
  String get settingsFontSize => 'Velikost písma';

  @override
  String get settingsFontSmall => 'Malé';

  @override
  String get settingsFontNormal => 'Normální';

  @override
  String get settingsFontLarge => 'Velké';

  @override
  String get settingsCheckForUpdate => 'Zkontrolovat aktualizace';

  @override
  String get settingsBuyMeACoffee => 'Kup mi kávu';

  @override
  String get resultWhatToDo => 'Co dělat';

  @override
  String get resultDialogNotNow => 'Teď ne';

  @override
  String get resultDialogYes => 'Ano';

  @override
  String get resultNothingToOpen => 'Pro tento krok není co otevřít.';

  @override
  String resultActionFailed(String error) {
    return 'Akci se nepodařilo dokončit: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Co vaše připojení zvládne ($fits z $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Upload se nepodařilo změřit, proto nebyl vyhodnocen.';

  @override
  String get techDetailsTitle => 'Technické podrobnosti';

  @override
  String get techDetailsCopy => 'Kopírovat';

  @override
  String get techDetailsCopied => 'Technické podrobnosti zkopírovány.';

  @override
  String get urlOpenInBrowser => 'Otevřít v prohlížeči';

  @override
  String get urlCheckAnother => 'Zkontrolovat další';

  @override
  String get urlCouldNotOpenBrowser => 'Prohlížeč se nepodařilo otevřít.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Otevření se nezdařilo: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Není co znovu testovat.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Nastavení se nepodařilo otevřít: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Testovat přes mobilní data';

  @override
  String get crossMediumTestOverWifi => 'Testovat přes Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Vypněte Wi-Fi a pak se vraťte — kontrola se spustí znovu sama.';

  @override
  String get crossMediumHintWifi =>
      'Zapněte Wi-Fi a pak se vraťte — kontrola se spustí znovu sama.';

  @override
  String get verdictFlightModeTitle => 'Jste v režimu letadlo';

  @override
  String get verdictFlightModeDetail =>
      'Bezdrátové připojení je vypnuté, takže dokud je režim letadlo zapnutý, nic se nedostane na internet.';

  @override
  String get solutionFlightModeMessage =>
      'Vypněte režim letadlo a zkuste to znovu.';

  @override
  String get verdictNotConnectedTitle => 'Nepřipojeno k žádné síti';

  @override
  String get verdictNotConnectedDetail =>
      'Wi-Fi i mobilní data jsou zřejmě vypnutá, takže se nedá dostat na internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Zapněte Wi-Fi nebo mobilní data a zkuste to znovu.';

  @override
  String get verdictRouterNotRespondingTitle => 'Router neodpovídá';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Jste připojeni k síti, ale $where neodpovídá. Mohl spadnout nebo přijít o napájení.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'váš router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'váš router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Restartujte router: odpojte ho ze zásuvky, počkejte 30 sekund, znovu ho zapojte a nechte mu asi 2–5 minut na naběhnutí. Poté test spusťte znovu.';

  @override
  String get verdictCaptivePortalTitle =>
      'Vyžadováno přihlášení (captive portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'Síť chce, abyste se přihlásili nebo přijali podmínky na webové stránce, než vás pustí online – běžné v hotelech, kavárnách a na letištích.';

  @override
  String get solutionCaptivePortalMessage =>
      'Otevřete přihlašovací stránku a dokončete přihlášení, poté test spusťte znovu.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Připojeno k mobilním datům, ale bez internetu';

  @override
  String get verdictNoInternetMobileDetail =>
      'Telefon se k síti dostane na základní úrovni, ale nemá funkční cestu na internet. To ukazuje na problém v síti vašeho operátora, ne v telefonu.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Zapněte a vypněte režim letadlo nebo restartujte telefon, aby se připojil k nové vysílací věži.\n2. Pokud test i po 2–5 minutách stále selhává, kontaktujte svého mobilního operátora – výpadek je na jeho straně.';

  @override
  String get verdictNoInternetIspTitle =>
      'Připojeno k routeru, ale bez internetu';

  @override
  String get verdictNoInternetIspDetail =>
      'Router funguje, ale nemá funkční připojení k vašemu poskytovateli internetu (ISP). Problém je mimo váš domov.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Zkontrolujte, zda je router připojený k telefonní/DSL zásuvce ve zdi.\n2. Zkontrolujte, že kabel není poškozený ani uvolněný.\n3. Pokud máte pevnou linku, zvedněte sluchátko a poslechněte si oznamovací tón. Pokud neslyšíte tón, kontaktujte telefonní společnost a/nebo poskytovatele internetu, ať vám opraví linku.\n4. Jednou router restartujte, aby se obnovilo spojení s ISP. Pokud test i po 2–5 minutách stále selhává, kontaktujte poskytovatele internetu – výpadek je na jeho straně.';

  @override
  String get verdictMobileNoDataTitle =>
      'Mobilní data jsou připojena, ale nefungují';

  @override
  String get verdictMobileNoDataDetail =>
      'Telefon je v mobilní síti, ale žádná data neprocházejí. Obvykle to znamená, že je vypnutý datový roaming, došel vám datový limit, nebo má operátor místní výpadek.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Pokud jste v zahraničí nebo v jiné síti, zapněte v nastavení mobilní sítě datový roaming.\n2. Zkontrolujte, že vám v tarifu ještě zbývají data.\n3. $reception\n4. Pokud to stále selhává, kontaktujte svého mobilního operátora.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Vypněte a znovu zapněte mobilní data.',
      'weak':
          'Signál je slabý: přejděte na místo s lepším příjmem a vypněte a znovu zapněte mobilní data.',
      'other':
          'Přejděte na místo s lepším signálem, nebo vypněte a znovu zapněte mobilní data.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problém s DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Internet je dostupný, ale názvy webů se nepřekládají na adresy. Jde o problém s DNS a obvykle se snadno vyřeší přepnutím na veřejný DNS resolver.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Přepněte své soukromé DNS na spolehlivý veřejný resolver, například 1.1.1.1 (Cloudflare) nebo 8.8.8.8 (Google), a otestujte znovu.\n2. Pokud to stále selhává, vypněte a znovu zapněte mobilní data, nebo restartujte telefon, ať získáte nové spojení.\n3. Pokud to stále selhává, kontaktujte svého mobilního operátora – někteří operátoři provozují vlastní DNS resolvery, které mají vlastní výpadky.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Přepněte své soukromé DNS na spolehlivý veřejný resolver, například 1.1.1.1 (Cloudflare) nebo 8.8.8.8 (Google), a otestujte znovu.\n2. Pokud jste ve spravované síti (práce, škola, veřejná Wi-Fi), kontaktujte správce sítě, ať DNS opraví.\n3. Pokud jste ve vlastní síti, zkontrolujte nastavení routeru. Je dobré nastavit i sekundární DNS na veřejný resolver (příklady: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8) pro případ, že primární (váš poskytovatel internetu) selže.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Port $port je blokovaný';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'Obecný přístup na internet funguje, ale provoz $service na portu $port je blokovaný – pravděpodobně firewallem v této síti. Některé aplikace, které tento port potřebují, nebudou fungovat.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Váš mobilní operátor ho pravděpodobně blokuje podle svých pravidel – zkuste místo toho Wi-Fi nebo VPN, nebo kontaktujte operátora, pokud tento port přes mobilní síť potřebujete otevřený.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Pokud jste právě připojeni ke spravované síti (práce, škola, veřejná Wi-Fi), port $port je blokovaný podle pravidel – zkuste místo toho mobilní data nebo VPN. Ve vlastní síti zkontrolujte pravidla firewallu v nastavení routeru.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problém s cestou v síti u vašeho operátora';

  @override
  String get verdictIspPathIspTitle => 'Problém s cestou v síti u vašeho ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Vaše připojení se dostane na internet, ale provoz se cestou zastaví, za $hop. Chyba je u vašeho mobilního operátora nebo na páteřní trase, ne v telefonu.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Vaše připojení se dostane na internet, ale provoz se cestou zastaví, za $hop. Chyba je u vašeho poskytovatele internetu nebo na páteřní trase, ne ve vašem zařízení ani v routeru.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'uzlem uvnitř vašeho mobilního operátora';

  @override
  String get verdictIspPathHopGenericFixed =>
      'uzlem uvnitř vašeho poskytovatele internetu';

  @override
  String get solutionIspPathMessageMobile =>
      'Na vašem zařízení ani ve vaší síti není co opravovat. Nahlaste vadnou trasu svému mobilnímu operátorovi (uveďte, že se traceroute zastaví v půli cesty). Obvykle se to spraví, jakmile trasu opraví.';

  @override
  String get solutionIspPathMessageFixed =>
      'Na vašem zařízení ani ve vaší síti není co opravovat. Nahlaste vadnou trasu svému poskytovateli internetu (uveďte, že se traceroute zastaví v půli cesty). Obvykle se to spraví, jakmile trasu opraví.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Vaše $medium zvládne $uses – a víc';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Pokud přesto něco nefunguje, jde nejspíš o jednu aplikaci nebo web – ne o vaše připojení.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Vaše $medium zvládne vše kromě $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Vaše $medium je příliš slabé pro $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Měřeno přes $medium:\nstahování $down Mbps, odesílání $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Měřeno přes $medium:\nstahování $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Měřeno přes $medium:\nodesílání $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Měřeno přes $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Test odesílání se nepodařilo spustit, proto nebyl vyhodnocen.';

  @override
  String get verdictCauseGatewayWeak =>
      'Router odpovídá pomalu nebo zahazuje pakety, což ukazuje na samotnou Wi-Fi, ne na vašeho poskytovatele.';

  @override
  String get verdictCauseSaturated =>
      'Připojení se prudce zpomaluje, když je vytížené. Někdo nebo něco jiného ve vaší síti (stahování, zálohování, televize) využívá linku.';

  @override
  String get verdictCauseThroughput =>
      'Rychlost připojení není dostatečná. Buď je váš internetový tarif příliš pomalý, nebo vám poskytovatel linku omezuje.';

  @override
  String get verdictCauseGeneric =>
      'Doby odezvy a ztrátovost paketů kolísají příliš na nejnáročnější činnosti v reálném čase.';

  @override
  String get adviceMoveCloser =>
      'Přesuňte se blíž k routeru, nebo vyzkoušejte síť 5 GHz, pokud ji router nabízí.';

  @override
  String get advicePauseTheHog =>
      'Zjistěte, kdo nebo co linku silně využívá, a požádejte o pozastavení. Jinak počkejte, nebo restartujte Wi-Fi – to odpojí i je.';

  @override
  String get adviceDropTheCamera =>
      'Vypněte kameru – vaše připojení zvuk stále zvládne.';

  @override
  String get actionTestAgain => 'Testovat znovu';

  @override
  String get actionTestAgainWifi => 'Testovat znovu přes Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Testovat znovu přes mobilní data';

  @override
  String get actionTurnOnWifi => 'Zapnout Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi je vypnutá. Otevřít nastavení a zapnout ji?';

  @override
  String get actionTurnOnMobileData => 'Zapnout mobilní data';

  @override
  String get confirmTurnOnMobileData =>
      'Mobilní data jsou vypnutá. Otevřít nastavení a zapnout je?';

  @override
  String get actionOpenFlightSettings => 'Otevřít nastavení režimu letadlo';

  @override
  String get confirmFlightMode =>
      'Jste v režimu letadlo. Otevřít nastavení a vypnout ho?';

  @override
  String get actionOpenSignInPage => 'Otevřít přihlašovací stránku';

  @override
  String get confirmCaptivePortal =>
      'Blokuje vás přihlašovací stránka. Otevřít ji teď?';

  @override
  String get actionOpenMobileDataSettings => 'Otevřít nastavení mobilních dat';

  @override
  String get confirmMobileDataSettings =>
      'Otevřít nastavení mobilních dat a zkontrolovat roaming a data?';

  @override
  String get actionOpenPrivateDns => 'Otevřít nastavení soukromého DNS';

  @override
  String get confirmPrivateDns =>
      'Otevřít nastavení soukromého DNS, abyste mohli přepnout na 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'mobilní data',
      'ethernet': 'drátové připojení',
      'vpn': 'připojení VPN',
      'other': 'připojení',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streamování hudby',
      'voiceCalls': 'hlasové hovory',
      'webBrowsing': 'prohlížení webu',
      'losslessMusic': 'bezztrátová hudba',
      'videoCalls720': 'videohovory (720p)',
      'teamGames': 'týmové hry',
      'videoCallsHd': 'videohovory (HD)',
      'hdVideo': 'HD video (1080p)',
      'fastGames': 'rychlé online hry',
      'video4k': '4K video',
      'other': 'tato činnost',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'cokoli náročného';

  @override
  String listTwo(String a, String b) {
    return '$a a $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head a $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'stahování $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'odesílání $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'odezva $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'ztrátovost paketů $value%';
  }

  @override
  String get logHeadDeviceLink => 'Připojení zařízení';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Dostupnost internetu';

  @override
  String get logHeadPorts => 'Porty';

  @override
  String get logHeadPopularSites => 'Populární weby';

  @override
  String get logHeadMeasurements => 'Měření';

  @override
  String get logHeadGoodFor => 'Vhodné pro';

  @override
  String get logHeadNotGoodFor => 'Nedostačující pro';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Provedené testy ($count)';
  }

  @override
  String get logYes => 'ano';

  @override
  String get logNo => 'ne';

  @override
  String get logUnknown => 'neznámé';

  @override
  String get logNotApplicable => 'n/a';

  @override
  String get logNotMeasured => 'neměřeno';

  @override
  String get logNotReported => 'neuvedeno';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Konektivita: $kind, režim letadlo: $flight';
  }

  @override
  String get logFlightOn => 'zapnuto ✈️';

  @override
  String get logFlightOff => 'vypnuto ✅';

  @override
  String logGateway(String value) {
    return 'Brána: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Brána dostupná: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'dostupný ✅';

  @override
  String get logInternetReachableNo => 'žádná odpověď ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Přihlašovací stránka captive: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Přímá IP adresa dostupná: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Název se přeloží ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Trasa dosáhla internetu: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Trasa dosáhla internetu: $answer (poslední uzel: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Port $port/$service: $state';
  }

  @override
  String get logPortOpen => 'otevřený ✅';

  @override
  String get logPortBlocked => 'blokovaný ❌';

  @override
  String logPopularCountry(String value) {
    return 'Země: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Dostupné populární weby: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Testováno přes: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Mobilní data byla měřena, protože jde o používané připojení (Wi-Fi není připojená, nebo jste zvolili opakovaný test přes mobilní síť)';

  @override
  String logCellularSignalReported(int level) {
    return 'Signál mobilní sítě: $level ze 4';
  }

  @override
  String get logCellularSignalMissing => 'Signál mobilní sítě: neuveden';

  @override
  String logDownloadLine(String value) {
    return 'Stahování: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Odesílání: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Přeneseno testem rychlosti: přijato $received, odesláno $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Doba odezvy ($label): žádná odpověď na $sent sond';
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
    return 'Doba odezvy ($label): $avg ms průměr (min $min, max $max), jitter $jitter ms, ztráta $loss% ($received/$sent odpovědí)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Doba odezvy při zátěži: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Doba odezvy při zátěži: $ms ms ($ratio× oproti klidu)';
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
    return 'Celková data spotřebovaná touto diagnostikou: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Tento součet zahrnuje všechny testy výše, nejen test rychlosti';

  @override
  String logTrafficSent(String size) {
    return 'odesláno $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'přijato $size';
  }
}
