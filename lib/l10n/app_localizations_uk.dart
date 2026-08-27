// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get homeTitle => 'Інтернет не працює?\nНестабільно? Працює частково?';

  @override
  String get homeDiagnoseButton => 'Знайти проблему та запропонувати рішення';

  @override
  String get homeUrlPrompt =>
      'Певний сайт або сервіс не працює?\nВставте його посилання (URL) тут:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Перевірити';

  @override
  String get homeSettingsTooltip => 'Налаштування';

  @override
  String get homeRunningDiagnosis => 'Виконується комплексна перевірка…';

  @override
  String get homeRunningUrlCheck => 'Перевірка сайту…';

  @override
  String get homeCheckFailedTitle => 'Не вдалося завершити перевірку';

  @override
  String get homeUnknownError => 'Невідома помилка';

  @override
  String get homeTryAgain => 'Спробувати ще раз';

  @override
  String get commonBack => 'Назад';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageCaption =>
      'Увесь застосунок перекладено, зокрема результати діагностики та їхні технічні подробиці.';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSystem => 'Системна';

  @override
  String get settingsThemeLight => 'Світла';

  @override
  String get settingsThemeDark => 'Темна';

  @override
  String get settingsFontSize => 'Розмір шрифту';

  @override
  String get settingsFontSmall => 'Малий';

  @override
  String get settingsFontNormal => 'Звичайний';

  @override
  String get settingsFontLarge => 'Великий';

  @override
  String get settingsCheckForUpdate => 'Перевірити оновлення';

  @override
  String get settingsBuyMeACoffee => 'Пригостити мене кавою';

  @override
  String get resultWhatToDo => 'Що робити';

  @override
  String get resultDialogNotNow => 'Не зараз';

  @override
  String get resultDialogYes => 'Так';

  @override
  String get resultNothingToOpen => 'Для цього кроку немає чого відкривати.';

  @override
  String resultActionFailed(String error) {
    return 'Не вдалося виконати цю дію: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'Що вміє ваше з\'єднання ($fits із $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Не вдалося виміряти вихідну швидкість, тому її не оцінено.';

  @override
  String get techDetailsTitle => 'Технічні подробиці';

  @override
  String get techDetailsCopy => 'Копіювати';

  @override
  String get techDetailsCopied => 'Технічні подробиці скопійовано.';

  @override
  String get urlOpenInBrowser => 'Відкрити в браузері';

  @override
  String get urlCheckAnother => 'Перевірити ще один';

  @override
  String get urlCouldNotOpenBrowser => 'Не вдалося відкрити браузер.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Не вдалося відкрити: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Немає чого тестувати знову.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Не вдалося відкрити налаштування: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Перевірити через мобільний інтернет';

  @override
  String get crossMediumTestOverWifi => 'Перевірити через Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Вимкніть Wi-Fi і поверніться — перевірка запуститься знову сама.';

  @override
  String get crossMediumHintWifi =>
      'Увімкніть Wi-Fi і поверніться — перевірка запуститься знову сама.';

  @override
  String get verdictFlightModeTitle => 'Увімкнено режим польоту';

  @override
  String get verdictFlightModeDetail =>
      'Бездротовий зв\'язок вимкнено, тож доки увімкнено режим польоту, ніщо не може вийти в інтернет.';

  @override
  String get solutionFlightModeMessage =>
      'Вимкніть режим польоту й спробуйте ще раз.';

  @override
  String get verdictNotConnectedTitle => 'Немає підключення до жодної мережі';

  @override
  String get verdictNotConnectedDetail =>
      'Схоже, що і Wi-Fi, і мобільні дані вимкнено, тож вийти в інтернет неможливо.';

  @override
  String get solutionNotConnectedMessage =>
      'Увімкніть Wi-Fi або мобільні дані й спробуйте ще раз.';

  @override
  String get verdictRouterNotRespondingTitle => 'Маршрутизатор не відповідає';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Ви підключені до мережі, але $where не відповідає. Можливо, він завис або лишився без живлення.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'ваш маршрутизатор ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'ваш маршрутизатор';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Перезавантажте маршрутизатор: вимкніть його з розетки, зачекайте 30 секунд, знову ввімкніть і дайте йому близько 2–5 хвилин на запуск. Потім запустіть тест знову.';

  @override
  String get verdictCaptivePortalTitle => 'Потрібен вхід (кептив-портал)';

  @override
  String get verdictCaptivePortalDetail =>
      'Мережа вимагає, щоб ви увійшли або прийняли умови на вебсторінці, перш ніж пустити вас онлайн — звична річ у готелях, кафе й аеропортах.';

  @override
  String get solutionCaptivePortalMessage =>
      'Відкрийте сторінку входу й завершіть вхід, потім запустіть тест знову.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Підключено до мобільних даних, але без інтернету';

  @override
  String get verdictNoInternetMobileDetail =>
      'Телефон під\'єднується до мережі на базовому рівні, але не має робочого шляху до інтернету. Це вказує на проблему в мережі вашого оператора, а не в телефоні.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Увімкніть і вимкніть режим польоту, або перезавантажте телефон, щоб під\'єднатися до іншої вежі.\n2. Якщо тест і далі не проходить через 2–5 хвилин, зверніться до свого мобільного оператора — збій на його боці.';

  @override
  String get verdictNoInternetIspTitle =>
      'Підключено до маршрутизатора, але без інтернету';

  @override
  String get verdictNoInternetIspDetail =>
      'Маршрутизатор працює, але не має робочого з\'єднання з вашим інтернет-провайдером (ISP). Проблема поза межами вашого дому.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Перевірте, чи під\'єднано маршрутизатор до настінної телефонної/DSL-розетки.\n2. Перевірте, що кабель не пошкоджений і не відходить.\n3. Якщо у вас є стаціонарний телефон, підніміть слухавку й послухайте гудок. Якщо гудка немає, зверніться до телефонної компанії та/або інтернет-провайдера, щоб полагодити лінію.\n4. Один раз перезавантажте маршрутизатор, щоб відновити зв\'язок із провайдером. Якщо тест і далі не проходить через 2–5 хвилин, зверніться до інтернет-провайдера — збій на його боці.';

  @override
  String get verdictMobileNoDataTitle =>
      'Мобільні дані підключені, але не працюють';

  @override
  String get verdictMobileNoDataDetail =>
      'Телефон у мобільній мережі, але дані не проходять. Зазвичай це означає, що вимкнено роумінг даних, вичерпано пакет трафіку або в оператора локальний збій.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Якщо ви за кордоном або в іншій мережі, увімкніть роумінг даних у налаштуваннях мобільної мережі.\n2. Перевірте, що у вашому тарифі ще лишився трафік.\n3. $reception\n4. Якщо й далі не працює, зверніться до свого мобільного оператора.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Вимкніть і знову ввімкніть мобільні дані.',
      'weak':
          'Сигнал слабкий: перейдіть у місце з кращим прийомом і вимкніть і знову ввімкніть мобільні дані.',
      'other':
          'Перейдіть у місце з кращим сигналом, або вимкніть і знову ввімкніть мобільні дані.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Проблема з DNS';

  @override
  String get verdictDnsProblemDetail =>
      'Інтернет доступний, але імена сайтів не перетворюються на адреси. Це проблема DNS, і зазвичай її легко розв\'язати, перемкнувшись на публічний DNS-резолвер.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Перемкніть приватний DNS на надійний публічний резолвер, наприклад 1.1.1.1 (Cloudflare) або 8.8.8.8 (Google), і перевірте знову.\n2. Якщо й далі не працює, вимкніть і знову ввімкніть мобільні дані, або перезавантажте телефон, щоб отримати нове з\'єднання.\n3. Якщо й далі не працює, зверніться до свого мобільного оператора — деякі оператори мають власні DNS-резолвери, у яких бувають власні збої.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Перемкніть приватний DNS на надійний публічний резолвер, наприклад 1.1.1.1 (Cloudflare) або 8.8.8.8 (Google), і перевірте знову.\n2. Якщо ви в керованій мережі (робота, школа, публічний Wi-Fi), зверніться до адміністратора мережі, щоб полагодити DNS.\n3. Якщо ви у власній мережі, перевірте налаштування маршрутизатора. Варто задати й вторинний DNS на публічний резолвер (приклади: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8) на випадок відмови основного (вашого інтернет-провайдера).';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'Порт $port заблоковано';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'Загальний доступ до інтернету працює, але трафік $service на порту $port блокується — імовірно, брандмауером цієї мережі. Деякі застосунки, яким потрібен цей порт, не працюватимуть.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'Ваш мобільний оператор, найпевніше, блокує його за своїми правилами — спробуйте натомість Wi-Fi або VPN, або зверніться до оператора, якщо вам потрібен цей порт відкритим у мобільній мережі.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Якщо ви зараз підключені до керованої мережі (робота, школа, публічний Wi-Fi), порт $port заблоковано за правилами — спробуйте натомість мобільні дані або VPN. У власній мережі перевірте правила брандмауера в налаштуваннях маршрутизатора.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Проблема з мережевим маршрутом у вашого оператора';

  @override
  String get verdictIspPathIspTitle =>
      'Проблема з мережевим маршрутом у вашого провайдера';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'Ваше з\'єднання доходить до інтернету, але трафік уривається дорогою, після $hop. Збій у вашого мобільного оператора або на магістральному маршруті, а не в телефоні.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'Ваше з\'єднання доходить до інтернету, але трафік уривається дорогою, після $hop. Збій у вашого інтернет-провайдера або на магістральному маршруті, а не у вашому пристрої чи маршрутизаторі.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'вузла всередині мережі вашого мобільного оператора';

  @override
  String get verdictIspPathHopGenericFixed =>
      'вузла всередині мережі вашого інтернет-провайдера';

  @override
  String get solutionIspPathMessageMobile =>
      'На вашому пристрої та у вашій мережі лагодити нічого. Повідомте про збійний маршрут своєму мобільному оператору (згадайте, що traceroute уривається на півдорозі). Зазвичай це минає, щойно вони лагодять маршрут.';

  @override
  String get solutionIspPathMessageFixed =>
      'На вашому пристрої та у вашій мережі лагодити нічого. Повідомте про збійний маршрут своєму інтернет-провайдеру (згадайте, що traceroute уривається на півдорозі). Зазвичай це минає, щойно вони лагодять маршрут.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'Ваш $medium підходить для $uses — і не тільки';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Якщо щось усе одно працює не так, найпевніше річ у конкретному застосунку чи сайті, а не у вашому з\'єднанні.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'Ваш $medium підходить для всього, крім $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'Ваш $medium заслабкий для $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Виміряно через $medium:\nзавантаження $down Мбіт/с, вивантаження $up Мбіт/с.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Виміряно через $medium:\nзавантаження $down Мбіт/с.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Виміряно через $medium:\nвивантаження $up Мбіт/с.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Виміряно через $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'Тест вивантаження не вдалося виконати, тож його не оцінювали.';

  @override
  String get verdictCauseGatewayWeak =>
      'Маршрутизатор відповідає повільно або втрачає пакети, що вказує на сам Wi-Fi, а не на провайдера.';

  @override
  String get verdictCauseSaturated =>
      'З\'єднання різко сповільнюється під навантаженням. Хтось або щось інше у вашій мережі (завантаження, резервне копіювання, телевізор) займає канал.';

  @override
  String get verdictCauseThroughput =>
      'Швидкості з\'єднання недостатньо. Або ваш тариф надто повільний, або провайдер обмежує канал.';

  @override
  String get verdictCauseGeneric =>
      'Час відповіді та втрати пакетів надто нестабільні для найвимогливіших завдань у реальному часі.';

  @override
  String get adviceMoveCloser =>
      'Підійдіть ближче до маршрутизатора, або спробуйте мережу 5 ГГц, якщо маршрутизатор її пропонує.';

  @override
  String get advicePauseTheHog =>
      'З\'ясуйте, хто або що сильно навантажує канал, і попросіть призупинити. Інакше зачекайте, або перезавантажте Wi-Fi — це від\'єднає і їх.';

  @override
  String get adviceDropTheCamera =>
      'Вимкніть камеру — з\'єднання все ще впорається зі звуком.';

  @override
  String get actionTestAgain => 'Перевірити знову';

  @override
  String get actionTestAgainWifi => 'Перевірити знову через Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Перевірити знову через мобільні дані';

  @override
  String get actionTurnOnWifi => 'Увімкнути Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi вимкнено. Відкрити налаштування, щоб увімкнути його?';

  @override
  String get actionTurnOnMobileData => 'Увімкнути мобільні дані';

  @override
  String get confirmTurnOnMobileData =>
      'Мобільні дані вимкнено. Відкрити налаштування, щоб увімкнути їх?';

  @override
  String get actionOpenFlightSettings => 'Відкрити налаштування режиму польоту';

  @override
  String get confirmFlightMode =>
      'Ви в режимі польоту. Відкрити налаштування, щоб його вимкнути?';

  @override
  String get actionOpenSignInPage => 'Відкрити сторінку входу';

  @override
  String get confirmCaptivePortal =>
      'Вас блокує сторінка входу. Відкрити її зараз?';

  @override
  String get actionOpenMobileDataSettings =>
      'Відкрити налаштування мобільних даних';

  @override
  String get confirmMobileDataSettings =>
      'Відкрити налаштування мобільних даних, щоб перевірити роумінг і трафік?';

  @override
  String get actionOpenPrivateDns => 'Відкрити налаштування приватного DNS';

  @override
  String get confirmPrivateDns =>
      'Відкрити налаштування приватного DNS, щоб перемкнутися на 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'мобільні дані',
      'ethernet': 'дротове з\'єднання',
      'vpn': 'з\'єднання VPN',
      'other': 'з\'єднання',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'стримінг музики',
      'voiceCalls': 'голосові дзвінки',
      'webBrowsing': 'перегляд вебу',
      'losslessMusic': 'музика без втрат',
      'videoCalls720': 'відеодзвінки (720p)',
      'teamGames': 'командні ігри',
      'videoCallsHd': 'відеодзвінки (HD)',
      'hdVideo': 'HD-відео (1080p)',
      'fastGames': 'швидкі онлайн-ігри',
      'video4k': 'відео 4K',
      'other': 'це заняття',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'будь-що вимогливе';

  @override
  String listTwo(String a, String b) {
    return '$a та $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head та $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'завантаження $value Мбіт/с';
  }

  @override
  String shortfallUpload(String value) {
    return 'вивантаження $value Мбіт/с';
  }

  @override
  String shortfallLatency(String value) {
    return 'затримка $value мс';
  }

  @override
  String shortfallJitter(String value) {
    return 'джитер $value мс';
  }

  @override
  String shortfallLoss(String value) {
    return 'втрати пакетів $value%';
  }

  @override
  String get logHeadDeviceLink => 'Зв\'язок пристрою';

  @override
  String get logHeadRouter => 'Маршрутизатор';

  @override
  String get logHeadInternetReachability => 'Доступність інтернету';

  @override
  String get logHeadPorts => 'Порти';

  @override
  String get logHeadPopularSites => 'Популярні сайти';

  @override
  String get logHeadMeasurements => 'Вимірювання';

  @override
  String get logHeadGoodFor => 'Підходить для';

  @override
  String get logHeadNotGoodFor => 'Недостатньо для';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Виконано перевірок ($count)';
  }

  @override
  String get logYes => 'так';

  @override
  String get logNo => 'ні';

  @override
  String get logUnknown => 'невідомо';

  @override
  String get logNotApplicable => 'н/д';

  @override
  String get logNotMeasured => 'не виміряно';

  @override
  String get logNotReported => 'не повідомлено';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Підключення: $kind, режим польоту: $flight';
  }

  @override
  String get logFlightOn => 'увімк ✈️';

  @override
  String get logFlightOff => 'вимк ✅';

  @override
  String logGateway(String value) {
    return 'Шлюз: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Шлюз доступний: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Інтернет: $state';
  }

  @override
  String get logInternetReachableYes => 'доступний ✅';

  @override
  String get logInternetReachableNo => 'немає відповіді ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Сторінка входу кептив-порталу: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Пряма IP-адреса доступна: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'Ім\'я розв\'язується ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'Маршрут дійшов до інтернету: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'Маршрут дійшов до інтернету: $answer (останній вузол: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Порт $port/$service: $state';
  }

  @override
  String get logPortOpen => 'відкритий ✅';

  @override
  String get logPortBlocked => 'заблокований ❌';

  @override
  String logPopularCountry(String value) {
    return 'Країна: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Доступно популярних сайтів: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Перевірено через: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Мобільні дані вимірювалися, бо це використовуване підключення (Wi-Fi не підключено, або ви обрали повторну перевірку через мобільну мережу)';

  @override
  String logCellularSignalReported(int level) {
    return 'Сигнал стільникової мережі: $level з 4';
  }

  @override
  String get logCellularSignalMissing =>
      'Сигнал стільникової мережі: не повідомлено';

  @override
  String logDownloadLine(String value) {
    return 'Завантаження: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Вивантаження: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Мбіт/с';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Передано тестом швидкості: отримано $received, надіслано $sent';
  }

  @override
  String get logLabelRouter => 'Маршрутизатор';

  @override
  String get logLabelInternet => 'Інтернет';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Час відповіді ($label): немає відповіді на $sent проб';
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
    return 'Час відповіді ($label): $avg мс у середньому (мін $min, макс $max), джитер $jitter мс, втрати $loss% ($received/$sent відповідей)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Час відповіді під навантаженням: $ms мс';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Час відповіді під навантаженням: $ms мс ($ratio× відносно спокою)';
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
    return 'Усього даних використано цією діагностикою: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Цей підсумок охоплює всі перевірки вище, не лише тест швидкості';

  @override
  String logTrafficSent(String size) {
    return 'надіслано $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'отримано $size';
  }
}
