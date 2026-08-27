// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get homeTitle =>
      'Интернет не работает?\nНестабильно? Работает частично?';

  @override
  String get homeDiagnoseButton => 'Найти проблему и предложить решение';

  @override
  String get homeUrlPrompt =>
      'Не работает конкретный сайт или сервис?\nВставьте сюда его ссылку (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Проверить';

  @override
  String get homeSettingsTooltip => 'Настройки';

  @override
  String get homeRunningDiagnosis => 'Выполняется комплексная проверка…';

  @override
  String get homeRunningUrlCheck => 'Проверка сайта…';

  @override
  String get homeCheckFailedTitle => 'Проверку не удалось завершить';

  @override
  String get homeUnknownError => 'Неизвестная ошибка';

  @override
  String get homeTryAgain => 'Повторить попытку';

  @override
  String get commonBack => 'Назад';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageCaption =>
      'Всё приложение переведено, включая результаты диагностики и их технические подробности.';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsFontSize => 'Размер шрифта';

  @override
  String get settingsFontSmall => 'Маленький';

  @override
  String get settingsFontNormal => 'Обычный';

  @override
  String get settingsFontLarge => 'Крупный';

  @override
  String get settingsCheckForUpdate => 'Проверить обновления';

  @override
  String get settingsBuyMeACoffee => 'Угостить меня кофе';

  @override
  String get resultWhatToDo => 'Что делать';

  @override
  String get resultDialogNotNow => 'Не сейчас';

  @override
  String get resultDialogYes => 'Да';

  @override
  String get resultNothingToOpen => 'Для этого шага нечего открывать.';

  @override
  String resultActionFailed(String error) {
    return 'Не удалось выполнить это действие: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Что умеет ваше подключение ($fits из $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Скорость отдачи не удалось измерить, поэтому она не оценивалась.';

  @override
  String get techDetailsTitle => 'Технические подробности';

  @override
  String get techDetailsCopy => 'Копировать';

  @override
  String get techDetailsCopied => 'Технические подробности скопированы.';

  @override
  String get urlOpenInBrowser => 'Открыть в браузере';

  @override
  String get urlCheckAnother => 'Проверить ещё один';

  @override
  String get urlCouldNotOpenBrowser => 'Не удалось открыть браузер.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Не удалось открыть: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Нечего проверять повторно.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Не удалось открыть настройки: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Проверить через мобильный интернет';

  @override
  String get crossMediumTestOverWifi => 'Проверить через Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Отключите Wi-Fi и вернитесь — проверка запустится снова сама.';

  @override
  String get crossMediumHintWifi =>
      'Включите Wi-Fi и вернитесь — проверка запустится снова сама.';

  @override
  String get verdictFlightModeTitle => 'Включён режим полёта';

  @override
  String get verdictFlightModeDetail =>
      'Беспроводная связь отключена, поэтому пока включён режим полёта, ничто не может выйти в интернет.';

  @override
  String get solutionFlightModeMessage =>
      'Отключите режим полёта и повторите попытку.';

  @override
  String get verdictNotConnectedTitle => 'Нет подключения ни к одной сети';

  @override
  String get verdictNotConnectedDetail =>
      'Похоже, что и Wi-Fi, и мобильные данные отключены, поэтому выйти в интернет невозможно.';

  @override
  String get solutionNotConnectedMessage =>
      'Включите Wi-Fi или мобильные данные и повторите попытку.';

  @override
  String get verdictRouterNotRespondingTitle => 'Роутер не отвечает';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Вы подключены к сети, но $where не отвечает. Возможно, он завис или остался без питания.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'ваш роутер ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'ваш роутер';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Перезагрузите роутер: отключите его от сети, подождите 30 секунд, снова включите и дайте ему около 2–5 минут на запуск. Затем запустите тест снова.';

  @override
  String get verdictCaptivePortalTitle => 'Требуется вход (кэптив-портал)';

  @override
  String get verdictCaptivePortalDetail =>
      'Сеть требует, чтобы вы вошли или приняли условия на веб-странице, прежде чем пустить вас в интернет — обычное дело в отелях, кафе и аэропортах.';

  @override
  String get solutionCaptivePortalMessage =>
      'Откройте страницу входа и завершите вход, затем запустите тест снова.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Подключено к мобильным данным, но без интернета';

  @override
  String get verdictNoInternetMobileDetail =>
      'Телефон подключается к сети на базовом уровне, но не имеет рабочего пути в интернет. Это указывает на проблему в сети вашего оператора, а не в телефоне.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Включите и выключите режим полёта или перезагрузите телефон, чтобы переподключиться к другой вышке.\n2. Если тест по-прежнему не проходит через 2–5 минут, обратитесь к своему мобильному оператору — сбой на его стороне.';

  @override
  String get verdictNoInternetIspTitle =>
      'Подключено к роутеру, но без интернета';

  @override
  String get verdictNoInternetIspDetail =>
      'Роутер работает, но у него нет рабочего соединения с вашим интернет-провайдером (ISP). Проблема за пределами вашего дома.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Проверьте, подключён ли роутер к настенной телефонной/DSL-розетке.\n2. Проверьте, что кабель не повреждён и не отходит.\n3. Если у вас есть стационарный телефон, снимите трубку и послушайте гудок. Если гудка нет, обратитесь в телефонную компанию и/или к интернет-провайдеру, чтобы починить линию.\n4. Один раз перезагрузите роутер, чтобы восстановить связь с провайдером. Если тест по-прежнему не проходит через 2–5 минут, обратитесь к интернет-провайдеру — сбой на его стороне.';

  @override
  String get verdictMobileNoDataTitle =>
      'Мобильные данные подключены, но не работают';

  @override
  String get verdictMobileNoDataDetail =>
      'Телефон в мобильной сети, но данные не проходят. Обычно это значит, что отключён роуминг данных, закончился пакет трафика или у оператора локальный сбой.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Если вы за границей или в другой сети, включите роуминг данных в настройках мобильной сети.\n2. Проверьте, что в вашем тарифе ещё остался трафик.\n3. $reception\n4. Если по-прежнему не работает, обратитесь к своему мобильному оператору.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Выключите и снова включите мобильные данные.',
      'weak':
          'Сигнал слабый: перейдите в место с лучшим приёмом и выключите и снова включите мобильные данные.',
      'other':
          'Перейдите в место с лучшим сигналом или выключите и снова включите мобильные данные.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Проблема с DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Интернет доступен, но имена сайтов не преобразуются в адреса. Это проблема DNS, и обычно её легко решить, переключившись на публичный DNS-резолвер.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Переключите частный DNS на надёжный публичный резолвер, например 1.1.1.1 (Cloudflare) или 8.8.8.8 (Google), и проверьте снова.\n2. Если по-прежнему не работает, выключите и снова включите мобильные данные или перезагрузите телефон, чтобы получить новое соединение.\n3. Если по-прежнему не работает, обратитесь к своему мобильному оператору — у некоторых операторов свои DNS-резолверы, у которых бывают собственные сбои.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Переключите частный DNS на надёжный публичный резолвер, например 1.1.1.1 (Cloudflare) или 8.8.8.8 (Google), и проверьте снова.\n2. Если вы в управляемой сети (работа, школа, публичный Wi-Fi), обратитесь к администратору сети, чтобы починить DNS.\n3. Если вы в своей сети, проверьте настройки роутера. Хорошая практика — задать и вторичный DNS на публичный резолвер (примеры: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8) на случай отказа основного (вашего интернет-провайдера).';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Порт $port заблокирован';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'Общий доступ в интернет работает, но трафик $service на порту $port блокируется — вероятно, брандмауэром этой сети. Некоторые приложения, которым нужен этот порт, работать не будут.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Ваш мобильный оператор, скорее всего, блокирует его по своим правилам — попробуйте вместо этого Wi-Fi или VPN, либо обратитесь к оператору, если вам нужен этот порт открытым в мобильной сети.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Если вы сейчас подключены к управляемой сети (работа, школа, публичный Wi-Fi), порт $port заблокирован по правилам — попробуйте вместо этого мобильные данные или VPN. В своей сети проверьте правила брандмауэра в настройках роутера.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Проблема с сетевым маршрутом у вашего оператора';

  @override
  String get verdictIspPathIspTitle =>
      'Проблема с сетевым маршрутом у вашего провайдера';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Ваше соединение доходит до интернета, но трафик обрывается по пути, после $hop. Сбой у вашего мобильного оператора или на магистральном маршруте, а не в телефоне.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Ваше соединение доходит до интернета, но трафик обрывается по пути, после $hop. Сбой у вашего интернет-провайдера или на магистральном маршруте, а не в вашем устройстве или роутере.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'узла внутри сети вашего мобильного оператора';

  @override
  String get verdictIspPathHopGenericFixed =>
      'узла внутри сети вашего интернет-провайдера';

  @override
  String get solutionIspPathMessageMobile =>
      'На вашем устройстве и в вашей сети чинить нечего. Сообщите о сбойном маршруте своему мобильному оператору (упомяните, что traceroute обрывается на полпути). Обычно это проходит, как только они чинят маршрут.';

  @override
  String get solutionIspPathMessageFixed =>
      'На вашем устройстве и в вашей сети чинить нечего. Сообщите о сбойном маршруте своему интернет-провайдеру (упомяните, что traceroute обрывается на полпути). Обычно это проходит, как только они чинят маршрут.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Ваш $medium подходит для $uses — и не только';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Если что-то всё равно работает не так, скорее всего дело в конкретном приложении или сайте, а не в вашем соединении.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Ваш $medium подходит для всего, кроме $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Ваш $medium слишком слаб для $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Измерено по $medium:\nзагрузка $down Мбит/с, отдача $up Мбит/с.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Измерено по $medium:\nзагрузка $down Мбит/с.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Измерено по $medium:\nотдача $up Мбит/с.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Измерено по $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Тест отдачи не удалось выполнить, поэтому он не оценивался.';

  @override
  String get verdictCauseGatewayWeak =>
      'Роутер отвечает медленно или теряет пакеты, что указывает на сам Wi-Fi, а не на провайдера.';

  @override
  String get verdictCauseSaturated =>
      'Соединение резко замедляется под нагрузкой. Кто-то или что-то ещё в вашей сети (загрузка, резервное копирование, телевизор) занимает канал.';

  @override
  String get verdictCauseThroughput =>
      'Скорости соединения недостаточно. Либо ваш тариф слишком медленный, либо провайдер ограничивает канал.';

  @override
  String get verdictCauseGeneric =>
      'Время отклика и потери пакетов слишком нестабильны для самых требовательных задач в реальном времени.';

  @override
  String get adviceMoveCloser =>
      'Подойдите ближе к роутеру или попробуйте сеть 5 ГГц, если роутер её предлагает.';

  @override
  String get advicePauseTheHog =>
      'Выясните, кто или что сильно нагружает канал, и попросите приостановить. Иначе подождите или перезагрузите Wi-Fi — это отключит и их.';

  @override
  String get adviceDropTheCamera =>
      'Отключите камеру — соединение всё ещё справится со звуком.';

  @override
  String get actionTestAgain => 'Проверить снова';

  @override
  String get actionTestAgainWifi => 'Проверить снова по Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Проверить снова по мобильным данным';

  @override
  String get actionTurnOnWifi => 'Включить Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi выключен. Открыть настройки, чтобы включить его?';

  @override
  String get actionTurnOnMobileData => 'Включить мобильные данные';

  @override
  String get confirmTurnOnMobileData =>
      'Мобильные данные выключены. Открыть настройки, чтобы включить их?';

  @override
  String get actionOpenFlightSettings => 'Открыть настройки режима полёта';

  @override
  String get confirmFlightMode =>
      'Вы в режиме полёта. Открыть настройки, чтобы его выключить?';

  @override
  String get actionOpenSignInPage => 'Открыть страницу входа';

  @override
  String get confirmCaptivePortal =>
      'Вас блокирует страница входа. Открыть её сейчас?';

  @override
  String get actionOpenMobileDataSettings =>
      'Открыть настройки мобильных данных';

  @override
  String get confirmMobileDataSettings =>
      'Открыть настройки мобильных данных, чтобы проверить роуминг и трафик?';

  @override
  String get actionOpenPrivateDns => 'Открыть настройки частного DNS';

  @override
  String get confirmPrivateDns =>
      'Открыть настройки частного DNS, чтобы переключиться на 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'мобильные данные',
      'ethernet': 'проводное соединение',
      'vpn': 'соединение VPN',
      'other': 'соединение',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'стриминг музыки',
      'voiceCalls': 'голосовые звонки',
      'webBrowsing': 'веб-сёрфинг',
      'losslessMusic': 'музыка без потерь',
      'videoCalls720': 'видеозвонки (720p)',
      'teamGames': 'командные игры',
      'videoCallsHd': 'видеозвонки (HD)',
      'hdVideo': 'HD-видео (1080p)',
      'fastGames': 'быстрые онлайн-игры',
      'video4k': 'видео 4K',
      'other': 'это занятие',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'что-либо требовательное';

  @override
  String listTwo(String a, String b) {
    return '$a и $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head и $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'загрузка $value Мбит/с';
  }

  @override
  String shortfallUpload(String value) {
    return 'отдача $value Мбит/с';
  }

  @override
  String shortfallLatency(String value) {
    return 'задержка $value мс';
  }

  @override
  String shortfallJitter(String value) {
    return 'джиттер $value мс';
  }

  @override
  String shortfallLoss(String value) {
    return 'потери пакетов $value%';
  }

  @override
  String get logHeadDeviceLink => 'Связь устройства';

  @override
  String get logHeadRouter => 'Роутер';

  @override
  String get logHeadInternetReachability => 'Доступность интернета';

  @override
  String get logHeadPorts => 'Порты';

  @override
  String get logHeadPopularSites => 'Популярные сайты';

  @override
  String get logHeadMeasurements => 'Измерения';

  @override
  String get logHeadGoodFor => 'Подходит для';

  @override
  String get logHeadNotGoodFor => 'Недостаточно для';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Выполнено проверок ($count)';
  }

  @override
  String get logYes => 'да';

  @override
  String get logNo => 'нет';

  @override
  String get logUnknown => 'неизвестно';

  @override
  String get logNotApplicable => 'н/д';

  @override
  String get logNotMeasured => 'не измерено';

  @override
  String get logNotReported => 'не сообщено';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Подключение: $kind, режим полёта: $flight';
  }

  @override
  String get logFlightOn => 'вкл ✈️';

  @override
  String get logFlightOff => 'выкл ✅';

  @override
  String logGateway(String value) {
    return 'Шлюз: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Шлюз доступен: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Интернет: $state';
  }

  @override
  String get logInternetReachableYes => 'доступен ✅';

  @override
  String get logInternetReachableNo => 'нет ответа ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Страница входа кэптив-портала: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Прямой IP-адрес доступен: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Имя разрешается ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Маршрут дошёл до интернета: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Маршрут дошёл до интернета: $answer (последний узел: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Порт $port/$service: $state';
  }

  @override
  String get logPortOpen => 'открыт ✅';

  @override
  String get logPortBlocked => 'заблокирован ❌';

  @override
  String logPopularCountry(String value) {
    return 'Страна: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Доступно популярных сайтов: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Проверено по: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Мобильные данные измерялись, потому что это используемое подключение (Wi-Fi не подключён, или вы выбрали повторную проверку по мобильной сети)';

  @override
  String logCellularSignalReported(int level) {
    return 'Сигнал сотовой сети: $level из 4';
  }

  @override
  String get logCellularSignalMissing => 'Сигнал сотовой сети: не сообщён';

  @override
  String logDownloadLine(String value) {
    return 'Загрузка: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Отдача: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Мбит/с';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Передано тестом скорости: принято $received, отправлено $sent';
  }

  @override
  String get logLabelRouter => 'Роутер';

  @override
  String get logLabelInternet => 'Интернет';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Время отклика ($label): нет ответа на $sent проб';
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
    return 'Время отклика ($label): $avg мс в среднем (мин $min, макс $max), джиттер $jitter мс, потери $loss% ($received/$sent ответов)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Время отклика под нагрузкой: $ms мс';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Время отклика под нагрузкой: $ms мс ($ratio× относительно простоя)';
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
    return 'Всего данных использовано этой диагностикой: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Этот итог включает все проверки выше, не только тест скорости';

  @override
  String logTrafficSent(String size) {
    return 'отправлено $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'принято $size';
  }
}
