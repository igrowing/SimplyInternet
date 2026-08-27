// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get homeTitle => '인터넷이 안 되나요?\n불안정하거나 일부만 작동하나요?';

  @override
  String get homeDiagnoseButton => '문제를 찾아 해결 방법 제시';

  @override
  String get homeUrlPrompt => '특정 웹사이트나 서비스가 작동하지 않나요?\n여기에 링크(URL)를 붙여넣으세요:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => '확인하기';

  @override
  String get homeSettingsTooltip => '설정';

  @override
  String get homeRunningDiagnosis => '종합 점검 실행 중…';

  @override
  String get homeRunningUrlCheck => '웹사이트 확인 중…';

  @override
  String get homeCheckFailedTitle => '점검을 완료할 수 없습니다';

  @override
  String get homeUnknownError => '알 수 없는 오류';

  @override
  String get homeTryAgain => '다시 시도';

  @override
  String get commonBack => '뒤로';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageCaption => '진단 결과와 기술 세부 정보를 포함해 앱 전체가 번역되어 있습니다.';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeSystem => '시스템';

  @override
  String get settingsThemeLight => '밝게';

  @override
  String get settingsThemeDark => '어둡게';

  @override
  String get settingsFontSize => '글자 크기';

  @override
  String get settingsFontSmall => '작게';

  @override
  String get settingsFontNormal => '보통';

  @override
  String get settingsFontLarge => '크게';

  @override
  String get settingsCheckForUpdate => '업데이트 확인';

  @override
  String get settingsBuyMeACoffee => '커피 한 잔 사주기';

  @override
  String get resultWhatToDo => '해야 할 일';

  @override
  String get resultDialogNotNow => '나중에';

  @override
  String get resultDialogYes => '예';

  @override
  String get resultNothingToOpen => '이 단계에서 열 항목이 없습니다.';

  @override
  String resultActionFailed(String error) {
    return '이 작업을 완료할 수 없습니다: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return '내 연결로 할 수 있는 것 ($total개 중 $fits개)';
  }

  @override
  String get resultUploadNotMeasured => '업로드 속도를 측정할 수 없어 평가하지 못했습니다.';

  @override
  String get techDetailsTitle => '기술 세부정보';

  @override
  String get techDetailsCopy => '복사';

  @override
  String get techDetailsCopied => '기술 세부정보를 복사했습니다.';

  @override
  String get urlOpenInBrowser => '브라우저에서 열기';

  @override
  String get urlCheckAnother => '다른 주소 확인';

  @override
  String get urlCouldNotOpenBrowser => '브라우저를 열 수 없습니다.';

  @override
  String urlCouldNotOpen(String error) {
    return '열 수 없습니다: $error';
  }

  @override
  String get urlNothingToTestAgain => '다시 테스트할 항목이 없습니다.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return '설정을 열 수 없습니다: $error';
  }

  @override
  String get crossMediumTestOverMobile => '모바일 데이터로 테스트';

  @override
  String get crossMediumTestOverWifi => 'Wi-Fi로 테스트';

  @override
  String get crossMediumHintMobile => 'Wi-Fi를 끄고 돌아오세요 — 점검이 자동으로 다시 실행됩니다.';

  @override
  String get crossMediumHintWifi => 'Wi-Fi를 켜고 돌아오세요 — 점검이 자동으로 다시 실행됩니다.';

  @override
  String get verdictFlightModeTitle => '비행기 모드입니다';

  @override
  String get verdictFlightModeDetail =>
      '무선이 꺼져 있어 비행기 모드가 켜진 동안에는 무엇도 인터넷에 연결할 수 없습니다.';

  @override
  String get solutionFlightModeMessage => '비행기 모드를 끄고 다시 시도하세요.';

  @override
  String get verdictNotConnectedTitle => '어떤 네트워크에도 연결되지 않음';

  @override
  String get verdictNotConnectedDetail =>
      'Wi-Fi와 모바일 데이터가 모두 꺼진 것으로 보여 인터넷에 연결할 방법이 없습니다.';

  @override
  String get solutionNotConnectedMessage => 'Wi-Fi 또는 모바일 데이터를 켜고 다시 시도하세요.';

  @override
  String get verdictRouterNotRespondingTitle => '공유기가 응답하지 않음';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return '네트워크에는 연결되어 있지만 $where이(가) 응답하지 않습니다. 멈췄거나 전원이 나갔을 수 있습니다.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return '공유기($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => '공유기';

  @override
  String get solutionRouterNotRespondingMessage =>
      '공유기를 재시작하세요. 전원을 뽑고 30초 기다린 뒤 다시 꽂고, 부팅에 2~5분 정도 기다립니다. 그런 다음 테스트를 다시 실행하세요.';

  @override
  String get verdictCaptivePortalTitle => '로그인 필요 (캡티브 포털)';

  @override
  String get verdictCaptivePortalDetail =>
      '네트워크가 온라인 접속을 허용하기 전에 웹 페이지에서 로그인하거나 약관에 동의하도록 요구합니다. 호텔, 카페, 공항에서 흔합니다.';

  @override
  String get solutionCaptivePortalMessage =>
      '로그인 페이지를 열어 로그인을 완료한 뒤 테스트를 다시 실행하세요.';

  @override
  String get verdictNoInternetMobileTitle => '모바일 데이터에 연결되었지만 인터넷이 없음';

  @override
  String get verdictNoInternetMobileDetail =>
      '휴대전화가 기본 수준으로는 네트워크에 도달하지만 인터넷으로 가는 정상 경로가 없습니다. 이는 휴대전화가 아니라 통신사 네트워크의 문제를 가리킵니다.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. 비행기 모드를 켰다 껐다 하거나 휴대전화를 재시작하여 새 기지국에 다시 연결합니다.\n2. 2~5분 후에도 테스트가 계속 실패하면 이동통신사에 문의하세요. 장애는 통신사 쪽에 있습니다.';

  @override
  String get verdictNoInternetIspTitle => '공유기에 연결되었지만 인터넷이 없음';

  @override
  String get verdictNoInternetIspDetail =>
      '공유기는 작동하지만 인터넷 서비스 제공업체(ISP)와의 정상 연결이 없습니다. 문제는 집 밖에 있습니다.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. 공유기가 벽면 전화/DSL 소켓에 연결되어 있는지 확인합니다.\n2. 케이블이 손상되거나 헐겁지 않은지 확인합니다.\n3. 유선 전화가 있다면 수화기를 들고 발신음을 들어 보세요. 발신음이 들리지 않으면 회선을 고치기 위해 전화 회사나 인터넷 제공업체에 문의합니다.\n4. ISP 연결을 다시 맺기 위해 공유기를 한 번 재시작합니다. 2~5분 후에도 테스트가 계속 실패하면 인터넷 제공업체에 문의하세요. 장애는 업체 쪽에 있습니다.';

  @override
  String get verdictMobileNoDataTitle => '모바일 데이터가 연결되었지만 작동하지 않음';

  @override
  String get verdictMobileNoDataDetail =>
      '휴대전화가 이동통신망에 있지만 데이터가 지나가지 않습니다. 보통 데이터 로밍이 꺼져 있거나, 데이터 용량을 다 썼거나, 통신사에 국지적 장애가 있는 경우입니다.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. 해외나 다른 네트워크에 있다면 모바일 설정에서 데이터 로밍을 켭니다.\n2. 요금제에 데이터가 아직 남아 있는지 확인합니다.\n3. $reception\n4. 그래도 실패하면 이동통신사에 문의하세요.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': '모바일 데이터를 껐다가 다시 켭니다.',
      'weak': '신호가 약합니다. 수신 상태가 더 좋은 곳으로 이동한 뒤 모바일 데이터를 껐다가 다시 켭니다.',
      'other': '신호가 더 좋은 곳으로 이동하거나, 모바일 데이터를 껐다가 다시 켭니다.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS 문제';

  @override
  String get verdictDnsProblemDetail =>
      '인터넷에는 도달하지만 웹사이트 이름이 주소로 변환되지 않습니다. DNS 문제이며 보통 공용 DNS 리졸버로 바꾸면 쉽게 해결됩니다.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. 비공개 DNS를 1.1.1.1(Cloudflare)이나 8.8.8.8(Google) 같은 신뢰할 수 있는 공용 리졸버로 바꾼 뒤 다시 테스트합니다.\n2. 그래도 실패하면 새 연결을 얻기 위해 모바일 데이터를 껐다 켜거나 휴대전화를 재시작합니다.\n3. 그래도 실패하면 이동통신사에 문의하세요. 일부 통신사는 자체 DNS 리졸버를 운영하며 거기에서 장애가 나기도 합니다.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. 비공개 DNS를 1.1.1.1(Cloudflare)이나 8.8.8.8(Google) 같은 신뢰할 수 있는 공용 리졸버로 바꾼 뒤 다시 테스트합니다.\n2. 관리형 네트워크(직장, 학교, 공용 Wi-Fi)에 있다면 DNS를 고치도록 네트워크 관리자에게 문의합니다.\n3. 자신의 네트워크라면 공유기 설정을 확인합니다. 기본 DNS(인터넷 제공업체)가 실패할 경우를 대비해 보조 DNS도 공용 리졸버로 설정해 두는 것이 좋습니다(예: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8).';

  @override
  String verdictPortBlockedTitle(String port) {
    return '$port 포트가 차단됨';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return '일반 인터넷 접속은 되지만 $port 포트의 $service 트래픽이 차단되고 있습니다. 이 네트워크의 방화벽 때문일 가능성이 높습니다. 이 포트에 의존하는 일부 앱은 작동하지 않습니다.';
  }

  @override
  String get solutionPortBlockedMobile =>
      '이동통신사가 정책상 차단하고 있을 가능성이 높습니다. 대신 Wi-Fi나 VPN을 사용하거나, 이동통신에서 이 포트를 열어야 한다면 통신사에 문의하세요.';

  @override
  String solutionPortBlockedFixed(String port) {
    return '현재 관리형 네트워크(직장, 학교, 공용 Wi-Fi)에 연결되어 있다면 $port 포트는 정책상 차단되어 있습니다. 대신 모바일 데이터나 VPN을 사용하세요. 자신의 네트워크에서는 공유기 설정의 방화벽 규칙을 확인합니다.';
  }

  @override
  String get verdictIspPathMobileTitle => '통신사 측 네트워크 경로 문제';

  @override
  String get verdictIspPathIspTitle => 'ISP 측 네트워크 경로 문제';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return '연결은 인터넷에 도달하지만 트래픽이 도중에 멈춥니다($hop 이후). 오류는 휴대전화가 아니라 이동통신사나 백본 경로에 있습니다.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return '연결은 인터넷에 도달하지만 트래픽이 도중에 멈춥니다($hop 이후). 오류는 기기나 공유기가 아니라 인터넷 제공업체나 백본 경로에 있습니다.';
  }

  @override
  String get verdictIspPathHopGenericMobile => '이동통신사 내부의 어떤 홉';

  @override
  String get verdictIspPathHopGenericFixed => '인터넷 제공업체 내부의 어떤 홉';

  @override
  String get solutionIspPathMessageMobile =>
      '기기나 네트워크에서 고칠 것은 없습니다. 문제가 되는 경로를 이동통신사에 신고하세요(traceroute가 도중에 멈춘다고 언급하세요). 보통 경로를 고치면 해결됩니다.';

  @override
  String get solutionIspPathMessageFixed =>
      '기기나 네트워크에서 고칠 것은 없습니다. 문제가 되는 경로를 인터넷 제공업체에 신고하세요(traceroute가 도중에 멈춘다고 언급하세요). 보통 경로를 고치면 해결됩니다.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return '$medium은(는) $uses에 충분하며, 그 이상도 가능합니다';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured 그래도 뭔가 이상하다면 대개 특정 앱이나 웹사이트 문제이며, 연결 문제는 아닙니다.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return '$medium은(는) $failing을(를) 제외한 모든 것에 충분합니다';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return '$medium은(는) $failing에는 너무 약합니다';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '$medium에서 측정:\n다운로드 $down Mbps, 업로드 $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '$medium에서 측정:\n다운로드 $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '$medium에서 측정:\n업로드 $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '$medium에서 측정.';
  }

  @override
  String get verdictUploadNotAssessed => '업로드 테스트를 실행할 수 없어 평가하지 않았습니다.';

  @override
  String get verdictCauseGatewayWeak =>
      '공유기 응답이 느리거나 패킷을 버리고 있습니다. 이는 제공업체가 아니라 Wi-Fi 자체를 가리킵니다.';

  @override
  String get verdictCauseSaturated =>
      '사용량이 많을 때 연결이 급격히 느려집니다. 네트워크의 누군가 또는 무언가(다운로드, 백업, TV)가 회선을 쓰고 있습니다.';

  @override
  String get verdictCauseThroughput =>
      '연결 속도가 충분하지 않습니다. 인터넷 요금제가 너무 느리거나 제공업체가 회선을 제한하고 있습니다.';

  @override
  String get verdictCauseGeneric =>
      '응답 시간과 패킷 손실의 변동이 커서 가장 까다로운 실시간 작업에는 적합하지 않습니다.';

  @override
  String get adviceMoveCloser =>
      '공유기에 더 가까이 가거나, 공유기가 지원한다면 5GHz 네트워크를 사용해 보세요.';

  @override
  String get advicePauseTheHog =>
      '회선을 많이 쓰는 사람이나 대상을 찾아 잠시 멈춰 달라고 요청하세요. 어렵다면 기다리거나 Wi-Fi를 재시작하세요(상대 연결도 끊깁니다).';

  @override
  String get adviceDropTheCamera => '카메라를 끄세요. 연결은 음성은 계속 전달할 수 있습니다.';

  @override
  String get actionTestAgain => '다시 테스트';

  @override
  String get actionTestAgainWifi => 'Wi-Fi로 다시 테스트';

  @override
  String get actionTestAgainMobile => '모바일 데이터로 다시 테스트';

  @override
  String get actionTurnOnWifi => 'Wi-Fi 켜기';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi가 꺼져 있습니다. 설정을 열어 켤까요?';

  @override
  String get actionTurnOnMobileData => '모바일 데이터 켜기';

  @override
  String get confirmTurnOnMobileData => '모바일 데이터가 꺼져 있습니다. 설정을 열어 켤까요?';

  @override
  String get actionOpenFlightSettings => '비행기 모드 설정 열기';

  @override
  String get confirmFlightMode => '비행기 모드입니다. 설정을 열어 끌까요?';

  @override
  String get actionOpenSignInPage => '로그인 페이지 열기';

  @override
  String get confirmCaptivePortal => '로그인 페이지에 막혀 있습니다. 지금 열까요?';

  @override
  String get actionOpenMobileDataSettings => '모바일 데이터 설정 열기';

  @override
  String get confirmMobileDataSettings => '로밍과 데이터를 확인하도록 모바일 데이터 설정을 열까요?';

  @override
  String get actionOpenPrivateDns => '비공개 DNS 설정 열기';

  @override
  String get confirmPrivateDns => '1.1.1.1로 바꿀 수 있도록 비공개 DNS 설정을 열까요?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': '모바일 데이터',
      'ethernet': '유선 연결',
      'vpn': 'VPN 연결',
      'other': '연결',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': '음악 스트리밍',
      'voiceCalls': '음성 통화',
      'webBrowsing': '웹 탐색',
      'losslessMusic': '무손실 음악',
      'videoCalls720': '영상 통화(720p)',
      'teamGames': '팀 게임',
      'videoCallsHd': '영상 통화(HD)',
      'hdVideo': 'HD 영상(1080p)',
      'fastGames': '빠른 온라인 게임',
      'video4k': '4K 영상',
      'other': '이 활동',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => '부하가 큰 모든 작업';

  @override
  String listTwo(String a, String b) {
    return '$a 및 $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head 및 $last';
  }

  @override
  String shortfallDownload(String value) {
    return '다운로드 $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return '업로드 $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return '지연 시간 $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return '지터 $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return '패킷 손실 $value%';
  }

  @override
  String get logHeadDeviceLink => '기기 연결';

  @override
  String get logHeadRouter => '공유기';

  @override
  String get logHeadInternetReachability => '인터넷 도달성';

  @override
  String get logHeadPorts => '포트';

  @override
  String get logHeadPopularSites => '주요 사이트';

  @override
  String get logHeadMeasurements => '측정';

  @override
  String get logHeadGoodFor => '적합한 용도';

  @override
  String get logHeadNotGoodFor => '부족한 용도';

  @override
  String logHeadTestsPerformed(int count) {
    return '수행한 테스트 ($count)';
  }

  @override
  String get logYes => '예';

  @override
  String get logNo => '아니요';

  @override
  String get logUnknown => '알 수 없음';

  @override
  String get logNotApplicable => '해당 없음';

  @override
  String get logNotMeasured => '측정 안 됨';

  @override
  String get logNotReported => '보고 안 됨';

  @override
  String logConnectivity(String kind, String flight) {
    return '연결: $kind, 비행기 모드: $flight';
  }

  @override
  String get logFlightOn => '켜짐 ✈️';

  @override
  String get logFlightOff => '꺼짐 ✅';

  @override
  String logGateway(String value) {
    return '게이트웨이: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return '게이트웨이 도달 가능: $answer';
  }

  @override
  String logInternet(String state) {
    return '인터넷: $state';
  }

  @override
  String get logInternetReachableYes => '도달 가능 ✅';

  @override
  String get logInternetReachableNo => '응답 없음 ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return '캡티브 로그인 페이지: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return '원시 IP 주소 도달 가능: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return '이름 확인($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return '경로가 인터넷에 도달: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return '경로가 인터넷에 도달: $answer (마지막 홉: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return '포트 $port/$service: $state';
  }

  @override
  String get logPortOpen => '열림 ✅';

  @override
  String get logPortBlocked => '차단됨 ❌';

  @override
  String logPopularCountry(String value) {
    return '국가: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return '도달 가능한 주요 사이트: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return '테스트 매체: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      '사용 중인 연결이 모바일 데이터여서 측정했습니다(Wi-Fi 미연결, 또는 모바일로 다시 테스트 선택)';

  @override
  String logCellularSignalReported(int level) {
    return '이동통신 신호: 4단계 중 $level';
  }

  @override
  String get logCellularSignalMissing => '이동통신 신호: 보고 안 됨';

  @override
  String logDownloadLine(String value) {
    return '다운로드: $value';
  }

  @override
  String logUploadLine(String value) {
    return '업로드: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return '속도 테스트로 전송: 수신 $received, 송신 $sent';
  }

  @override
  String get logLabelRouter => '공유기';

  @override
  String get logLabelInternet => '인터넷';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label 응답 시간: $sent회 프로브에 응답 없음';
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
    return '$label 응답 시간: 평균 $avg ms (최소 $min, 최대 $max), 지터 $jitter ms, 손실 $loss% ($received/$sent 응답)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return '사용 중 응답 시간: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return '사용 중 응답 시간: $ms ms (유휴 시의 $ratio배)';
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
    return '이 진단에서 사용한 총 데이터: $traffic';
  }

  @override
  String get logTotalCovers => '이 합계는 속도 테스트만이 아니라 위의 모든 테스트를 포함합니다';

  @override
  String logTrafficSent(String size) {
    return '송신 $size';
  }

  @override
  String logTrafficReceived(String size) {
    return '수신 $size';
  }
}
