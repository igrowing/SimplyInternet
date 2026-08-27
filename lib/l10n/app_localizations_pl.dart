// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get homeTitle =>
      'Internet nie działa?\nNiestabilny? Działa częściowo?';

  @override
  String get homeDiagnoseButton => 'Znajdź problem i zaproponuj rozwiązanie';

  @override
  String get homeUrlPrompt =>
      'Konkretna strona lub usługa nie działa?\nWklej tutaj jej link (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Sprawdź';

  @override
  String get homeSettingsTooltip => 'Ustawienia';

  @override
  String get homeRunningDiagnosis => 'Trwa pełne sprawdzanie…';

  @override
  String get homeRunningUrlCheck => 'Sprawdzanie strony…';

  @override
  String get homeCheckFailedTitle => 'Nie udało się ukończyć sprawdzania';

  @override
  String get homeUnknownError => 'Nieznany błąd';

  @override
  String get homeTryAgain => 'Spróbuj ponownie';

  @override
  String get commonBack => 'Wstecz';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsLanguageCaption =>
      'Cała aplikacja jest przetłumaczona, w tym wyniki diagnozy i ich szczegóły techniczne.';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsThemeSystem => 'Systemowy';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get settingsFontSize => 'Rozmiar czcionki';

  @override
  String get settingsFontSmall => 'Mały';

  @override
  String get settingsFontNormal => 'Normalny';

  @override
  String get settingsFontLarge => 'Duży';

  @override
  String get settingsCheckForUpdate => 'Sprawdź aktualizacje';

  @override
  String get settingsBuyMeACoffee => 'Postaw mi kawę';

  @override
  String get resultWhatToDo => 'Co robić';

  @override
  String get resultDialogNotNow => 'Nie teraz';

  @override
  String get resultDialogYes => 'Tak';

  @override
  String get resultNothingToOpen => 'Nie ma nic do otwarcia dla tego kroku.';

  @override
  String resultActionFailed(String error) {
    return 'Nie udało się wykonać tej czynności: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Co potrafi Twoje połączenie ($fits z $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Nie udało się zmierzyć wysyłania, więc nie zostało ocenione.';

  @override
  String get techDetailsTitle => 'Szczegóły techniczne';

  @override
  String get techDetailsCopy => 'Kopiuj';

  @override
  String get techDetailsCopied => 'Szczegóły techniczne skopiowane.';

  @override
  String get urlOpenInBrowser => 'Otwórz w przeglądarce';

  @override
  String get urlCheckAnother => 'Sprawdź inny';

  @override
  String get urlCouldNotOpenBrowser => 'Nie udało się otworzyć przeglądarki.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Nie udało się otworzyć: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Nie ma nic do ponownego przetestowania.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Nie udało się otworzyć ustawień: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Testuj przez dane mobilne';

  @override
  String get crossMediumTestOverWifi => 'Testuj przez Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Wyłącz Wi-Fi, a potem wróć — sprawdzenie uruchomi się ponownie samo.';

  @override
  String get crossMediumHintWifi =>
      'Włącz Wi-Fi, a potem wróć — sprawdzenie uruchomi się ponownie samo.';

  @override
  String get verdictFlightModeTitle => 'Masz włączony tryb samolotowy';

  @override
  String get verdictFlightModeDetail =>
      'Łączność bezprzewodowa jest wyłączona, więc dopóki tryb samolotowy jest włączony, nic nie dotrze do internetu.';

  @override
  String get solutionFlightModeMessage =>
      'Wyłącz tryb samolotowy i spróbuj ponownie.';

  @override
  String get verdictNotConnectedTitle => 'Brak połączenia z jakąkolwiek siecią';

  @override
  String get verdictNotConnectedDetail =>
      'Wygląda na to, że zarówno Wi-Fi, jak i dane komórkowe są wyłączone, więc nie ma jak dotrzeć do internetu.';

  @override
  String get solutionNotConnectedMessage =>
      'Włącz Wi-Fi lub dane komórkowe i spróbuj ponownie.';

  @override
  String get verdictRouterNotRespondingTitle => 'Router nie odpowiada';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Masz połączenie z siecią, ale $where nie odpowiada. Mógł się zawiesić lub stracić zasilanie.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'Twój router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'Twój router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Zrestartuj router: odłącz go od prądu, odczekaj 30 sekund, podłącz z powrotem i daj mu około 2–5 minut na uruchomienie. Następnie uruchom test ponownie.';

  @override
  String get verdictCaptivePortalTitle => 'Wymagane logowanie (captive portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'Sieć wymaga, byś zalogował się lub zaakceptował warunki na stronie internetowej, zanim wpuści Cię do sieci — częste w hotelach, kawiarniach i na lotniskach.';

  @override
  String get solutionCaptivePortalMessage =>
      'Otwórz stronę logowania i dokończ logowanie, następnie uruchom test ponownie.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Połączono z danymi komórkowymi, ale bez internetu';

  @override
  String get verdictNoInternetMobileDetail =>
      'Telefon łączy się z siecią na podstawowym poziomie, ale nie ma działającej drogi do internetu. Wskazuje to na problem w sieci operatora, a nie w telefonie.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Włącz i wyłącz tryb samolotowy albo zrestartuj telefon, aby połączyć się z nowym nadajnikiem.\n2. Jeśli test nadal nie przechodzi po 2–5 minutach, skontaktuj się z operatorem komórkowym — awaria jest po jego stronie.';

  @override
  String get verdictNoInternetIspTitle =>
      'Połączono z routerem, ale bez internetu';

  @override
  String get verdictNoInternetIspDetail =>
      'Router działa, ale nie ma działającego połączenia z Twoim dostawcą internetu (ISP). Problem jest poza Twoim domem.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Sprawdź, czy router jest podłączony do ściennego gniazdka telefonicznego/DSL.\n2. Sprawdź, czy kabel nie jest uszkodzony ani obluzowany.\n3. Jeśli masz telefon stacjonarny, podnieś słuchawkę i posłuchaj sygnału. Jeśli nie słyszysz sygnału, skontaktuj się z operatorem telefonicznym i/lub dostawcą internetu, aby naprawić linię.\n4. Zrestartuj router raz, aby przywrócić łącze z ISP. Jeśli test nadal nie przechodzi po 2–5 minutach, skontaktuj się z dostawcą internetu — awaria jest po jego stronie.';

  @override
  String get verdictMobileNoDataTitle =>
      'Dane komórkowe są połączone, ale nie działają';

  @override
  String get verdictMobileNoDataDetail =>
      'Telefon jest w sieci komórkowej, ale dane nie przechodzą. Zwykle oznacza to wyłączony roaming danych, wyczerpany pakiet danych lub lokalną awarię u operatora.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Jeśli jesteś za granicą lub w innej sieci, włącz roaming danych w ustawieniach sieci komórkowej.\n2. Sprawdź, czy w Twoim planie został jeszcze pakiet danych.\n3. $reception\n4. Jeśli nadal nie działa, skontaktuj się z operatorem komórkowym.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Wyłącz i włącz z powrotem dane komórkowe.',
      'weak':
          'Sygnał jest słaby: przejdź w miejsce z lepszym zasięgiem i wyłącz i włącz z powrotem dane komórkowe.',
      'other':
          'Przejdź w miejsce z lepszym sygnałem lub wyłącz i włącz z powrotem dane komórkowe.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problem z DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Internet jest osiągalny, ale nazwy stron nie są tłumaczone na adresy. To problem z DNS, zwykle łatwy do naprawienia przez przełączenie na publiczny resolver DNS.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Ustaw prywatny DNS na niezawodny publiczny resolver, np. 1.1.1.1 (Cloudflare) lub 8.8.8.8 (Google), i przetestuj ponownie.\n2. Jeśli nadal nie działa, wyłącz i włącz z powrotem dane komórkowe albo zrestartuj telefon, aby uzyskać świeże połączenie.\n3. Jeśli nadal nie działa, skontaktuj się z operatorem komórkowym — niektórzy operatorzy mają własne resolvery DNS, które miewają własne awarie.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Ustaw prywatny DNS na niezawodny publiczny resolver, np. 1.1.1.1 (Cloudflare) lub 8.8.8.8 (Google), i przetestuj ponownie.\n2. Jeśli jesteś w sieci zarządzanej (praca, szkoła, publiczne Wi-Fi), skontaktuj się z administratorem sieci, aby naprawić DNS.\n3. Jeśli jesteś we własnej sieci, sprawdź ustawienia routera. Dobrą praktyką jest ustawienie także wtórnego DNS na publiczny resolver (przykłady: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8) na wypadek awarii podstawowego (Twojego dostawcy internetu).';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Port $port jest zablokowany';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'Ogólny dostęp do internetu działa, ale ruch $service na porcie $port jest blokowany — prawdopodobnie przez zaporę w tej sieci. Niektóre aplikacje, które polegają na tym porcie, nie będą działać.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Twój operator komórkowy prawdopodobnie blokuje go zgodnie z zasadami — spróbuj zamiast tego Wi-Fi lub VPN, albo skontaktuj się z operatorem, jeśli potrzebujesz tego portu otwartego w sieci komórkowej.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Jeśli masz teraz połączenie z siecią zarządzaną (praca, szkoła, publiczne Wi-Fi), port $port jest zablokowany zgodnie z zasadami — spróbuj zamiast tego danych komórkowych lub VPN. We własnej sieci sprawdź reguły zapory w ustawieniach routera.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problem ze ścieżką sieciową u Twojego operatora';

  @override
  String get verdictIspPathIspTitle =>
      'Problem ze ścieżką sieciową u Twojego ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Twoje połączenie dociera do internetu, ale ruch zatrzymuje się po drodze, za $hop. Usterka jest u Twojego operatora komórkowego lub na trasie szkieletowej, a nie w telefonie.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Twoje połączenie dociera do internetu, ale ruch zatrzymuje się po drodze, za $hop. Usterka jest u Twojego dostawcy internetu lub na trasie szkieletowej, a nie w Twoim urządzeniu ani routerze.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'węzłem wewnątrz sieci Twojego operatora komórkowego';

  @override
  String get verdictIspPathHopGenericFixed =>
      'węzłem wewnątrz sieci Twojego dostawcy internetu';

  @override
  String get solutionIspPathMessageMobile =>
      'Nie ma nic do naprawienia w Twoim urządzeniu ani w Twojej sieci. Zgłoś wadliwą trasę swojemu operatorowi komórkowemu (wspomnij, że traceroute urywa się w połowie drogi). Zwykle znika, gdy naprawią trasę.';

  @override
  String get solutionIspPathMessageFixed =>
      'Nie ma nic do naprawienia w Twoim urządzeniu ani w Twojej sieci. Zgłoś wadliwą trasę swojemu dostawcy internetu (wspomnij, że traceroute urywa się w połowie drogi). Zwykle znika, gdy naprawią trasę.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Twój $medium nadaje się do $uses — i więcej';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Jeśli mimo to coś wydaje się nie tak, najprawdopodobniej chodzi o jedną aplikację lub stronę — nie o Twoje połączenie.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Twój $medium nadaje się do wszystkiego oprócz $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Twój $medium jest za słaby do $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Zmierzono przez $medium:\npobieranie $down Mb/s, wysyłanie $up Mb/s.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Zmierzono przez $medium:\npobieranie $down Mb/s.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Zmierzono przez $medium:\nwysyłanie $up Mb/s.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Zmierzono przez $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Test wysyłania nie mógł zostać wykonany, więc nie został oceniony.';

  @override
  String get verdictCauseGatewayWeak =>
      'Router odpowiada wolno lub gubi pakiety, co wskazuje na samo Wi-Fi, a nie na Twojego dostawcę.';

  @override
  String get verdictCauseSaturated =>
      'Połączenie mocno zwalnia, gdy jest obciążone. Ktoś lub coś innego w Twojej sieci (pobieranie, kopia zapasowa, telewizor) zajmuje łącze.';

  @override
  String get verdictCauseThroughput =>
      'Prędkość połączenia jest niewystarczająca. Albo Twój plan internetowy jest za wolny, albo dostawca ogranicza łącze.';

  @override
  String get verdictCauseGeneric =>
      'Czasy odpowiedzi i utrata pakietów wahają się zbyt mocno jak na najbardziej wymagające zastosowania w czasie rzeczywistym.';

  @override
  String get adviceMoveCloser =>
      'Podejdź bliżej routera albo spróbuj sieci 5 GHz, jeśli router ją oferuje.';

  @override
  String get advicePauseTheHog =>
      'Ustal, kto lub co mocno obciąża łącze, i poproś o wstrzymanie. W przeciwnym razie poczekaj albo zrestartuj Wi-Fi — to też przerwie ich połączenie.';

  @override
  String get adviceDropTheCamera =>
      'Wyłącz kamerę — Twoje połączenie nadal przeniesie dźwięk.';

  @override
  String get actionTestAgain => 'Testuj ponownie';

  @override
  String get actionTestAgainWifi => 'Testuj ponownie przez Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Testuj ponownie przez dane komórkowe';

  @override
  String get actionTurnOnWifi => 'Włącz Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi jest wyłączone. Otworzyć ustawienia, aby je włączyć?';

  @override
  String get actionTurnOnMobileData => 'Włącz dane komórkowe';

  @override
  String get confirmTurnOnMobileData =>
      'Dane komórkowe są wyłączone. Otworzyć ustawienia, aby je włączyć?';

  @override
  String get actionOpenFlightSettings => 'Otwórz ustawienia trybu samolotowego';

  @override
  String get confirmFlightMode =>
      'Masz włączony tryb samolotowy. Otworzyć ustawienia, aby go wyłączyć?';

  @override
  String get actionOpenSignInPage => 'Otwórz stronę logowania';

  @override
  String get confirmCaptivePortal =>
      'Blokuje Cię strona logowania. Otworzyć ją teraz?';

  @override
  String get actionOpenMobileDataSettings =>
      'Otwórz ustawienia danych komórkowych';

  @override
  String get confirmMobileDataSettings =>
      'Otworzyć ustawienia danych komórkowych, aby sprawdzić roaming i dane?';

  @override
  String get actionOpenPrivateDns => 'Otwórz ustawienia prywatnego DNS';

  @override
  String get confirmPrivateDns =>
      'Otworzyć ustawienia prywatnego DNS, aby przełączyć na 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'dane komórkowe',
      'ethernet': 'połączenie przewodowe',
      'vpn': 'połączenie VPN',
      'other': 'połączenie',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streaming muzyki',
      'voiceCalls': 'połączenia głosowe',
      'webBrowsing': 'przeglądanie sieci',
      'losslessMusic': 'muzyka bezstratna',
      'videoCalls720': 'rozmowy wideo (720p)',
      'teamGames': 'gry zespołowe',
      'videoCallsHd': 'rozmowy wideo (HD)',
      'hdVideo': 'wideo HD (1080p)',
      'fastGames': 'szybkie gry online',
      'video4k': 'wideo 4K',
      'other': 'ta czynność',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'cokolwiek wymagającego';

  @override
  String listTwo(String a, String b) {
    return '$a i $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head i $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'pobieranie $value Mb/s';
  }

  @override
  String shortfallUpload(String value) {
    return 'wysyłanie $value Mb/s';
  }

  @override
  String shortfallLatency(String value) {
    return 'opóźnienie $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'utrata pakietów $value%';
  }

  @override
  String get logHeadDeviceLink => 'Łącze urządzenia';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Osiągalność internetu';

  @override
  String get logHeadPorts => 'Porty';

  @override
  String get logHeadPopularSites => 'Popularne witryny';

  @override
  String get logHeadMeasurements => 'Pomiary';

  @override
  String get logHeadGoodFor => 'Wystarcza do';

  @override
  String get logHeadNotGoodFor => 'Niewystarczające do';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Wykonane testy ($count)';
  }

  @override
  String get logYes => 'tak';

  @override
  String get logNo => 'nie';

  @override
  String get logUnknown => 'nieznane';

  @override
  String get logNotApplicable => 'nd.';

  @override
  String get logNotMeasured => 'nie zmierzono';

  @override
  String get logNotReported => 'nie zgłoszono';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Łączność: $kind, tryb samolotowy: $flight';
  }

  @override
  String get logFlightOn => 'wł. ✈️';

  @override
  String get logFlightOff => 'wył. ✅';

  @override
  String logGateway(String value) {
    return 'Brama: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Brama osiągalna: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'osiągalny ✅';

  @override
  String get logInternetReachableNo => 'brak odpowiedzi ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Strona logowania captive: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Bezpośredni adres IP osiągalny: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Nazwa rozwiązuje się ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Trasa dotarła do internetu: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Trasa dotarła do internetu: $answer (ostatni węzeł: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Port $port/$service: $state';
  }

  @override
  String get logPortOpen => 'otwarty ✅';

  @override
  String get logPortBlocked => 'zablokowany ❌';

  @override
  String logPopularCountry(String value) {
    return 'Kraj: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Osiągalne popularne witryny: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Testowano przez: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Dane komórkowe zmierzono, ponieważ to używane łącze (Wi-Fi niepodłączone lub wybrano ponowny test przez sieć komórkową)';

  @override
  String logCellularSignalReported(int level) {
    return 'Sygnał komórkowy: $level z 4';
  }

  @override
  String get logCellularSignalMissing => 'Sygnał komórkowy: nie zgłoszono';

  @override
  String logDownloadLine(String value) {
    return 'Pobieranie: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Wysyłanie: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Przesłane przez test prędkości: odebrano $received, wysłano $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Czas odpowiedzi ($label): brak odpowiedzi na $sent sond';
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
    return 'Czas odpowiedzi ($label): $avg ms średnio (min $min, maks $max), jitter $jitter ms, utrata $loss% ($received/$sent odpowiedzi)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Czas odpowiedzi pod obciążeniem: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Czas odpowiedzi pod obciążeniem: $ms ms ($ratio× względem spoczynku)';
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
    return 'Łączne dane użyte przez tę diagnozę: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Ta suma obejmuje wszystkie testy powyżej, nie tylko test prędkości';

  @override
  String logTrafficSent(String size) {
    return 'wysłano $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'odebrano $size';
  }
}
