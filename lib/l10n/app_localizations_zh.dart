// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get homeTitle => '网络不能用？\n不稳定？只能部分使用？';

  @override
  String get homeDiagnoseButton => '查找问题并给出解决方案';

  @override
  String get homeUrlPrompt => '某个特定网站或服务无法使用？\n在这里粘贴它的链接（网址）：';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => '检查';

  @override
  String get homeSettingsTooltip => '设置';

  @override
  String get homeRunningDiagnosis => '正在进行全面检查…';

  @override
  String get homeRunningUrlCheck => '正在检查网站…';

  @override
  String get homeCheckFailedTitle => '检查未能完成';

  @override
  String get homeUnknownError => '未知错误';

  @override
  String get homeTryAgain => '重试';

  @override
  String get commonBack => '返回';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageCaption => '整个应用均已翻译，包括诊断结果及其技术细节。';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String get settingsFontSmall => '小';

  @override
  String get settingsFontNormal => '正常';

  @override
  String get settingsFontLarge => '大';

  @override
  String get settingsCheckForUpdate => '检查更新';

  @override
  String get settingsBuyMeACoffee => '请我喝杯咖啡';

  @override
  String get resultWhatToDo => '该怎么做';

  @override
  String get resultDialogNotNow => '暂不';

  @override
  String get resultDialogYes => '是';

  @override
  String get resultNothingToOpen => '此步骤没有可打开的内容。';

  @override
  String resultActionFailed(String error) {
    return '无法完成该操作：$error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return '您的网络能做什么（共 $total 项，符合 $fits 项）';
  }

  @override
  String get resultUploadNotMeasured => '无法测量上传速度，因此未作评估。';

  @override
  String get techDetailsTitle => '技术详情';

  @override
  String get techDetailsCopy => '复制';

  @override
  String get techDetailsCopied => '技术详情已复制。';

  @override
  String get urlOpenInBrowser => '在浏览器中打开';

  @override
  String get urlCheckAnother => '检查其他网址';

  @override
  String get urlCouldNotOpenBrowser => '无法打开浏览器。';

  @override
  String urlCouldNotOpen(String error) {
    return '无法打开：$error';
  }

  @override
  String get urlNothingToTestAgain => '没有可重新测试的内容。';

  @override
  String urlCouldNotOpenSettings(String error) {
    return '无法打开设置：$error';
  }

  @override
  String get crossMediumTestOverMobile => '改用移动数据测试';

  @override
  String get crossMediumTestOverWifi => '改用 Wi-Fi 测试';

  @override
  String get crossMediumHintMobile => '关闭 Wi-Fi，然后返回——检查会自动重新运行。';

  @override
  String get crossMediumHintWifi => '打开 Wi-Fi，然后返回——检查会自动重新运行。';

  @override
  String get verdictFlightModeTitle => '你处于飞行模式';

  @override
  String get verdictFlightModeDetail => '无线已关闭，因此在飞行模式开启期间，任何内容都无法连接到互联网。';

  @override
  String get solutionFlightModeMessage => '关闭飞行模式，然后重试。';

  @override
  String get verdictNotConnectedTitle => '未连接到任何网络';

  @override
  String get verdictNotConnectedDetail => 'Wi-Fi 和移动数据似乎都已关闭，因此无法连接到互联网。';

  @override
  String get solutionNotConnectedMessage => '开启 Wi-Fi 或移动数据，然后重试。';

  @override
  String get verdictRouterNotRespondingTitle => '路由器没有响应';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return '你已连接到网络，但 $where 没有响应。它可能已崩溃或断电。';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return '你的路由器（$gateway）';
  }

  @override
  String get verdictRouterWhereUnnamed => '你的路由器';

  @override
  String get solutionRouterNotRespondingMessage =>
      '重启路由器：拔掉电源，等待 30 秒，重新插上，并给它大约 2-5 分钟启动。然后重新运行测试。';

  @override
  String get verdictCaptivePortalTitle => '需要登录（强制门户）';

  @override
  String get verdictCaptivePortalDetail =>
      '网络要求你在网页上登录或接受条款后才允许联网——在酒店、咖啡馆和机场很常见。';

  @override
  String get solutionCaptivePortalMessage => '打开登录页面并完成登录，然后重新运行测试。';

  @override
  String get verdictNoInternetMobileTitle => '已连接移动数据，但没有互联网';

  @override
  String get verdictNoInternetMobileDetail =>
      '你的手机在基本层面能接入网络，但没有通往互联网的可用路径。这表明是运营商网络出了问题，而不是你的手机。';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. 开关一次飞行模式，或重启手机，以重新连接到新的基站。\n2. 如果 2-5 分钟后测试仍失败，请联系你的移动运营商——故障在他们那边。';

  @override
  String get verdictNoInternetIspTitle => '已连接路由器，但没有互联网';

  @override
  String get verdictNoInternetIspDetail =>
      '你的路由器正常，但与你的互联网服务提供商（ISP）之间没有可用连接。问题出在你家之外。';

  @override
  String get solutionNoInternetIspMessage =>
      '1. 检查路由器是否连接到墙上的电话/DSL 插座。\n2. 检查线缆没有损坏或松动。\n3. 如果你有固定电话，拿起听筒听拨号音。如果听不到拨号音，请联系电话公司和/或互联网服务提供商修复线路。\n4. 重启路由器一次以重新建立 ISP 连接。如果 2-5 分钟后测试仍失败，请联系你的互联网服务提供商——故障在他们那边。';

  @override
  String get verdictMobileNoDataTitle => '移动数据已连接但无法工作';

  @override
  String get verdictMobileNoDataDetail =>
      '你的手机在移动网络上，但没有数据通过。这通常意味着数据漫游已关闭、套餐流量已用完，或运营商出现了局部故障。';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. 如果你在国外或在其他网络上，请在移动网络设置中开启数据漫游。\n2. 检查你的套餐是否还有剩余流量。\n3. $reception\n4. 如果仍失败，请联系你的移动运营商。';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': '关闭移动数据后再重新开启。',
      'weak': '你的信号较弱：移动到信号更好的位置，然后关闭移动数据再重新开启。',
      'other': '移动到信号更好的位置，或关闭移动数据再重新开启。',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS 问题';

  @override
  String get verdictDnsProblemDetail =>
      '互联网可达，但网站名称没有被解析为地址。这是 DNS 问题，通常切换到公共 DNS 解析器即可轻松解决。';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. 将你的私人 DNS 切换为可靠的公共解析器，如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然后重新测试。\n2. 如果仍失败，关闭移动数据后再开启，或重启手机，以获得新的连接。\n3. 如果仍失败，请联系你的移动运营商——有些运营商自建 DNS 解析器，本身也会出故障。';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. 将你的私人 DNS 切换为可靠的公共解析器，如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然后重新测试。\n2. 如果你在受管网络中（单位、学校、公共 Wi-Fi），请联系网络管理员修复 DNS。\n3. 如果你在自己的网络中，检查路由器设置。最好也把备用 DNS 设为公共解析器（例如 1.1.1.1、4.4.4.4、4.4.2.2、8.8.8.8），以防主用（你的互联网服务提供商）出现故障。';

  @override
  String verdictPortBlockedTitle(String port) {
    return '端口 $port 被封锁';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return '一般互联网访问正常，但端口 $port 上的 $service 流量被封锁——很可能是这个网络的防火墙所为。依赖此端口的一些应用将无法工作。';
  }

  @override
  String get solutionPortBlockedMobile =>
      '你的移动运营商很可能按策略封锁了它——请改用 Wi-Fi 或 VPN，或者如果你需要在移动网络上开放此端口，请联系运营商。';

  @override
  String solutionPortBlockedFixed(String port) {
    return '如果你当前连接的是受管网络（单位、学校、公共 Wi-Fi），端口 $port 按策略被封锁——请改用移动数据或 VPN。在你自己的网络中，检查路由器设置里的防火墙规则。';
  }

  @override
  String get verdictIspPathMobileTitle => '你的运营商处存在网络路径问题';

  @override
  String get verdictIspPathIspTitle => '你的 ISP 处存在网络路径问题';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return '你的连接能到达互联网，但流量在途中停止，在 $hop 之后。故障在你的移动运营商或骨干路由上，而不在你的手机上。';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return '你的连接能到达互联网，但流量在途中停止，在 $hop 之后。故障在你的互联网服务提供商或骨干路由上，而不在你的设备或路由器上。';
  }

  @override
  String get verdictIspPathHopGenericMobile => '你的移动运营商内部的某个跳点';

  @override
  String get verdictIspPathHopGenericFixed => '你的互联网服务提供商内部的某个跳点';

  @override
  String get solutionIspPathMessageMobile =>
      '你的设备或网络没有需要修复的地方。请把故障路由报告给你的移动运营商（说明 traceroute 在半路中断）。通常他们修好路由后就会恢复。';

  @override
  String get solutionIspPathMessageFixed =>
      '你的设备或网络没有需要修复的地方。请把故障路由报告给你的互联网服务提供商（说明 traceroute 在半路中断）。通常他们修好路由后就会恢复。';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return '你的$medium足以应对$uses——还能更多';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured 如果仍然觉得有问题，最可能是某个应用或网站，而不是你的连接。';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return '除了$failing，你的$medium足以应对其他一切';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return '你的$medium对$failing来说太弱了';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '通过$medium测得：\n下载 $down Mbps，上传 $up Mbps。';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '通过$medium测得：\n下载 $down Mbps。';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '通过$medium测得：\n上传 $up Mbps。';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '通过$medium测得。';
  }

  @override
  String get verdictUploadNotAssessed => '上传测试无法运行，因此未评估。';

  @override
  String get verdictCauseGatewayWeak => '你的路由器响应缓慢或丢包，这指向 Wi-Fi 本身，而不是你的服务提供商。';

  @override
  String get verdictCauseSaturated =>
      '连接繁忙时会明显变慢。你网络上的其他人或其他设备（下载、备份、电视）正在占用线路。';

  @override
  String get verdictCauseThroughput => '连接速度不足。要么是你的互联网套餐太慢，要么是服务提供商在限速。';

  @override
  String get verdictCauseGeneric => '响应时间和丢包波动过大，不适合要求最高的实时应用。';

  @override
  String get adviceMoveCloser => '靠近路由器，或者如果你的路由器提供 5 GHz 网络，试试该网络。';

  @override
  String get advicePauseTheHog =>
      '找出谁或什么在大量占用线路，并请其暂停。否则就等待，或重启你的 Wi-Fi——这也会切断他们的连接。';

  @override
  String get adviceDropTheCamera => '关闭摄像头——你的连接仍然可以传输音频。';

  @override
  String get actionTestAgain => '重新测试';

  @override
  String get actionTestAgainWifi => '通过 Wi-Fi 重新测试';

  @override
  String get actionTestAgainMobile => '通过移动数据重新测试';

  @override
  String get actionTurnOnWifi => '开启 Wi-Fi';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi 已关闭。打开设置以开启它？';

  @override
  String get actionTurnOnMobileData => '开启移动数据';

  @override
  String get confirmTurnOnMobileData => '移动数据已关闭。打开设置以开启它？';

  @override
  String get actionOpenFlightSettings => '打开飞行模式设置';

  @override
  String get confirmFlightMode => '你处于飞行模式。打开设置以关闭它？';

  @override
  String get actionOpenSignInPage => '打开登录页面';

  @override
  String get confirmCaptivePortal => '你被一个登录页面拦住了。现在打开它？';

  @override
  String get actionOpenMobileDataSettings => '打开移动数据设置';

  @override
  String get confirmMobileDataSettings => '打开移动数据设置以检查漫游和流量？';

  @override
  String get actionOpenPrivateDns => '打开私人 DNS 设置';

  @override
  String get confirmPrivateDns => '打开私人 DNS 设置以便切换到 1.1.1.1？';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': '移动数据',
      'ethernet': '有线连接',
      'vpn': 'VPN 连接',
      'other': '连接',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': '音乐流媒体',
      'voiceCalls': '语音通话',
      'webBrowsing': '网页浏览',
      'losslessMusic': '无损音乐',
      'videoCalls720': '视频通话（720p）',
      'teamGames': '团队游戏',
      'videoCallsHd': '视频通话（HD）',
      'hdVideo': '高清视频（1080p）',
      'fastGames': '快节奏在线游戏',
      'video4k': '4K 视频',
      'other': '此项活动',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => '任何高要求的用途';

  @override
  String listTwo(String a, String b) {
    return '$a和$b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head和$last';
  }

  @override
  String shortfallDownload(String value) {
    return '下载 $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return '上传 $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return '延迟 $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return '抖动 $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return '丢包 $value%';
  }

  @override
  String get logHeadDeviceLink => '设备链路';

  @override
  String get logHeadRouter => '路由器';

  @override
  String get logHeadInternetReachability => '互联网可达性';

  @override
  String get logHeadPorts => '端口';

  @override
  String get logHeadPopularSites => '热门网站';

  @override
  String get logHeadMeasurements => '测量';

  @override
  String get logHeadGoodFor => '适合';

  @override
  String get logHeadNotGoodFor => '不足以支持';

  @override
  String logHeadTestsPerformed(int count) {
    return '已执行的测试（$count）';
  }

  @override
  String get logYes => '是';

  @override
  String get logNo => '否';

  @override
  String get logUnknown => '未知';

  @override
  String get logNotApplicable => '不适用';

  @override
  String get logNotMeasured => '未测量';

  @override
  String get logNotReported => '未报告';

  @override
  String logConnectivity(String kind, String flight) {
    return '连接方式：$kind，飞行模式：$flight';
  }

  @override
  String get logFlightOn => '开 ✈️';

  @override
  String get logFlightOff => '关 ✅';

  @override
  String logGateway(String value) {
    return '网关：$value';
  }

  @override
  String logGatewayReachable(String answer) {
    return '网关可达：$answer';
  }

  @override
  String logInternet(String state) {
    return '互联网：$state';
  }

  @override
  String get logInternetReachableYes => '可达 ✅';

  @override
  String get logInternetReachableNo => '无响应 ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return '强制门户登录页面：$answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return '原始 IP 地址可达：$answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return '名称解析（$host）：$answer';
  }

  @override
  String logRouteReached(String answer) {
    return '路由到达互联网：$answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return '路由到达互联网：$answer（最后一跳：$hop）';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return '端口 $port/$service：$state';
  }

  @override
  String get logPortOpen => '开放 ✅';

  @override
  String get logPortBlocked => '被封锁 ❌';

  @override
  String logPopularCountry(String value) {
    return '国家/地区：$value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return '可达的热门网站：$reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return '测试所用：$medium';
  }

  @override
  String get logMobileMeasuredReason =>
      '测量了移动数据，因为它是正在使用的链路（未连接 Wi-Fi，或你选择了通过移动网络重新测试）';

  @override
  String logCellularSignalReported(int level) {
    return '蜂窝信号：4 格中的 $level';
  }

  @override
  String get logCellularSignalMissing => '蜂窝信号：未报告';

  @override
  String logDownloadLine(String value) {
    return '下载：$value';
  }

  @override
  String logUploadLine(String value) {
    return '上传：$value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return '速度测试传输量：接收 $received，发送 $sent';
  }

  @override
  String get logLabelRouter => '路由器';

  @override
  String get logLabelInternet => '互联网';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label响应时间：$sent 个探测无响应';
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
    return '$label响应时间：平均 $avg ms（最小 $min，最大 $max），抖动 $jitter ms，丢包 $loss%（$received/$sent 个响应）';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return '繁忙时的响应时间：$ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return '繁忙时的响应时间：$ms ms（空闲时的 $ratio 倍）';
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
    return '本次诊断使用的总数据量：$traffic';
  }

  @override
  String get logTotalCovers => '该总量涵盖上面的所有测试，不仅仅是速度测试';

  @override
  String logTrafficSent(String size) {
    return '发送 $size';
  }

  @override
  String logTrafficReceived(String size) {
    return '接收 $size';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get homeTitle => '网络不能用？\n不稳定？只能部分使用？';

  @override
  String get homeDiagnoseButton => '查找问题并给出解决方案';

  @override
  String get homeUrlPrompt => '某个特定网站或服务无法使用？\n在这里粘贴它的链接（网址）：';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => '检查';

  @override
  String get homeSettingsTooltip => '设置';

  @override
  String get homeRunningDiagnosis => '正在进行全面检查…';

  @override
  String get homeRunningUrlCheck => '正在检查网站…';

  @override
  String get homeCheckFailedTitle => '检查未能完成';

  @override
  String get homeUnknownError => '未知错误';

  @override
  String get homeTryAgain => '重试';

  @override
  String get commonBack => '返回';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageCaption => '整个应用均已翻译，包括诊断结果及其技术细节。';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String get settingsFontSmall => '小';

  @override
  String get settingsFontNormal => '正常';

  @override
  String get settingsFontLarge => '大';

  @override
  String get settingsCheckForUpdate => '检查更新';

  @override
  String get settingsBuyMeACoffee => '请我喝杯咖啡';

  @override
  String get resultWhatToDo => '该怎么做';

  @override
  String get resultDialogNotNow => '暂不';

  @override
  String get resultDialogYes => '是';

  @override
  String get resultNothingToOpen => '此步骤没有可打开的内容。';

  @override
  String resultActionFailed(String error) {
    return '无法完成该操作：$error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return '您的网络能做什么（共 $total 项，符合 $fits 项）';
  }

  @override
  String get resultUploadNotMeasured => '无法测量上传速度，因此未作评估。';

  @override
  String get techDetailsTitle => '技术详情';

  @override
  String get techDetailsCopy => '复制';

  @override
  String get techDetailsCopied => '技术详情已复制。';

  @override
  String get urlOpenInBrowser => '在浏览器中打开';

  @override
  String get urlCheckAnother => '检查其他网址';

  @override
  String get urlCouldNotOpenBrowser => '无法打开浏览器。';

  @override
  String urlCouldNotOpen(String error) {
    return '无法打开：$error';
  }

  @override
  String get urlNothingToTestAgain => '没有可重新测试的内容。';

  @override
  String urlCouldNotOpenSettings(String error) {
    return '无法打开设置：$error';
  }

  @override
  String get crossMediumTestOverMobile => '改用移动数据测试';

  @override
  String get crossMediumTestOverWifi => '改用 Wi-Fi 测试';

  @override
  String get crossMediumHintMobile => '关闭 Wi-Fi，然后返回——检查会自动重新运行。';

  @override
  String get crossMediumHintWifi => '打开 Wi-Fi，然后返回——检查会自动重新运行。';

  @override
  String get verdictFlightModeTitle => '你处于飞行模式';

  @override
  String get verdictFlightModeDetail => '无线已关闭，因此在飞行模式开启期间，任何内容都无法连接到互联网。';

  @override
  String get solutionFlightModeMessage => '关闭飞行模式，然后重试。';

  @override
  String get verdictNotConnectedTitle => '未连接到任何网络';

  @override
  String get verdictNotConnectedDetail => 'Wi-Fi 和移动数据似乎都已关闭，因此无法连接到互联网。';

  @override
  String get solutionNotConnectedMessage => '开启 Wi-Fi 或移动数据，然后重试。';

  @override
  String get verdictRouterNotRespondingTitle => '路由器没有响应';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return '你已连接到网络，但 $where 没有响应。它可能已崩溃或断电。';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return '你的路由器（$gateway）';
  }

  @override
  String get verdictRouterWhereUnnamed => '你的路由器';

  @override
  String get solutionRouterNotRespondingMessage =>
      '重启路由器：拔掉电源，等待 30 秒，重新插上，并给它大约 2-5 分钟启动。然后重新运行测试。';

  @override
  String get verdictCaptivePortalTitle => '需要登录（强制门户）';

  @override
  String get verdictCaptivePortalDetail =>
      '网络要求你在网页上登录或接受条款后才允许联网——在酒店、咖啡馆和机场很常见。';

  @override
  String get solutionCaptivePortalMessage => '打开登录页面并完成登录，然后重新运行测试。';

  @override
  String get verdictNoInternetMobileTitle => '已连接移动数据，但没有互联网';

  @override
  String get verdictNoInternetMobileDetail =>
      '你的手机在基本层面能接入网络，但没有通往互联网的可用路径。这表明是运营商网络出了问题，而不是你的手机。';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. 开关一次飞行模式，或重启手机，以重新连接到新的基站。\n2. 如果 2-5 分钟后测试仍失败，请联系你的移动运营商——故障在他们那边。';

  @override
  String get verdictNoInternetIspTitle => '已连接路由器，但没有互联网';

  @override
  String get verdictNoInternetIspDetail =>
      '你的路由器正常，但与你的互联网服务提供商（ISP）之间没有可用连接。问题出在你家之外。';

  @override
  String get solutionNoInternetIspMessage =>
      '1. 检查路由器是否连接到墙上的电话/DSL 插座。\n2. 检查线缆没有损坏或松动。\n3. 如果你有固定电话，拿起听筒听拨号音。如果听不到拨号音，请联系电话公司和/或互联网服务提供商修复线路。\n4. 重启路由器一次以重新建立 ISP 连接。如果 2-5 分钟后测试仍失败，请联系你的互联网服务提供商——故障在他们那边。';

  @override
  String get verdictMobileNoDataTitle => '移动数据已连接但无法工作';

  @override
  String get verdictMobileNoDataDetail =>
      '你的手机在移动网络上，但没有数据通过。这通常意味着数据漫游已关闭、套餐流量已用完，或运营商出现了局部故障。';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. 如果你在国外或在其他网络上，请在移动网络设置中开启数据漫游。\n2. 检查你的套餐是否还有剩余流量。\n3. $reception\n4. 如果仍失败，请联系你的移动运营商。';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': '关闭移动数据后再重新开启。',
      'weak': '你的信号较弱：移动到信号更好的位置，然后关闭移动数据再重新开启。',
      'other': '移动到信号更好的位置，或关闭移动数据再重新开启。',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS 问题';

  @override
  String get verdictDnsProblemDetail =>
      '互联网可达，但网站名称没有被解析为地址。这是 DNS 问题，通常切换到公共 DNS 解析器即可轻松解决。';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. 将你的私人 DNS 切换为可靠的公共解析器，如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然后重新测试。\n2. 如果仍失败，关闭移动数据后再开启，或重启手机，以获得新的连接。\n3. 如果仍失败，请联系你的移动运营商——有些运营商自建 DNS 解析器，本身也会出故障。';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. 将你的私人 DNS 切换为可靠的公共解析器，如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然后重新测试。\n2. 如果你在受管网络中（单位、学校、公共 Wi-Fi），请联系网络管理员修复 DNS。\n3. 如果你在自己的网络中，检查路由器设置。最好也把备用 DNS 设为公共解析器（例如 1.1.1.1、4.4.4.4、4.4.2.2、8.8.8.8），以防主用（你的互联网服务提供商）出现故障。';

  @override
  String verdictPortBlockedTitle(String port) {
    return '端口 $port 被封锁';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return '一般互联网访问正常，但端口 $port 上的 $service 流量被封锁——很可能是这个网络的防火墙所为。依赖此端口的一些应用将无法工作。';
  }

  @override
  String get solutionPortBlockedMobile =>
      '你的移动运营商很可能按策略封锁了它——请改用 Wi-Fi 或 VPN，或者如果你需要在移动网络上开放此端口，请联系运营商。';

  @override
  String solutionPortBlockedFixed(String port) {
    return '如果你当前连接的是受管网络（单位、学校、公共 Wi-Fi），端口 $port 按策略被封锁——请改用移动数据或 VPN。在你自己的网络中，检查路由器设置里的防火墙规则。';
  }

  @override
  String get verdictIspPathMobileTitle => '你的运营商处存在网络路径问题';

  @override
  String get verdictIspPathIspTitle => '你的 ISP 处存在网络路径问题';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return '你的连接能到达互联网，但流量在途中停止，在 $hop 之后。故障在你的移动运营商或骨干路由上，而不在你的手机上。';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return '你的连接能到达互联网，但流量在途中停止，在 $hop 之后。故障在你的互联网服务提供商或骨干路由上，而不在你的设备或路由器上。';
  }

  @override
  String get verdictIspPathHopGenericMobile => '你的移动运营商内部的某个跳点';

  @override
  String get verdictIspPathHopGenericFixed => '你的互联网服务提供商内部的某个跳点';

  @override
  String get solutionIspPathMessageMobile =>
      '你的设备或网络没有需要修复的地方。请把故障路由报告给你的移动运营商（说明 traceroute 在半路中断）。通常他们修好路由后就会恢复。';

  @override
  String get solutionIspPathMessageFixed =>
      '你的设备或网络没有需要修复的地方。请把故障路由报告给你的互联网服务提供商（说明 traceroute 在半路中断）。通常他们修好路由后就会恢复。';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return '你的$medium足以应对$uses——还能更多';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured 如果仍然觉得有问题，最可能是某个应用或网站，而不是你的连接。';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return '除了$failing，你的$medium足以应对其他一切';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return '你的$medium对$failing来说太弱了';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '通过$medium测得：\n下载 $down Mbps，上传 $up Mbps。';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '通过$medium测得：\n下载 $down Mbps。';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '通过$medium测得：\n上传 $up Mbps。';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '通过$medium测得。';
  }

  @override
  String get verdictUploadNotAssessed => '上传测试无法运行，因此未评估。';

  @override
  String get verdictCauseGatewayWeak => '你的路由器响应缓慢或丢包，这指向 Wi-Fi 本身，而不是你的服务提供商。';

  @override
  String get verdictCauseSaturated =>
      '连接繁忙时会明显变慢。你网络上的其他人或其他设备（下载、备份、电视）正在占用线路。';

  @override
  String get verdictCauseThroughput => '连接速度不足。要么是你的互联网套餐太慢，要么是服务提供商在限速。';

  @override
  String get verdictCauseGeneric => '响应时间和丢包波动过大，不适合要求最高的实时应用。';

  @override
  String get adviceMoveCloser => '靠近路由器，或者如果你的路由器提供 5 GHz 网络，试试该网络。';

  @override
  String get advicePauseTheHog =>
      '找出谁或什么在大量占用线路，并请其暂停。否则就等待，或重启你的 Wi-Fi——这也会切断他们的连接。';

  @override
  String get adviceDropTheCamera => '关闭摄像头——你的连接仍然可以传输音频。';

  @override
  String get actionTestAgain => '重新测试';

  @override
  String get actionTestAgainWifi => '通过 Wi-Fi 重新测试';

  @override
  String get actionTestAgainMobile => '通过移动数据重新测试';

  @override
  String get actionTurnOnWifi => '开启 Wi-Fi';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi 已关闭。打开设置以开启它？';

  @override
  String get actionTurnOnMobileData => '开启移动数据';

  @override
  String get confirmTurnOnMobileData => '移动数据已关闭。打开设置以开启它？';

  @override
  String get actionOpenFlightSettings => '打开飞行模式设置';

  @override
  String get confirmFlightMode => '你处于飞行模式。打开设置以关闭它？';

  @override
  String get actionOpenSignInPage => '打开登录页面';

  @override
  String get confirmCaptivePortal => '你被一个登录页面拦住了。现在打开它？';

  @override
  String get actionOpenMobileDataSettings => '打开移动数据设置';

  @override
  String get confirmMobileDataSettings => '打开移动数据设置以检查漫游和流量？';

  @override
  String get actionOpenPrivateDns => '打开私人 DNS 设置';

  @override
  String get confirmPrivateDns => '打开私人 DNS 设置以便切换到 1.1.1.1？';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': '移动数据',
      'ethernet': '有线连接',
      'vpn': 'VPN 连接',
      'other': '连接',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': '音乐流媒体',
      'voiceCalls': '语音通话',
      'webBrowsing': '网页浏览',
      'losslessMusic': '无损音乐',
      'videoCalls720': '视频通话（720p）',
      'teamGames': '团队游戏',
      'videoCallsHd': '视频通话（HD）',
      'hdVideo': '高清视频（1080p）',
      'fastGames': '快节奏在线游戏',
      'video4k': '4K 视频',
      'other': '此项活动',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => '任何高要求的用途';

  @override
  String listTwo(String a, String b) {
    return '$a和$b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head和$last';
  }

  @override
  String shortfallDownload(String value) {
    return '下载 $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return '上传 $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return '延迟 $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return '抖动 $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return '丢包 $value%';
  }

  @override
  String get logHeadDeviceLink => '设备链路';

  @override
  String get logHeadRouter => '路由器';

  @override
  String get logHeadInternetReachability => '互联网可达性';

  @override
  String get logHeadPorts => '端口';

  @override
  String get logHeadPopularSites => '热门网站';

  @override
  String get logHeadMeasurements => '测量';

  @override
  String get logHeadGoodFor => '适合';

  @override
  String get logHeadNotGoodFor => '不足以支持';

  @override
  String logHeadTestsPerformed(int count) {
    return '已执行的测试（$count）';
  }

  @override
  String get logYes => '是';

  @override
  String get logNo => '否';

  @override
  String get logUnknown => '未知';

  @override
  String get logNotApplicable => '不适用';

  @override
  String get logNotMeasured => '未测量';

  @override
  String get logNotReported => '未报告';

  @override
  String logConnectivity(String kind, String flight) {
    return '连接方式：$kind，飞行模式：$flight';
  }

  @override
  String get logFlightOn => '开 ✈️';

  @override
  String get logFlightOff => '关 ✅';

  @override
  String logGateway(String value) {
    return '网关：$value';
  }

  @override
  String logGatewayReachable(String answer) {
    return '网关可达：$answer';
  }

  @override
  String logInternet(String state) {
    return '互联网：$state';
  }

  @override
  String get logInternetReachableYes => '可达 ✅';

  @override
  String get logInternetReachableNo => '无响应 ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return '强制门户登录页面：$answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return '原始 IP 地址可达：$answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return '名称解析（$host）：$answer';
  }

  @override
  String logRouteReached(String answer) {
    return '路由到达互联网：$answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return '路由到达互联网：$answer（最后一跳：$hop）';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return '端口 $port/$service：$state';
  }

  @override
  String get logPortOpen => '开放 ✅';

  @override
  String get logPortBlocked => '被封锁 ❌';

  @override
  String logPopularCountry(String value) {
    return '国家/地区：$value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return '可达的热门网站：$reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return '测试所用：$medium';
  }

  @override
  String get logMobileMeasuredReason =>
      '测量了移动数据，因为它是正在使用的链路（未连接 Wi-Fi，或你选择了通过移动网络重新测试）';

  @override
  String logCellularSignalReported(int level) {
    return '蜂窝信号：4 格中的 $level';
  }

  @override
  String get logCellularSignalMissing => '蜂窝信号：未报告';

  @override
  String logDownloadLine(String value) {
    return '下载：$value';
  }

  @override
  String logUploadLine(String value) {
    return '上传：$value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return '速度测试传输量：接收 $received，发送 $sent';
  }

  @override
  String get logLabelRouter => '路由器';

  @override
  String get logLabelInternet => '互联网';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label响应时间：$sent 个探测无响应';
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
    return '$label响应时间：平均 $avg ms（最小 $min，最大 $max），抖动 $jitter ms，丢包 $loss%（$received/$sent 个响应）';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return '繁忙时的响应时间：$ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return '繁忙时的响应时间：$ms ms（空闲时的 $ratio 倍）';
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
    return '本次诊断使用的总数据量：$traffic';
  }

  @override
  String get logTotalCovers => '该总量涵盖上面的所有测试，不仅仅是速度测试';

  @override
  String logTrafficSent(String size) {
    return '发送 $size';
  }

  @override
  String logTrafficReceived(String size) {
    return '接收 $size';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get homeTitle => '網路不能用？\n不穩定？只能部分使用？';

  @override
  String get homeDiagnoseButton => '找出問題並提供解決方案';

  @override
  String get homeUrlPrompt => '某個特定網站或服務無法使用？\n在這裡貼上它的連結（網址）：';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => '檢查';

  @override
  String get homeSettingsTooltip => '設定';

  @override
  String get homeRunningDiagnosis => '正在進行全面檢查…';

  @override
  String get homeRunningUrlCheck => '正在檢查網站…';

  @override
  String get homeCheckFailedTitle => '檢查未能完成';

  @override
  String get homeUnknownError => '未知錯誤';

  @override
  String get homeTryAgain => '重試';

  @override
  String get commonBack => '返回';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageCaption => '整個應用程式均已翻譯，包括診斷結果及其技術詳情。';

  @override
  String get settingsTheme => '主題';

  @override
  String get settingsThemeSystem => '系統';

  @override
  String get settingsThemeLight => '淺色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsFontSize => '字體大小';

  @override
  String get settingsFontSmall => '小';

  @override
  String get settingsFontNormal => '正常';

  @override
  String get settingsFontLarge => '大';

  @override
  String get settingsCheckForUpdate => '檢查更新';

  @override
  String get settingsBuyMeACoffee => '請我喝杯咖啡';

  @override
  String get resultWhatToDo => '該怎麼做';

  @override
  String get resultDialogNotNow => '暫不';

  @override
  String get resultDialogYes => '是';

  @override
  String get resultNothingToOpen => '此步驟沒有可開啟的內容。';

  @override
  String resultActionFailed(String error) {
    return '無法完成該操作：$error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return '您的網路能做什麼（共 $total 項，符合 $fits 項）';
  }

  @override
  String get resultUploadNotMeasured => '無法測量上傳速度，因此未作評估。';

  @override
  String get techDetailsTitle => '技術詳情';

  @override
  String get techDetailsCopy => '複製';

  @override
  String get techDetailsCopied => '技術詳情已複製。';

  @override
  String get urlOpenInBrowser => '在瀏覽器中開啟';

  @override
  String get urlCheckAnother => '檢查其他網址';

  @override
  String get urlCouldNotOpenBrowser => '無法開啟瀏覽器。';

  @override
  String urlCouldNotOpen(String error) {
    return '無法開啟：$error';
  }

  @override
  String get urlNothingToTestAgain => '沒有可重新測試的內容。';

  @override
  String urlCouldNotOpenSettings(String error) {
    return '無法開啟設定：$error';
  }

  @override
  String get crossMediumTestOverMobile => '改用行動數據測試';

  @override
  String get crossMediumTestOverWifi => '改用 Wi-Fi 測試';

  @override
  String get crossMediumHintMobile => '關閉 Wi-Fi，然後返回——檢查會自動重新執行。';

  @override
  String get crossMediumHintWifi => '開啟 Wi-Fi，然後返回——檢查會自動重新執行。';

  @override
  String get verdictFlightModeTitle => '您處於飛航模式';

  @override
  String get verdictFlightModeDetail => '無線功能已關閉，因此在飛航模式開啟期間，任何內容都無法連上網際網路。';

  @override
  String get solutionFlightModeMessage => '關閉飛航模式，然後再試一次。';

  @override
  String get verdictNotConnectedTitle => '未連線到任何網路';

  @override
  String get verdictNotConnectedDetail => 'Wi-Fi 和行動數據似乎都已關閉，因此無法連上網際網路。';

  @override
  String get solutionNotConnectedMessage => '開啟 Wi-Fi 或行動數據，然後再試一次。';

  @override
  String get verdictRouterNotRespondingTitle => '路由器沒有回應';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return '您已連線到網路，但 $where 沒有回應。它可能已當機或斷電。';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return '您的路由器（$gateway）';
  }

  @override
  String get verdictRouterWhereUnnamed => '您的路由器';

  @override
  String get solutionRouterNotRespondingMessage =>
      '重新啟動路由器：拔掉電源，等待 30 秒，重新插上，並給它大約 2-5 分鐘啟動。然後重新執行測試。';

  @override
  String get verdictCaptivePortalTitle => '需要登入（強制入口網頁）';

  @override
  String get verdictCaptivePortalDetail =>
      '網路要求您在網頁上登入或接受條款後才允許上網——在飯店、咖啡廳和機場很常見。';

  @override
  String get solutionCaptivePortalMessage => '開啟登入頁面並完成登入，然後重新執行測試。';

  @override
  String get verdictNoInternetMobileTitle => '已連線行動數據，但沒有網際網路';

  @override
  String get verdictNoInternetMobileDetail =>
      '您的手機在基本層面能連上網路，但沒有通往網際網路的可用路徑。這表示問題出在電信業者的網路，而不是您的手機。';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. 開關一次飛航模式，或重新啟動手機，以重新連線到新的基地台。\n2. 如果 2-5 分鐘後測試仍失敗，請聯絡您的行動電信業者——故障在他們那邊。';

  @override
  String get verdictNoInternetIspTitle => '已連線路由器，但沒有網際網路';

  @override
  String get verdictNoInternetIspDetail =>
      '您的路由器正常，但與您的網際網路服務供應商（ISP）之間沒有可用連線。問題出在您家之外。';

  @override
  String get solutionNoInternetIspMessage =>
      '1. 檢查路由器是否連接到牆上的電話/DSL 插座。\n2. 檢查纜線沒有損壞或鬆脫。\n3. 如果您有市話，拿起話筒聽撥號音。如果聽不到撥號音，請聯絡電話公司和/或網際網路服務供應商修復線路。\n4. 重新啟動路由器一次以重新建立 ISP 連線。如果 2-5 分鐘後測試仍失敗，請聯絡您的網際網路服務供應商——故障在他們那邊。';

  @override
  String get verdictMobileNoDataTitle => '行動數據已連線但無法運作';

  @override
  String get verdictMobileNoDataDetail =>
      '您的手機在行動網路上，但沒有資料通過。這通常表示資料漫遊已關閉、方案流量已用完，或電信業者發生局部故障。';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. 如果您在國外或使用其他網路，請在行動網路設定中開啟資料漫遊。\n2. 檢查您的方案是否還有剩餘流量。\n3. $reception\n4. 如果仍失敗，請聯絡您的行動電信業者。';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': '關閉行動數據後再重新開啟。',
      'weak': '您的訊號較弱：移動到訊號較好的位置，然後關閉行動數據再重新開啟。',
      'other': '移動到訊號較好的位置，或關閉行動數據再重新開啟。',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS 問題';

  @override
  String get verdictDnsProblemDetail =>
      '網際網路可連上，但網站名稱沒有被解析為位址。這是 DNS 問題，通常切換到公共 DNS 解析器即可輕鬆解決。';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. 將您的私人 DNS 切換為可靠的公共解析器，例如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然後重新測試。\n2. 如果仍失敗，關閉行動數據後再開啟，或重新啟動手機，以取得新的連線。\n3. 如果仍失敗，請聯絡您的行動電信業者——有些業者自建 DNS 解析器，本身也會出故障。';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. 將您的私人 DNS 切換為可靠的公共解析器，例如 1.1.1.1（Cloudflare）或 8.8.8.8（Google），然後重新測試。\n2. 如果您在受管網路中（公司、學校、公共 Wi-Fi），請聯絡網路管理員修復 DNS。\n3. 如果您在自己的網路中，檢查路由器設定。最好也把次要 DNS 設為公共解析器（例如 1.1.1.1、4.4.4.4、4.4.2.2、8.8.8.8），以防主要（您的網際網路服務供應商）發生故障。';

  @override
  String verdictPortBlockedTitle(String port) {
    return '連接埠 $port 遭封鎖';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return '一般網際網路存取正常，但連接埠 $port 上的 $service 流量遭到封鎖——很可能是這個網路的防火牆所致。依賴此連接埠的一些應用程式將無法運作。';
  }

  @override
  String get solutionPortBlockedMobile =>
      '您的行動電信業者很可能依政策封鎖了它——請改用 Wi-Fi 或 VPN，或者如果您需要在行動網路上開放此連接埠，請聯絡業者。';

  @override
  String solutionPortBlockedFixed(String port) {
    return '如果您目前連線的是受管網路（公司、學校、公共 Wi-Fi），連接埠 $port 依政策遭封鎖——請改用行動數據或 VPN。在您自己的網路中，檢查路由器設定裡的防火牆規則。';
  }

  @override
  String get verdictIspPathMobileTitle => '您的電信業者處出現網路路徑問題';

  @override
  String get verdictIspPathIspTitle => '您的 ISP 處出現網路路徑問題';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return '您的連線能到達網際網路，但流量在途中停止，在 $hop 之後。故障在您的行動電信業者或骨幹路由上，而不在您的手機上。';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return '您的連線能到達網際網路，但流量在途中停止，在 $hop 之後。故障在您的網際網路服務供應商或骨幹路由上，而不在您的裝置或路由器上。';
  }

  @override
  String get verdictIspPathHopGenericMobile => '您的行動電信業者內部的某個躍點';

  @override
  String get verdictIspPathHopGenericFixed => '您的網際網路服務供應商內部的某個躍點';

  @override
  String get solutionIspPathMessageMobile =>
      '您的裝置或網路沒有需要修復的地方。請把故障路由回報給您的行動電信業者（說明 traceroute 在半路中斷）。通常他們修好路由後就會恢復。';

  @override
  String get solutionIspPathMessageFixed =>
      '您的裝置或網路沒有需要修復的地方。請把故障路由回報給您的網際網路服務供應商（說明 traceroute 在半路中斷）。通常他們修好路由後就會恢復。';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return '您的$medium足以應付$uses——還能更多';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured 如果仍然覺得有問題，最可能是某個應用程式或網站，而不是您的連線。';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return '除了$failing，您的$medium足以應付其他一切';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return '您的$medium對$failing來說太弱了';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '透過$medium測得：\n下載 $down Mbps，上傳 $up Mbps。';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '透過$medium測得：\n下載 $down Mbps。';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '透過$medium測得：\n上傳 $up Mbps。';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '透過$medium測得。';
  }

  @override
  String get verdictUploadNotAssessed => '上傳測試無法執行，因此未作評估。';

  @override
  String get verdictCauseGatewayWeak =>
      '您的路由器回應緩慢或掉封包，這指向 Wi-Fi 本身，而不是您的服務供應商。';

  @override
  String get verdictCauseSaturated =>
      '連線繁忙時會明顯變慢。您網路上的其他人或其他裝置（下載、備份、電視）正在占用線路。';

  @override
  String get verdictCauseThroughput => '連線速度不足。可能是您的網際網路方案太慢，或服務供應商在限速。';

  @override
  String get verdictCauseGeneric => '回應時間和封包遺失波動過大，不適合要求最高的即時應用。';

  @override
  String get adviceMoveCloser => '靠近路由器，或者如果您的路由器提供 5 GHz 網路，試試該網路。';

  @override
  String get advicePauseTheHog =>
      '找出誰或什麼正在大量占用線路，並請對方暫停。否則就等待，或重新啟動您的 Wi-Fi——這也會切斷他們的連線。';

  @override
  String get adviceDropTheCamera => '關閉攝影機——您的連線仍可傳輸音訊。';

  @override
  String get actionTestAgain => '重新測試';

  @override
  String get actionTestAgainWifi => '透過 Wi-Fi 重新測試';

  @override
  String get actionTestAgainMobile => '透過行動數據重新測試';

  @override
  String get actionTurnOnWifi => '開啟 Wi-Fi';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi 已關閉。開啟設定以啟用它？';

  @override
  String get actionTurnOnMobileData => '開啟行動數據';

  @override
  String get confirmTurnOnMobileData => '行動數據已關閉。開啟設定以啟用它？';

  @override
  String get actionOpenFlightSettings => '開啟飛航模式設定';

  @override
  String get confirmFlightMode => '您處於飛航模式。開啟設定以關閉它？';

  @override
  String get actionOpenSignInPage => '開啟登入頁面';

  @override
  String get confirmCaptivePortal => '您被一個登入頁面擋住了。現在開啟它？';

  @override
  String get actionOpenMobileDataSettings => '開啟行動數據設定';

  @override
  String get confirmMobileDataSettings => '開啟行動數據設定以檢查漫遊和流量？';

  @override
  String get actionOpenPrivateDns => '開啟私人 DNS 設定';

  @override
  String get confirmPrivateDns => '開啟私人 DNS 設定以便切換到 1.1.1.1？';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': '行動數據',
      'ethernet': '有線連線',
      'vpn': 'VPN 連線',
      'other': '連線',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': '音樂串流',
      'voiceCalls': '語音通話',
      'webBrowsing': '網頁瀏覽',
      'losslessMusic': '無損音樂',
      'videoCalls720': '視訊通話（720p）',
      'teamGames': '團隊遊戲',
      'videoCallsHd': '視訊通話（HD）',
      'hdVideo': '高畫質影片（1080p）',
      'fastGames': '快節奏線上遊戲',
      'video4k': '4K 影片',
      'other': '此項活動',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => '任何高需求的用途';

  @override
  String listTwo(String a, String b) {
    return '$a和$b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head和$last';
  }

  @override
  String shortfallDownload(String value) {
    return '下載 $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return '上傳 $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return '延遲 $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return '抖動 $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return '封包遺失 $value%';
  }

  @override
  String get logHeadDeviceLink => '裝置連線';

  @override
  String get logHeadRouter => '路由器';

  @override
  String get logHeadInternetReachability => '網際網路可達性';

  @override
  String get logHeadPorts => '連接埠';

  @override
  String get logHeadPopularSites => '熱門網站';

  @override
  String get logHeadMeasurements => '測量';

  @override
  String get logHeadGoodFor => '適合';

  @override
  String get logHeadNotGoodFor => '不足以支援';

  @override
  String logHeadTestsPerformed(int count) {
    return '已執行的測試（$count）';
  }

  @override
  String get logYes => '是';

  @override
  String get logNo => '否';

  @override
  String get logUnknown => '未知';

  @override
  String get logNotApplicable => '不適用';

  @override
  String get logNotMeasured => '未測量';

  @override
  String get logNotReported => '未回報';

  @override
  String logConnectivity(String kind, String flight) {
    return '連線方式：$kind，飛航模式：$flight';
  }

  @override
  String get logFlightOn => '開 ✈️';

  @override
  String get logFlightOff => '關 ✅';

  @override
  String logGateway(String value) {
    return '閘道：$value';
  }

  @override
  String logGatewayReachable(String answer) {
    return '閘道可達：$answer';
  }

  @override
  String logInternet(String state) {
    return '網際網路：$state';
  }

  @override
  String get logInternetReachableYes => '可達 ✅';

  @override
  String get logInternetReachableNo => '無回應 ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return '強制入口登入頁面：$answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return '原始 IP 位址可達：$answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return '名稱解析（$host）：$answer';
  }

  @override
  String logRouteReached(String answer) {
    return '路由到達網際網路：$answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return '路由到達網際網路：$answer（最後躍點：$hop）';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return '連接埠 $port/$service：$state';
  }

  @override
  String get logPortOpen => '開放 ✅';

  @override
  String get logPortBlocked => '遭封鎖 ❌';

  @override
  String logPopularCountry(String value) {
    return '國家/地區：$value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return '可達的熱門網站：$reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return '測試所用：$medium';
  }

  @override
  String get logMobileMeasuredReason =>
      '測量了行動數據，因為它是正在使用的連線（未連線 Wi-Fi，或您選擇了透過行動網路重新測試）';

  @override
  String logCellularSignalReported(int level) {
    return '行動訊號：4 格中的 $level';
  }

  @override
  String get logCellularSignalMissing => '行動訊號：未回報';

  @override
  String logDownloadLine(String value) {
    return '下載：$value';
  }

  @override
  String logUploadLine(String value) {
    return '上傳：$value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return '速度測試傳輸量：接收 $received，傳送 $sent';
  }

  @override
  String get logLabelRouter => '路由器';

  @override
  String get logLabelInternet => '網際網路';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label回應時間：$sent 個探測無回應';
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
    return '$label回應時間：平均 $avg ms（最小 $min，最大 $max），抖動 $jitter ms，遺失 $loss%（$received/$sent 個回應）';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return '繁忙時的回應時間：$ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return '繁忙時的回應時間：$ms ms（閒置時的 $ratio 倍）';
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
    return '本次診斷使用的總資料量：$traffic';
  }

  @override
  String get logTotalCovers => '該總量涵蓋上面的所有測試，不僅僅是速度測試';

  @override
  String logTrafficSent(String size) {
    return '傳送 $size';
  }

  @override
  String logTrafficReceived(String size) {
    return '接收 $size';
  }
}
