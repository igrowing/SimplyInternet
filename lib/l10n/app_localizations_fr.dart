// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get homeTitle =>
      'Internet ne fonctionne pas ?\nInstable ? Fonctionne partiellement ?';

  @override
  String get homeDiagnoseButton =>
      'Trouver le problème et proposer une solution';

  @override
  String get homeUrlPrompt =>
      'Un site web ou un service en particulier ne fonctionne pas ?\nCollez son lien (URL) ici :';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Vérifier';

  @override
  String get homeSettingsTooltip => 'Paramètres';

  @override
  String get homeRunningDiagnosis => 'Vérification complète en cours…';

  @override
  String get homeRunningUrlCheck => 'Vérification du site web…';

  @override
  String get homeCheckFailedTitle =>
      'La vérification n\'a pas pu être terminée';

  @override
  String get homeUnknownError => 'Erreur inconnue';

  @override
  String get homeTryAgain => 'Réessayer';

  @override
  String get commonBack => 'Retour';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageCaption =>
      'Toute l\'application est traduite, y compris les résultats du diagnostic et leurs détails techniques.';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsFontSize => 'Taille du texte';

  @override
  String get settingsFontSmall => 'Petit';

  @override
  String get settingsFontNormal => 'Normal';

  @override
  String get settingsFontLarge => 'Grand';

  @override
  String get settingsCheckForUpdate => 'Rechercher une mise à jour';

  @override
  String get settingsBuyMeACoffee => 'Offrez-moi un café';

  @override
  String get resultWhatToDo => 'Que faire';

  @override
  String get resultDialogNotNow => 'Pas maintenant';

  @override
  String get resultDialogYes => 'Oui';

  @override
  String get resultNothingToOpen => 'Il n\'y a rien à ouvrir pour cette étape.';

  @override
  String resultActionFailed(String error) {
    return 'Impossible d\'effectuer cette action : $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Ce que votre connexion permet de faire ($fits sur $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'L\'envoi n\'a pas pu être mesuré et n\'a donc pas été évalué.';

  @override
  String get techDetailsTitle => 'Détails techniques';

  @override
  String get techDetailsCopy => 'Copier';

  @override
  String get techDetailsCopied => 'Détails techniques copiés.';

  @override
  String get urlOpenInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get urlCheckAnother => 'Vérifier un autre';

  @override
  String get urlCouldNotOpenBrowser => 'Impossible d\'ouvrir le navigateur.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Impossible d\'ouvrir : $error';
  }

  @override
  String get urlNothingToTestAgain => 'Rien à retester.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Impossible d\'ouvrir les paramètres : $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Tester avec les données mobiles';

  @override
  String get crossMediumTestOverWifi => 'Tester avec le Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Désactivez le Wi-Fi puis revenez : la vérification reprendra automatiquement.';

  @override
  String get crossMediumHintWifi =>
      'Activez le Wi-Fi puis revenez : la vérification reprendra automatiquement.';

  @override
  String get verdictFlightModeTitle => 'Vous êtes en mode avion';

  @override
  String get verdictFlightModeDetail =>
      'Le sans-fil est désactivé, donc rien ne peut atteindre Internet tant que le mode avion est activé.';

  @override
  String get solutionFlightModeMessage =>
      'Désactivez le mode avion, puis réessayez.';

  @override
  String get verdictNotConnectedTitle => 'Connecté à aucun réseau';

  @override
  String get verdictNotConnectedDetail =>
      'Le Wi-Fi et les données mobiles semblent tous les deux désactivés, il n\'y a donc aucun moyen d\'atteindre Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Activez le Wi-Fi ou les données mobiles, puis réessayez.';

  @override
  String get verdictRouterNotRespondingTitle => 'Le routeur ne répond pas';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Vous êtes connecté au réseau, mais $where ne répond pas. Il a peut-être planté ou perdu son alimentation.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'votre routeur ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'votre routeur';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Redémarrez votre routeur : débranchez-le, attendez 30 secondes, rebranchez-le et laissez-lui environ 2 à 5 minutes pour démarrer. Relancez ensuite le test.';

  @override
  String get verdictCaptivePortalTitle => 'Connexion requise (portail captif)';

  @override
  String get verdictCaptivePortalDetail =>
      'Le réseau veut que vous vous connectiez ou acceptiez des conditions sur une page web avant de vous laisser accéder à Internet — courant dans les hôtels, cafés et aéroports.';

  @override
  String get solutionCaptivePortalMessage =>
      'Ouvrez la page de connexion et terminez l\'identification, puis relancez le test.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Connecté aux données mobiles, mais pas d\'Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'Votre téléphone atteint le réseau à un niveau de base, mais n\'a aucun chemin fonctionnel vers Internet. Cela indique un problème sur le réseau de votre opérateur, pas sur votre téléphone.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Activez puis désactivez le mode avion, ou redémarrez votre téléphone, pour vous reconnecter à une antenne fraîche.\n2. Si le test échoue toujours après 2 à 5 minutes, contactez votre opérateur mobile — la panne est de son côté.';

  @override
  String get verdictNoInternetIspTitle =>
      'Connecté au routeur, mais pas d\'Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'Votre routeur fonctionne, mais il n\'a aucune connexion fonctionnelle vers votre fournisseur d\'accès Internet (FAI). Le problème est en dehors de chez vous.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Vérifiez si votre routeur est branché à la prise téléphonique/DSL murale.\n2. Vérifiez que le câble n\'est ni endommagé ni desserré.\n3. Si vous avez un téléphone fixe, décrochez le combiné et écoutez la tonalité. Si vous n\'entendez aucune tonalité, contactez votre opérateur téléphonique et/ou votre fournisseur d\'accès pour faire réparer votre ligne.\n4. Redémarrez votre routeur une fois pour rétablir le lien avec le FAI. Si le test échoue toujours après 2 à 5 minutes, contactez votre fournisseur d\'accès — la panne est de son côté.';

  @override
  String get verdictMobileNoDataTitle =>
      'Les données mobiles sont connectées mais ne fonctionnent pas';

  @override
  String get verdictMobileNoDataDetail =>
      'Votre téléphone est sur le réseau mobile, mais aucune donnée ne passe. Cela signifie généralement que l\'itinérance des données est désactivée, que votre forfait de données est épuisé, ou que votre opérateur a une panne locale.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Si vous êtes à l\'étranger ou sur un autre réseau, activez l\'itinérance des données dans les paramètres mobiles.\n2. Vérifiez qu\'il vous reste des données sur votre forfait.\n3. $reception\n4. Si cela échoue toujours, contactez votre opérateur mobile.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Désactivez puis réactivez les données mobiles.',
      'weak':
          'Votre signal est faible : placez-vous à un endroit avec une meilleure réception et désactivez puis réactivez les données mobiles.',
      'other':
          'Placez-vous à un endroit avec un meilleur signal, ou désactivez puis réactivez les données mobiles.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problème de DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Internet est joignable, mais les noms de sites web ne sont pas traduits en adresses. C\'est un problème de DNS, généralement facile à résoudre en passant à un résolveur DNS public.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Réglez votre DNS privé sur un résolveur public fiable comme 1.1.1.1 (Cloudflare) ou 8.8.8.8 (Google), puis retestez.\n2. Si cela échoue toujours, désactivez puis réactivez les données mobiles, ou redémarrez votre téléphone, pour obtenir une connexion fraîche.\n3. Si cela échoue toujours, contactez votre opérateur mobile — certains opérateurs exploitent leurs propres résolveurs DNS qui subissent leurs propres pannes.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Réglez votre DNS privé sur un résolveur public fiable comme 1.1.1.1 (Cloudflare) ou 8.8.8.8 (Google), puis retestez.\n2. Si vous êtes sur un réseau géré (travail, école, Wi-Fi public), contactez l\'administrateur du réseau pour corriger le DNS.\n3. Si vous êtes sur votre propre réseau, vérifiez les paramètres de votre routeur. Il est recommandé de configurer aussi le DNS secondaire sur un résolveur public (exemples : 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), au cas où le principal (votre fournisseur d\'accès) tomberait en panne.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Le port $port est bloqué';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'L\'accès général à Internet fonctionne, mais le trafic $service sur le port $port est bloqué — probablement par un pare-feu sur ce réseau. Certaines applications qui dépendent de ce port ne fonctionneront pas.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Votre opérateur mobile le bloque probablement par règle — essayez plutôt le Wi-Fi ou un VPN, ou contactez votre opérateur si vous avez besoin de ce port ouvert sur le réseau mobile.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Si vous êtes actuellement connecté à un réseau géré (travail, école, Wi-Fi public), le port $port est bloqué par règle — essayez plutôt les données mobiles ou un VPN. Sur votre propre réseau, vérifiez les règles du pare-feu dans les paramètres de votre routeur.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problème de chemin réseau chez votre opérateur';

  @override
  String get verdictIspPathIspTitle =>
      'Problème de chemin réseau chez votre FAI';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Votre connexion atteint Internet, mais le trafic s\'arrête en chemin, après $hop. La panne est chez votre opérateur mobile ou sur la route du réseau principal, pas sur votre téléphone.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Votre connexion atteint Internet, mais le trafic s\'arrête en chemin, après $hop. La panne est chez votre fournisseur d\'accès ou sur la route du réseau principal, pas sur votre appareil ni votre routeur.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'un saut à l\'intérieur de votre opérateur mobile';

  @override
  String get verdictIspPathHopGenericFixed =>
      'un saut à l\'intérieur de votre fournisseur d\'accès';

  @override
  String get solutionIspPathMessageMobile =>
      'Il n\'y a rien à réparer sur votre appareil ni dans votre réseau. Signalez la route défaillante à votre opérateur mobile (précisez que le traceroute s\'arrête en cours de route). Cela se résout généralement une fois qu\'ils corrigent la route.';

  @override
  String get solutionIspPathMessageFixed =>
      'Il n\'y a rien à réparer sur votre appareil ni dans votre réseau. Signalez la route défaillante à votre fournisseur d\'accès (précisez que le traceroute s\'arrête en cours de route). Cela se résout généralement une fois qu\'ils corrigent la route.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Votre $medium convient pour $uses — et plus encore';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Si quelque chose semble malgré tout ne pas aller, c\'est très probablement une application ou un site web en particulier — pas votre connexion.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Votre $medium convient pour tout sauf pour $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Votre $medium est trop faible pour $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Mesuré sur $medium :\ntéléchargement $down Mbps, envoi $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Mesuré sur $medium :\ntéléchargement $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Mesuré sur $medium :\nenvoi $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Mesuré sur $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Le test d\'envoi n\'a pas pu s\'exécuter, il n\'a donc pas été évalué.';

  @override
  String get verdictCauseGatewayWeak =>
      'Votre routeur répond lentement ou perd des paquets, ce qui pointe vers le Wi-Fi lui-même plutôt que vers votre fournisseur.';

  @override
  String get verdictCauseSaturated =>
      'La connexion ralentit fortement pendant qu\'elle est occupée. Quelqu\'un ou quelque chose d\'autre sur votre réseau (un téléchargement, une sauvegarde, une télé) utilise la ligne.';

  @override
  String get verdictCauseThroughput =>
      'La vitesse de la connexion est insuffisante. Soit votre offre Internet est trop lente, soit votre fournisseur bride la ligne.';

  @override
  String get verdictCauseGeneric =>
      'Les temps de réponse et la perte de paquets varient trop pour les activités en temps réel les plus exigeantes.';

  @override
  String get adviceMoveCloser =>
      'Rapprochez-vous du routeur, ou essayez le réseau 5 GHz si votre routeur en propose un.';

  @override
  String get advicePauseTheHog =>
      'Trouvez qui ou quoi utilise fortement la ligne et demandez de mettre en pause. Sinon, attendez, ou redémarrez votre Wi-Fi — cela coupe aussi leur connexion.';

  @override
  String get adviceDropTheCamera =>
      'Coupez votre caméra — votre connexion peut encore transporter l\'audio.';

  @override
  String get actionTestAgain => 'Retester';

  @override
  String get actionTestAgainWifi => 'Retester en Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Retester en données mobiles';

  @override
  String get actionTurnOnWifi => 'Activer le Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Le Wi-Fi est désactivé. Ouvrir les paramètres pour l\'activer ?';

  @override
  String get actionTurnOnMobileData => 'Activer les données mobiles';

  @override
  String get confirmTurnOnMobileData =>
      'Les données mobiles sont désactivées. Ouvrir les paramètres pour les activer ?';

  @override
  String get actionOpenFlightSettings => 'Ouvrir les paramètres du mode avion';

  @override
  String get confirmFlightMode =>
      'Vous êtes en mode avion. Ouvrir les paramètres pour le désactiver ?';

  @override
  String get actionOpenSignInPage => 'Ouvrir la page de connexion';

  @override
  String get confirmCaptivePortal =>
      'Une page de connexion vous bloque. L\'ouvrir maintenant ?';

  @override
  String get actionOpenMobileDataSettings =>
      'Ouvrir les paramètres des données mobiles';

  @override
  String get confirmMobileDataSettings =>
      'Ouvrir les paramètres des données mobiles pour vérifier l\'itinérance et les données ?';

  @override
  String get actionOpenPrivateDns => 'Ouvrir les paramètres du DNS privé';

  @override
  String get confirmPrivateDns =>
      'Ouvrir les paramètres du DNS privé pour passer à 1.1.1.1 ?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'données mobiles',
      'ethernet': 'connexion filaire',
      'vpn': 'connexion VPN',
      'other': 'connexion',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streaming musical',
      'voiceCalls': 'appels vocaux',
      'webBrowsing': 'navigation web',
      'losslessMusic': 'musique sans perte',
      'videoCalls720': 'appels vidéo (720p)',
      'teamGames': 'jeux en équipe',
      'videoCallsHd': 'appels vidéo (HD)',
      'hdVideo': 'vidéo HD (1080p)',
      'fastGames': 'jeux en ligne rapides',
      'video4k': 'vidéo 4K',
      'other': 'cette activité',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'toute activité exigeante';

  @override
  String listTwo(String a, String b) {
    return '$a et $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head et $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'téléchargement $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'envoi $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'latence $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'gigue $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'perte de paquets $value%';
  }

  @override
  String get logHeadDeviceLink => 'Lien de l\'appareil';

  @override
  String get logHeadRouter => 'Routeur';

  @override
  String get logHeadInternetReachability => 'Accessibilité d\'Internet';

  @override
  String get logHeadPorts => 'Ports';

  @override
  String get logHeadPopularSites => 'Sites populaires';

  @override
  String get logHeadMeasurements => 'Mesures';

  @override
  String get logHeadGoodFor => 'Convient pour';

  @override
  String get logHeadNotGoodFor => 'Pas suffisant pour';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Tests effectués ($count)';
  }

  @override
  String get logYes => 'oui';

  @override
  String get logNo => 'non';

  @override
  String get logUnknown => 'inconnu';

  @override
  String get logNotApplicable => 's. o.';

  @override
  String get logNotMeasured => 'non mesuré';

  @override
  String get logNotReported => 'non communiqué';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Connectivité : $kind, mode avion : $flight';
  }

  @override
  String get logFlightOn => 'activé ✈️';

  @override
  String get logFlightOff => 'désactivé ✅';

  @override
  String logGateway(String value) {
    return 'Passerelle : $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Passerelle joignable : $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet : $state';
  }

  @override
  String get logInternetReachableYes => 'joignable ✅';

  @override
  String get logInternetReachableNo => 'aucune réponse ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Page de connexion captive : $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Adresse IP directe joignable : $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Le nom se résout ($host) : $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'La route a atteint Internet : $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'La route a atteint Internet : $answer (dernier saut : $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Port $port/$service : $state';
  }

  @override
  String get logPortOpen => 'ouvert ✅';

  @override
  String get logPortBlocked => 'bloqué ❌';

  @override
  String logPopularCountry(String value) {
    return 'Pays : $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Sites populaires joignables : $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Testé sur : $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Les données mobiles ont été mesurées car c\'est le lien utilisé (Wi-Fi non connecté, ou vous avez choisi de retester sur le réseau mobile)';

  @override
  String logCellularSignalReported(int level) {
    return 'Signal mobile : $level sur 4';
  }

  @override
  String get logCellularSignalMissing => 'Signal mobile : non communiqué';

  @override
  String logDownloadLine(String value) {
    return 'Téléchargement : $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Envoi : $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Déplacé par le test de débit : reçu $received, envoyé $sent';
  }

  @override
  String get logLabelRouter => 'Routeur';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Temps de réponse $label : aucune réponse à $sent sondes';
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
    return 'Temps de réponse $label : $avg ms en moyenne (min $min, max $max), gigue $jitter ms, perte $loss% ($received/$sent réponses)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Temps de réponse en charge : $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Temps de réponse en charge : $ms ms ($ratio× au repos)';
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
    return 'Données totales utilisées par ce diagnostic : $traffic';
  }

  @override
  String get logTotalCovers =>
      'Ce total couvre tous les tests ci-dessus, pas seulement le test de débit';

  @override
  String logTrafficSent(String size) {
    return 'envoyé $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'reçu $size';
  }
}
