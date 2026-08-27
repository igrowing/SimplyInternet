// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get homeTitle =>
      'Internet non funziona?\nInstabile? Funziona parzialmente?';

  @override
  String get homeDiagnoseButton => 'Trova il problema e proponi una soluzione';

  @override
  String get homeUrlPrompt =>
      'Un sito web o un servizio specifico non funziona?\nIncolla qui il suo link (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Verifica';

  @override
  String get homeSettingsTooltip => 'Impostazioni';

  @override
  String get homeRunningDiagnosis => 'Controllo completo in corso…';

  @override
  String get homeRunningUrlCheck => 'Verifica del sito web in corso…';

  @override
  String get homeCheckFailedTitle => 'Il controllo non è stato completato';

  @override
  String get homeUnknownError => 'Errore sconosciuto';

  @override
  String get homeTryAgain => 'Riprova';

  @override
  String get commonBack => 'Indietro';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageCaption =>
      'L\'intera app è tradotta, compresi i risultati della diagnosi e i loro dettagli tecnici.';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsFontSize => 'Dimensione del testo';

  @override
  String get settingsFontSmall => 'Piccolo';

  @override
  String get settingsFontNormal => 'Normale';

  @override
  String get settingsFontLarge => 'Grande';

  @override
  String get settingsCheckForUpdate => 'Controlla aggiornamenti';

  @override
  String get settingsBuyMeACoffee => 'Offrimi un caffè';

  @override
  String get resultWhatToDo => 'Cosa fare';

  @override
  String get resultDialogNotNow => 'Non ora';

  @override
  String get resultDialogYes => 'Sì';

  @override
  String get resultNothingToOpen =>
      'Non c\'è nulla da aprire per questo passaggio.';

  @override
  String resultActionFailed(String error) {
    return 'Impossibile completare l\'operazione: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Cosa può fare la tua connessione ($fits su $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Non è stato possibile misurare l\'upload, quindi non è stato valutato.';

  @override
  String get techDetailsTitle => 'Dettagli tecnici';

  @override
  String get techDetailsCopy => 'Copia';

  @override
  String get techDetailsCopied => 'Dettagli tecnici copiati.';

  @override
  String get urlOpenInBrowser => 'Apri nel browser';

  @override
  String get urlCheckAnother => 'Verifica un altro';

  @override
  String get urlCouldNotOpenBrowser => 'Impossibile aprire il browser.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Impossibile aprire: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Nulla da testare di nuovo.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Impossibile aprire le impostazioni: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Prova con i dati mobili';

  @override
  String get crossMediumTestOverWifi => 'Prova con il Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Disattiva il Wi-Fi e poi torna qui: il controllo verrà eseguito di nuovo automaticamente.';

  @override
  String get crossMediumHintWifi =>
      'Attiva il Wi-Fi e poi torna qui: il controllo verrà eseguito di nuovo automaticamente.';

  @override
  String get verdictFlightModeTitle => 'Sei in modalità aereo';

  @override
  String get verdictFlightModeDetail =>
      'La connessione wireless è disattivata, quindi nulla può raggiungere Internet finché la modalità aereo è attiva.';

  @override
  String get solutionFlightModeMessage =>
      'Disattiva la modalità aereo, poi riprova.';

  @override
  String get verdictNotConnectedTitle => 'Non connesso a nessuna rete';

  @override
  String get verdictNotConnectedDetail =>
      'Sia il Wi-Fi sia i dati mobili sembrano disattivati, quindi non c\'è modo di raggiungere Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Attiva il Wi-Fi o i dati mobili, poi riprova.';

  @override
  String get verdictRouterNotRespondingTitle => 'Il router non risponde';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Sei connesso alla rete, ma $where non risponde. Potrebbe essersi bloccato o aver perso l\'alimentazione.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'il tuo router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'il tuo router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Riavvia il router: staccalo dalla corrente, aspetta 30 secondi, riattaccalo e dagli circa 2-5 minuti per avviarsi. Poi esegui di nuovo il test.';

  @override
  String get verdictCaptivePortalTitle => 'Accesso richiesto (captive portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'La rete vuole che tu acceda o accetti dei termini su una pagina web prima di lasciarti navigare — comune in hotel, bar e aeroporti.';

  @override
  String get solutionCaptivePortalMessage =>
      'Apri la pagina di accesso e completa il login, poi esegui di nuovo il test.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Connesso ai dati mobili, ma senza Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'Il telefono raggiunge la rete a un livello di base, ma non ha un percorso funzionante verso Internet. Questo indica un problema sulla rete del tuo operatore, non sul telefono.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Attiva e disattiva la modalità aereo, oppure riavvia il telefono, per riconnetterti a una cella nuova.\n2. Se il test continua a fallire dopo 2-5 minuti, contatta il tuo operatore mobile: il guasto è dalla loro parte.';

  @override
  String get verdictNoInternetIspTitle =>
      'Connesso al router, ma senza Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'Il router funziona, ma non ha una connessione funzionante verso il tuo fornitore di Internet (ISP). Il problema è fuori casa tua.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Controlla se il router è collegato alla presa telefonica/DSL a muro.\n2. Controlla che il cavo non sia danneggiato o allentato.\n3. Se hai un telefono fisso, solleva la cornetta e ascolta il segnale di libero. Se non senti alcun segnale, contatta la compagnia telefonica e/o il fornitore di Internet per far riparare la linea.\n4. Riavvia il router una volta per ristabilire il collegamento con l\'ISP. Se il test continua a fallire dopo 2-5 minuti, contatta il tuo fornitore di Internet: il guasto è dalla loro parte.';

  @override
  String get verdictMobileNoDataTitle =>
      'I dati mobili sono connessi ma non funzionano';

  @override
  String get verdictMobileNoDataDetail =>
      'Il telefono è sulla rete cellulare, ma non passano dati. Di solito significa che il roaming dati è disattivato, che hai esaurito il traffico dati o che il tuo operatore ha un guasto locale.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Se sei all\'estero o su un\'altra rete, attiva il roaming dati nelle impostazioni della rete mobile.\n2. Controlla di avere ancora traffico dati disponibile nel tuo piano.\n3. $reception\n4. Se continua a fallire, contatta il tuo operatore mobile.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Disattiva e riattiva i dati mobili.',
      'weak':
          'Il segnale è debole: spostati in un punto con ricezione migliore e disattiva e riattiva i dati mobili.',
      'other':
          'Spostati in un punto con segnale migliore, oppure disattiva e riattiva i dati mobili.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problema di DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Internet è raggiungibile, ma i nomi dei siti web non vengono tradotti in indirizzi. È un problema di DNS, di solito facile da risolvere passando a un resolver DNS pubblico.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Imposta il tuo DNS privato su un resolver pubblico affidabile come 1.1.1.1 (Cloudflare) o 8.8.8.8 (Google), poi riprova.\n2. Se continua a fallire, disattiva e riattiva i dati mobili, oppure riavvia il telefono, per ottenere una connessione nuova.\n3. Se continua a fallire, contatta il tuo operatore mobile: alcuni operatori gestiscono resolver DNS propri che hanno guasti a loro volta.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Imposta il tuo DNS privato su un resolver pubblico affidabile come 1.1.1.1 (Cloudflare) o 8.8.8.8 (Google), poi riprova.\n2. Se sei su una rete gestita (lavoro, scuola, Wi-Fi pubblico), contatta l\'amministratore di rete per correggere il DNS.\n3. Se sei sulla tua rete, controlla le impostazioni del router. È buona norma configurare anche il DNS secondario su un resolver pubblico (esempi: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), nel caso il primario (il tuo fornitore di Internet) si guasti.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'La porta $port è bloccata';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'L\'accesso generale a Internet funziona, ma il traffico $service sulla porta $port è bloccato — probabilmente da un firewall su questa rete. Alcune app che si basano su questa porta non funzioneranno.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Il tuo operatore mobile probabilmente la blocca per policy — prova invece il Wi-Fi o una VPN, oppure contatta l\'operatore se ti serve questa porta aperta sulla rete mobile.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Se ora sei connesso a una rete gestita (lavoro, scuola, Wi-Fi pubblico), la porta $port è bloccata per policy — prova invece i dati mobili o una VPN. Sulla tua rete, controlla le regole del firewall nelle impostazioni del router.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problema di percorso di rete presso il tuo operatore';

  @override
  String get verdictIspPathIspTitle =>
      'Problema di percorso di rete presso il tuo ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'La connessione raggiunge Internet ma il traffico si ferma lungo il percorso, dopo $hop. Il guasto è presso il tuo operatore mobile o sulla rotta di dorsale, non sul telefono.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'La connessione raggiunge Internet ma il traffico si ferma lungo il percorso, dopo $hop. Il guasto è presso il tuo fornitore di Internet o sulla rotta di dorsale, non sul dispositivo né sul router.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'un hop all\'interno del tuo operatore mobile';

  @override
  String get verdictIspPathHopGenericFixed =>
      'un hop all\'interno del tuo fornitore di Internet';

  @override
  String get solutionIspPathMessageMobile =>
      'Non c\'è nulla da riparare sul dispositivo o nella tua rete. Segnala la rotta difettosa al tuo operatore mobile (indica che il traceroute si interrompe a metà strada). Di solito si risolve quando correggono la rotta.';

  @override
  String get solutionIspPathMessageFixed =>
      'Non c\'è nulla da riparare sul dispositivo o nella tua rete. Segnala la rotta difettosa al tuo fornitore di Internet (indica che il traceroute si interrompe a metà strada). Di solito si risolve quando correggono la rotta.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Il tuo $medium va bene per $uses — e altro ancora';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Se qualcosa sembra comunque non funzionare, è molto probabile che sia una singola app o un sito web — non la tua connessione.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Il tuo $medium va bene per tutto tranne che per $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Il tuo $medium è troppo debole per $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Misurato su $medium:\ndownload $down Mbps, upload $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Misurato su $medium:\ndownload $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Misurato su $medium:\nupload $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Misurato su $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Il test di upload non è stato eseguito, quindi non è stato valutato.';

  @override
  String get verdictCauseGatewayWeak =>
      'Il router risponde lentamente o perde pacchetti, il che indica il Wi-Fi stesso piuttosto che il tuo fornitore.';

  @override
  String get verdictCauseSaturated =>
      'La connessione rallenta bruscamente mentre è occupata. Qualcuno o qualcos\'altro sulla tua rete (un download, un backup, una TV) sta usando la linea.';

  @override
  String get verdictCauseThroughput =>
      'La velocità della connessione non è sufficiente. O il tuo piano Internet è troppo lento o il tuo fornitore sta limitando la linea.';

  @override
  String get verdictCauseGeneric =>
      'I tempi di risposta e la perdita di pacchetti variano troppo per le attività in tempo reale più esigenti.';

  @override
  String get adviceMoveCloser =>
      'Avvicinati al router, oppure prova la rete a 5 GHz se il tuo router ne offre una.';

  @override
  String get advicePauseTheHog =>
      'Scopri chi o cosa sta usando molto la linea e chiedi di mettere in pausa. Altrimenti aspetta, o riavvia il Wi-Fi — questo interrompe anche la loro connessione.';

  @override
  String get adviceDropTheCamera =>
      'Spegni la videocamera — la connessione può comunque trasmettere l\'audio.';

  @override
  String get actionTestAgain => 'Riprova il test';

  @override
  String get actionTestAgainWifi => 'Riprova il test in Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Riprova il test in dati mobili';

  @override
  String get actionTurnOnWifi => 'Attiva il Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Il Wi-Fi è disattivato. Aprire le impostazioni per attivarlo?';

  @override
  String get actionTurnOnMobileData => 'Attiva i dati mobili';

  @override
  String get confirmTurnOnMobileData =>
      'I dati mobili sono disattivati. Aprire le impostazioni per attivarli?';

  @override
  String get actionOpenFlightSettings =>
      'Apri le impostazioni della modalità aereo';

  @override
  String get confirmFlightMode =>
      'Sei in modalità aereo. Aprire le impostazioni per disattivarla?';

  @override
  String get actionOpenSignInPage => 'Apri la pagina di accesso';

  @override
  String get confirmCaptivePortal =>
      'Sei bloccato da una pagina di accesso. Aprirla ora?';

  @override
  String get actionOpenMobileDataSettings =>
      'Apri le impostazioni dei dati mobili';

  @override
  String get confirmMobileDataSettings =>
      'Aprire le impostazioni dei dati mobili per controllare roaming e traffico dati?';

  @override
  String get actionOpenPrivateDns => 'Apri le impostazioni del DNS privato';

  @override
  String get confirmPrivateDns =>
      'Aprire le impostazioni del DNS privato per passare a 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'dati mobili',
      'ethernet': 'connessione cablata',
      'vpn': 'connessione VPN',
      'other': 'connessione',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streaming musicale',
      'voiceCalls': 'chiamate vocali',
      'webBrowsing': 'navigazione web',
      'losslessMusic': 'musica lossless',
      'videoCalls720': 'videochiamate (720p)',
      'teamGames': 'giochi di squadra',
      'videoCallsHd': 'videochiamate (HD)',
      'hdVideo': 'video HD (1080p)',
      'fastGames': 'giochi online veloci',
      'video4k': 'video 4K',
      'other': 'questa attività',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'qualsiasi cosa impegnativa';

  @override
  String listTwo(String a, String b) {
    return '$a e $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head e $last';
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
    return 'latenza $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'perdita di pacchetti $value%';
  }

  @override
  String get logHeadDeviceLink => 'Collegamento del dispositivo';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Raggiungibilità di Internet';

  @override
  String get logHeadPorts => 'Porte';

  @override
  String get logHeadPopularSites => 'Siti popolari';

  @override
  String get logHeadMeasurements => 'Misurazioni';

  @override
  String get logHeadGoodFor => 'Va bene per';

  @override
  String get logHeadNotGoodFor => 'Non sufficiente per';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Test eseguiti ($count)';
  }

  @override
  String get logYes => 'sì';

  @override
  String get logNo => 'no';

  @override
  String get logUnknown => 'sconosciuto';

  @override
  String get logNotApplicable => 'n/d';

  @override
  String get logNotMeasured => 'non misurato';

  @override
  String get logNotReported => 'non riportato';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Connettività: $kind, modalità aereo: $flight';
  }

  @override
  String get logFlightOn => 'attiva ✈️';

  @override
  String get logFlightOff => 'disattiva ✅';

  @override
  String logGateway(String value) {
    return 'Gateway: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Gateway raggiungibile: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'raggiungibile ✅';

  @override
  String get logInternetReachableNo => 'nessuna risposta ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Pagina di accesso captive: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Indirizzo IP diretto raggiungibile: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Il nome si risolve ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'La rotta ha raggiunto Internet: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'La rotta ha raggiunto Internet: $answer (ultimo hop: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Porta $port/$service: $state';
  }

  @override
  String get logPortOpen => 'aperta ✅';

  @override
  String get logPortBlocked => 'bloccata ❌';

  @override
  String logPopularCountry(String value) {
    return 'Paese: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Siti popolari raggiungibili: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Testato su: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'I dati mobili sono stati misurati perché sono il collegamento in uso (Wi-Fi non connesso, o hai scelto di ripetere il test sulla rete mobile)';

  @override
  String logCellularSignalReported(int level) {
    return 'Segnale cellulare: $level su 4';
  }

  @override
  String get logCellularSignalMissing => 'Segnale cellulare: non riportato';

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
    return 'Spostato dal test di velocità: ricevuti $received, inviati $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Tempo di risposta $label: nessuna risposta a $sent sonde';
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
    return 'Tempo di risposta $label: $avg ms in media (min $min, max $max), jitter $jitter ms, perdita $loss% ($received/$sent risposte)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Tempo di risposta sotto carico: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Tempo di risposta sotto carico: $ms ms ($ratio× a riposo)';
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
    return 'Dati totali usati da questa diagnosi: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Quel totale copre ogni test qui sopra, non solo il test di velocità';

  @override
  String logTrafficSent(String size) {
    return 'inviati $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'ricevuti $size';
  }
}
