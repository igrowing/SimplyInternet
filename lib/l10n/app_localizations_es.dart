// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeTitle =>
      '¿No funciona Internet?\n¿Inestable? ¿Funciona parcialmente?';

  @override
  String get homeDiagnoseButton => 'Buscar el problema y ofrecer una solución';

  @override
  String get homeUrlPrompt =>
      '¿Un sitio web o servicio concreto no funciona?\nPega aquí su enlace (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Comprobar';

  @override
  String get homeSettingsTooltip => 'Ajustes';

  @override
  String get homeRunningDiagnosis => 'Realizando comprobación completa…';

  @override
  String get homeRunningUrlCheck => 'Comprobando el sitio web…';

  @override
  String get homeCheckFailedTitle => 'La comprobación no se pudo completar';

  @override
  String get homeUnknownError => 'Error desconocido';

  @override
  String get homeTryAgain => 'Intentar de nuevo';

  @override
  String get commonBack => 'Atrás';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageCaption =>
      'Toda la aplicación está traducida, incluidos los resultados del diagnóstico y sus detalles técnicos.';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsFontSize => 'Tamaño de letra';

  @override
  String get settingsFontSmall => 'Pequeño';

  @override
  String get settingsFontNormal => 'Normal';

  @override
  String get settingsFontLarge => 'Grande';

  @override
  String get settingsCheckForUpdate => 'Buscar actualizaciones';

  @override
  String get settingsBuyMeACoffee => 'Invítame a un café';

  @override
  String get resultWhatToDo => 'Qué hacer';

  @override
  String get resultDialogNotNow => 'Ahora no';

  @override
  String get resultDialogYes => 'Sí';

  @override
  String get resultNothingToOpen => 'No hay nada que abrir para este paso.';

  @override
  String resultActionFailed(String error) {
    return 'No se pudo completar esa acción: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Lo que su conexión puede hacer ($fits de $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'No se pudo medir la subida, por lo que no se evaluó.';

  @override
  String get techDetailsTitle => 'Detalles técnicos';

  @override
  String get techDetailsCopy => 'Copiar';

  @override
  String get techDetailsCopied => 'Detalles técnicos copiados.';

  @override
  String get urlOpenInBrowser => 'Abrir en el navegador';

  @override
  String get urlCheckAnother => 'Comprobar otro';

  @override
  String get urlCouldNotOpenBrowser => 'No se pudo abrir el navegador.';

  @override
  String urlCouldNotOpen(String error) {
    return 'No se pudo abrir: $error';
  }

  @override
  String get urlNothingToTestAgain => 'No hay nada que volver a comprobar.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'No se pudo abrir la configuración: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Probar con datos móviles';

  @override
  String get crossMediumTestOverWifi => 'Probar con Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Desactiva el Wi-Fi y vuelve: la comprobación se repetirá automáticamente.';

  @override
  String get crossMediumHintWifi =>
      'Activa el Wi-Fi y vuelve: la comprobación se repetirá automáticamente.';

  @override
  String get verdictFlightModeTitle => 'Estás en modo avión';

  @override
  String get verdictFlightModeDetail =>
      'La conexión inalámbrica está desactivada, así que nada puede llegar a Internet mientras el modo avión está activado.';

  @override
  String get solutionFlightModeMessage =>
      'Desactiva el modo avión y vuelve a intentarlo.';

  @override
  String get verdictNotConnectedTitle => 'Sin conexión a ninguna red';

  @override
  String get verdictNotConnectedDetail =>
      'Parece que tanto el Wi-Fi como los datos móviles están desactivados, así que no hay forma de llegar a Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Activa el Wi-Fi o los datos móviles y vuelve a intentarlo.';

  @override
  String get verdictRouterNotRespondingTitle => 'El router no responde';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Estás conectado a la red, pero $where no responde. Puede que se haya bloqueado o que se haya quedado sin corriente.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'tu router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'tu router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Reinicia el router: desenchúfalo, espera 30 segundos, vuelve a enchufarlo y deja que tarde entre 2 y 5 minutos en arrancar. Luego repite la prueba.';

  @override
  String get verdictCaptivePortalTitle =>
      'Se requiere iniciar sesión (portal cautivo)';

  @override
  String get verdictCaptivePortalDetail =>
      'La red quiere que inicies sesión o aceptes unas condiciones en una página web antes de dejarte navegar; es habitual en hoteles, cafeterías y aeropuertos.';

  @override
  String get solutionCaptivePortalMessage =>
      'Abre la página de inicio de sesión y completa el acceso, luego repite la prueba.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Conectado a los datos móviles, pero sin Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'Tu teléfono llega a la red a un nivel básico, pero no tiene una ruta que funcione hacia Internet. Esto apunta a un problema en la red de tu operador, no en tu teléfono.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Activa y desactiva el modo avión, o reinicia el teléfono, para reconectar con una antena nueva.\n2. Si la prueba sigue fallando después de 2 a 5 minutos, contacta con tu operador móvil: la avería está de su lado.';

  @override
  String get verdictNoInternetIspTitle =>
      'Conectado al router, pero sin Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'Tu router funciona, pero no tiene una conexión que funcione con tu proveedor de Internet (ISP). El problema está fuera de tu casa.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Comprueba si tu router está conectado a la roseta de teléfono/DSL de la pared.\n2. Comprueba que el cable no esté dañado ni suelto.\n3. Si tienes un teléfono fijo, descuelga el auricular y escucha el tono de marcado. Si no oyes tono, contacta con tu compañía telefónica o tu proveedor de Internet para que reparen tu línea.\n4. Reinicia el router una vez para restablecer el enlace con el ISP. Si la prueba sigue fallando después de 2 a 5 minutos, contacta con tu proveedor de Internet: la avería está de su lado.';

  @override
  String get verdictMobileNoDataTitle =>
      'Los datos móviles están conectados pero no funcionan';

  @override
  String get verdictMobileNoDataDetail =>
      'Tu teléfono está en la red móvil, pero no pasan datos. Normalmente significa que la itinerancia de datos está desactivada, que has agotado tu volumen de datos o que tu operador tiene una avería local.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Si estás en el extranjero o en otra red, activa la itinerancia de datos en los ajustes de datos móviles.\n2. Comprueba que aún te queda volumen de datos en tu plan.\n3. $reception\n4. Si sigue fallando, contacta con tu operador móvil.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Desactiva y vuelve a activar los datos móviles.',
      'weak':
          'Tu señal es débil: ve a un sitio con mejor cobertura y desactiva y vuelve a activar los datos móviles.',
      'other':
          'Ve a un sitio con mejor señal, o desactiva y vuelve a activar los datos móviles.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problema de DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Internet es accesible, pero los nombres de los sitios web no se están traduciendo a direcciones. Es un problema de DNS y suele ser fácil de resolver cambiando a un resolvedor DNS público.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Cambia tu DNS privado a un resolvedor público fiable como 1.1.1.1 (Cloudflare) u 8.8.8.8 (Google) y vuelve a probar.\n2. Si sigue fallando, desactiva y vuelve a activar los datos móviles, o reinicia el teléfono, para conseguir una conexión nueva.\n3. Si sigue fallando, contacta con tu operador móvil: algunos operadores tienen sus propios resolvedores DNS que también sufren averías.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Cambia tu DNS privado a un resolvedor público fiable como 1.1.1.1 (Cloudflare) u 8.8.8.8 (Google) y vuelve a probar.\n2. Si estás en una red gestionada (trabajo, colegio, Wi-Fi público), contacta con el administrador de la red para que arregle el DNS.\n3. Si estás en tu propia red, revisa los ajustes del router. Es buena práctica configurar también el DNS secundario con un resolvedor público (ejemplos: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), por si falla el primario (tu proveedor de Internet).';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'El puerto $port está bloqueado';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'El acceso general a Internet funciona, pero el tráfico de $service en el puerto $port está bloqueado, probablemente por un cortafuegos de esta red. Algunas aplicaciones que dependen de este puerto no funcionarán.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Es probable que tu operador móvil lo bloquee por política: prueba con Wi-Fi o una VPN, o contacta con tu operador si necesitas este puerto abierto por red móvil.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Si ahora mismo estás conectado a una red gestionada (trabajo, colegio, Wi-Fi público), el puerto $port está bloqueado por política: prueba con datos móviles o una VPN. En tu propia red, revisa las reglas del cortafuegos en los ajustes del router.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problema de ruta de red en tu operador';

  @override
  String get verdictIspPathIspTitle => 'Problema de ruta de red en tu ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Tu conexión llega a Internet, pero el tráfico se detiene por el camino, después de $hop. El fallo está en tu operador móvil o en la ruta troncal, no en tu teléfono.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Tu conexión llega a Internet, pero el tráfico se detiene por el camino, después de $hop. El fallo está en tu proveedor de Internet o en la ruta troncal, no en tu dispositivo ni en tu router.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'un salto dentro de tu operador móvil';

  @override
  String get verdictIspPathHopGenericFixed =>
      'un salto dentro de tu proveedor de Internet';

  @override
  String get solutionIspPathMessageMobile =>
      'No hay nada que arreglar en tu dispositivo ni en tu red. Informa de la ruta que falla a tu operador móvil (menciona que el traceroute se corta a medio camino). Suele resolverse en cuanto arreglan la ruta.';

  @override
  String get solutionIspPathMessageFixed =>
      'No hay nada que arreglar en tu dispositivo ni en tu red. Informa de la ruta que falla a tu proveedor de Internet (menciona que el traceroute se corta a medio camino). Suele resolverse en cuanto arreglan la ruta.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Tu $medium es bueno para $uses, y para más';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Si aun así algo va mal, lo más probable es que sea una aplicación o un sitio web concreto, no tu conexión.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Tu $medium es bueno para todo excepto para $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Tu $medium es demasiado débil para $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Medido por $medium:\nbajada $down Mbps, subida $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Medido por $medium:\nbajada $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Medido por $medium:\nsubida $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Medido por $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'La prueba de subida no se pudo ejecutar, por lo que no se ha evaluado.';

  @override
  String get verdictCauseGatewayWeak =>
      'Tu router responde despacio o pierde paquetes, lo que apunta al propio Wi-Fi y no a tu proveedor.';

  @override
  String get verdictCauseSaturated =>
      'La conexión se ralentiza mucho mientras está ocupada. Alguien o algo más en tu red (una descarga, una copia de seguridad, una tele) está usando la línea.';

  @override
  String get verdictCauseThroughput =>
      'La velocidad de la conexión no es suficiente. O tu plan de Internet es demasiado lento o tu proveedor está limitando la línea.';

  @override
  String get verdictCauseGeneric =>
      'Los tiempos de respuesta y la pérdida de paquetes varían demasiado para las actividades en tiempo real más exigentes.';

  @override
  String get adviceMoveCloser =>
      'Acércate al router, o prueba la red de 5 GHz si tu router ofrece una.';

  @override
  String get advicePauseTheHog =>
      'Averigua quién o qué está usando mucho la línea y pide que lo pause. Si no, espera o reinicia el Wi-Fi: eso también corta su conexión.';

  @override
  String get adviceDropTheCamera =>
      'Apaga la cámara: tu conexión aún puede transmitir el audio.';

  @override
  String get actionTestAgain => 'Volver a probar';

  @override
  String get actionTestAgainWifi => 'Volver a probar por Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Volver a probar por datos móviles';

  @override
  String get actionTurnOnWifi => 'Activar el Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'El Wi-Fi está desactivado. ¿Abrir los ajustes para activarlo?';

  @override
  String get actionTurnOnMobileData => 'Activar los datos móviles';

  @override
  String get confirmTurnOnMobileData =>
      'Los datos móviles están desactivados. ¿Abrir los ajustes para activarlos?';

  @override
  String get actionOpenFlightSettings => 'Abrir los ajustes del modo avión';

  @override
  String get confirmFlightMode =>
      'Estás en modo avión. ¿Abrir los ajustes para desactivarlo?';

  @override
  String get actionOpenSignInPage => 'Abrir la página de inicio de sesión';

  @override
  String get confirmCaptivePortal =>
      'Te bloquea una página de inicio de sesión. ¿Abrirla ahora?';

  @override
  String get actionOpenMobileDataSettings =>
      'Abrir los ajustes de datos móviles';

  @override
  String get confirmMobileDataSettings =>
      '¿Abrir los ajustes de datos móviles para comprobar la itinerancia y los datos?';

  @override
  String get actionOpenPrivateDns => 'Abrir los ajustes de DNS privado';

  @override
  String get confirmPrivateDns =>
      '¿Abrir los ajustes de DNS privado para que puedas cambiar a 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'datos móviles',
      'ethernet': 'conexión por cable',
      'vpn': 'conexión VPN',
      'other': 'conexión',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streaming de música',
      'voiceCalls': 'llamadas de voz',
      'webBrowsing': 'navegación web',
      'losslessMusic': 'música sin pérdidas',
      'videoCalls720': 'videollamadas (720p)',
      'teamGames': 'juegos en equipo',
      'videoCallsHd': 'videollamadas (HD)',
      'hdVideo': 'vídeo HD (1080p)',
      'fastGames': 'juegos en línea rápidos',
      'video4k': 'vídeo 4K',
      'other': 'esta actividad',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'cualquier cosa exigente';

  @override
  String listTwo(String a, String b) {
    return '$a y $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head y $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'bajada $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'subida $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'latencia $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'pérdida de paquetes $value%';
  }

  @override
  String get logHeadDeviceLink => 'Enlace del dispositivo';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Accesibilidad de Internet';

  @override
  String get logHeadPorts => 'Puertos';

  @override
  String get logHeadPopularSites => 'Sitios populares';

  @override
  String get logHeadMeasurements => 'Mediciones';

  @override
  String get logHeadGoodFor => 'Bueno para';

  @override
  String get logHeadNotGoodFor => 'No suficiente para';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Pruebas realizadas ($count)';
  }

  @override
  String get logYes => 'sí';

  @override
  String get logNo => 'no';

  @override
  String get logUnknown => 'desconocido';

  @override
  String get logNotApplicable => 'n/d';

  @override
  String get logNotMeasured => 'no medido';

  @override
  String get logNotReported => 'no informado';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Conectividad: $kind, modo avión: $flight';
  }

  @override
  String get logFlightOn => 'activado ✈️';

  @override
  String get logFlightOff => 'desactivado ✅';

  @override
  String logGateway(String value) {
    return 'Puerta de enlace: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Puerta de enlace accesible: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'accesible ✅';

  @override
  String get logInternetReachableNo => 'sin respuesta ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Página de inicio de sesión cautiva: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Dirección IP directa accesible: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'El nombre se resuelve ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'La ruta llegó a Internet: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'La ruta llegó a Internet: $answer (último salto: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Puerto $port/$service: $state';
  }

  @override
  String get logPortOpen => 'abierto ✅';

  @override
  String get logPortBlocked => 'bloqueado ❌';

  @override
  String logPopularCountry(String value) {
    return 'País: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Sitios populares accesibles: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Probado por: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Se midieron los datos móviles porque son el enlace en uso (Wi-Fi no conectado, o elegiste volver a probar por red móvil)';

  @override
  String logCellularSignalReported(int level) {
    return 'Señal móvil: $level de 4';
  }

  @override
  String get logCellularSignalMissing => 'Señal móvil: no informada';

  @override
  String logDownloadLine(String value) {
    return 'Bajada: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Subida: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Movido por la prueba de velocidad: recibido $received, enviado $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Tiempo de respuesta de $label: sin respuesta a $sent sondas';
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
    return 'Tiempo de respuesta de $label: $avg ms de media (mín $min, máx $max), jitter $jitter ms, pérdida $loss% ($received/$sent respuestas)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Tiempo de respuesta con la línea ocupada: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Tiempo de respuesta con la línea ocupada: $ms ms ($ratio× en reposo)';
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
    return 'Datos totales usados por este diagnóstico: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Ese total cubre todas las pruebas anteriores, no solo la prueba de velocidad';

  @override
  String logTrafficSent(String size) {
    return 'enviado $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'recibido $size';
  }
}
