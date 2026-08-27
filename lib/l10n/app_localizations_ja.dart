// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get homeTitle => 'インターネットに接続できませんか?\n不安定、または一部だけ使える場合は?';

  @override
  String get homeDiagnoseButton => '問題を見つけて解決方法を提示';

  @override
  String get homeUrlPrompt =>
      '特定のウェブサイトやサービスが使えませんか?\nそのリンク（URL）をここに貼り付けてください:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => '確認する';

  @override
  String get homeSettingsTooltip => '設定';

  @override
  String get homeRunningDiagnosis => '総合チェックを実行中…';

  @override
  String get homeRunningUrlCheck => 'ウェブサイトを確認中…';

  @override
  String get homeCheckFailedTitle => 'チェックを完了できませんでした';

  @override
  String get homeUnknownError => '不明なエラー';

  @override
  String get homeTryAgain => '再試行';

  @override
  String get commonBack => '戻る';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageCaption => '診断結果とその技術的な詳細を含め、アプリ全体が翻訳されています。';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSystem => 'システム';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsFontSize => '文字サイズ';

  @override
  String get settingsFontSmall => '小';

  @override
  String get settingsFontNormal => '標準';

  @override
  String get settingsFontLarge => '大';

  @override
  String get settingsCheckForUpdate => 'アップデートを確認';

  @override
  String get settingsBuyMeACoffee => 'コーヒーをおごる';

  @override
  String get resultWhatToDo => '対応方法';

  @override
  String get resultDialogNotNow => '後で';

  @override
  String get resultDialogYes => 'はい';

  @override
  String get resultNothingToOpen => 'この手順で開くものはありません。';

  @override
  String resultActionFailed(String error) {
    return 'この操作を完了できませんでした: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'お使いの回線でできること（$total件中$fits件）';
  }

  @override
  String get resultUploadNotMeasured => 'アップロード速度を測定できなかったため、評価できませんでした。';

  @override
  String get techDetailsTitle => '技術的な詳細';

  @override
  String get techDetailsCopy => 'コピー';

  @override
  String get techDetailsCopied => '技術的な詳細をコピーしました。';

  @override
  String get urlOpenInBrowser => 'ブラウザで開く';

  @override
  String get urlCheckAnother => '別のサイトを確認';

  @override
  String get urlCouldNotOpenBrowser => 'ブラウザを開けませんでした。';

  @override
  String urlCouldNotOpen(String error) {
    return '開けませんでした: $error';
  }

  @override
  String get urlNothingToTestAgain => '再テストするものがありません。';

  @override
  String urlCouldNotOpenSettings(String error) {
    return '設定を開けませんでした: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'モバイルデータで再テスト';

  @override
  String get crossMediumTestOverWifi => 'Wi-Fiで再テスト';

  @override
  String get crossMediumHintMobile => 'Wi-Fiをオフにしてから戻ってください。チェックは自動的に再実行されます。';

  @override
  String get crossMediumHintWifi => 'Wi-Fiをオンにしてから戻ってください。チェックは自動的に再実行されます。';

  @override
  String get verdictFlightModeTitle => '機内モードになっています';

  @override
  String get verdictFlightModeDetail =>
      '無線がオフになっているため、機内モードの間はどこにもインターネットに接続できません。';

  @override
  String get solutionFlightModeMessage => '機内モードをオフにして、もう一度お試しください。';

  @override
  String get verdictNotConnectedTitle => 'どのネットワークにも接続していません';

  @override
  String get verdictNotConnectedDetail =>
      'Wi-Fi とモバイルデータの両方がオフのようです。インターネットに接続する手段がありません。';

  @override
  String get solutionNotConnectedMessage =>
      'Wi-Fi またはモバイルデータをオンにして、もう一度お試しください。';

  @override
  String get verdictRouterNotRespondingTitle => 'ルーターが応答していません';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'ネットワークには接続していますが、$where が応答していません。クラッシュしたか、電源が落ちた可能性があります。';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'お使いのルーター（$gateway）';
  }

  @override
  String get verdictRouterWhereUnnamed => 'お使いのルーター';

  @override
  String get solutionRouterNotRespondingMessage =>
      'ルーターを再起動してください。電源プラグを抜き、30 秒待ってから差し直し、起動に 2〜5 分ほどかけさせます。その後、テストをもう一度実行してください。';

  @override
  String get verdictCaptivePortalTitle => 'サインインが必要です（キャプティブポータル）';

  @override
  String get verdictCaptivePortalDetail =>
      'ネットワークが、オンラインにする前に Web ページでのサインインや規約への同意を求めています。ホテル、カフェ、空港でよくあります。';

  @override
  String get solutionCaptivePortalMessage =>
      'サインインページを開いてログインを完了し、その後テストをもう一度実行してください。';

  @override
  String get verdictNoInternetMobileTitle => 'モバイルデータに接続していますが、インターネットがありません';

  @override
  String get verdictNoInternetMobileDetail =>
      'スマートフォンは基本的なレベルではネットワークに到達していますが、インターネットへの有効な経路がありません。これはスマートフォンではなく、通信事業者のネットワーク側の問題を示しています。';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. 機内モードをオン・オフするか、スマートフォンを再起動して、新しい基地局に接続し直します。\n2. 2〜5 分たってもテストが失敗する場合は、モバイル通信事業者に連絡してください。障害は事業者側にあります。';

  @override
  String get verdictNoInternetIspTitle => 'ルーターに接続していますが、インターネットがありません';

  @override
  String get verdictNoInternetIspDetail =>
      'ルーターは動作していますが、インターネットプロバイダー（ISP）への有効な接続がありません。問題はご自宅の外にあります。';

  @override
  String get solutionNoInternetIspMessage =>
      '1. ルーターが壁の電話／DSL ジャックに接続されているか確認します。\n2. ケーブルが破損したり緩んだりしていないか確認します。\n3. 固定電話がある場合は受話器を取り、発信音を聞いてください。発信音が聞こえない場合は、回線を修理してもらうため電話会社やインターネットプロバイダーに連絡します。\n4. ISP との接続を確立し直すため、ルーターを一度再起動します。2〜5 分たってもテストが失敗する場合は、インターネットプロバイダーに連絡してください。障害はプロバイダー側にあります。';

  @override
  String get verdictMobileNoDataTitle => 'モバイルデータは接続されていますが動作していません';

  @override
  String get verdictMobileNoDataDetail =>
      'スマートフォンはモバイルネットワーク上にありますが、データが通っていません。通常は、データローミングがオフ、データ容量を使い切っている、または通信事業者に局地的な障害がある、のいずれかです。';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. 海外や別のネットワークにいる場合は、モバイル設定でデータローミングをオンにします。\n2. プランのデータ容量がまだ残っているか確認します。\n3. $reception\n4. それでも失敗する場合は、モバイル通信事業者に連絡してください。';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'モバイルデータをオフにしてから、もう一度オンにします。',
      'weak': '電波が弱いです。受信状態のよい場所へ移動し、モバイルデータをオフにしてから、もう一度オンにします。',
      'other': '電波のよい場所へ移動するか、モバイルデータをオフにしてから、もう一度オンにします。',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS の問題';

  @override
  String get verdictDnsProblemDetail =>
      'インターネットには到達できますが、Web サイト名がアドレスに変換されていません。これは DNS の問題で、通常はパブリック DNS リゾルバーに切り替えれば簡単に解決できます。';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. プライベート DNS を、1.1.1.1（Cloudflare）や 8.8.8.8（Google）などの信頼できるパブリックリゾルバーに切り替えて、もう一度テストします。\n2. それでも失敗する場合は、新しい接続を得るためにモバイルデータをオフ・オンするか、スマートフォンを再起動します。\n3. それでも失敗する場合は、モバイル通信事業者に連絡してください。事業者によっては独自の DNS リゾルバーを運用しており、それ自体に障害があることがあります。';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. プライベート DNS を、1.1.1.1（Cloudflare）や 8.8.8.8（Google）などの信頼できるパブリックリゾルバーに切り替えて、もう一度テストします。\n2. 管理されたネットワーク（職場、学校、公共 Wi-Fi）にいる場合は、DNS を修正してもらうためネットワーク管理者に連絡します。\n3. 自分のネットワークにいる場合は、ルーターの設定を確認します。プライマリ（インターネットプロバイダー）が失敗したときのために、セカンダリ DNS もパブリックリゾルバーに設定しておくとよいでしょう（例: 1.1.1.1、4.4.4.4、4.4.2.2、8.8.8.8）。';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'ポート $port がブロックされています';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return '一般的なインターネットアクセスは機能していますが、ポート $port 上の $service トラフィックがブロックされています。おそらくこのネットワークのファイアウォールによるものです。このポートに依存する一部のアプリは動作しません。';
  }

  @override
  String get solutionPortBlockedMobile =>
      'モバイル通信事業者がポリシーでブロックしている可能性が高いです。代わりに Wi-Fi または VPN を試すか、モバイル回線でこのポートを開ける必要がある場合は事業者に連絡してください。';

  @override
  String solutionPortBlockedFixed(String port) {
    return '現在、管理されたネットワーク（職場、学校、公共 Wi-Fi）に接続している場合、ポート $port はポリシーでブロックされています。代わりにモバイルデータまたは VPN を試してください。自分のネットワークでは、ルーター設定のファイアウォールルールを確認します。';
  }

  @override
  String get verdictIspPathMobileTitle => '通信事業者側でのネットワーク経路の問題';

  @override
  String get verdictIspPathIspTitle => 'ISP 側でのネットワーク経路の問題';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return '接続はインターネットに到達していますが、トラフィックが途中で止まっています（$hop の先）。障害はスマートフォンではなく、モバイル通信事業者またはバックボーン経路にあります。';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return '接続はインターネットに到達していますが、トラフィックが途中で止まっています（$hop の先）。障害はお使いの機器やルーターではなく、インターネットプロバイダーまたはバックボーン経路にあります。';
  }

  @override
  String get verdictIspPathHopGenericMobile => 'モバイル通信事業者内のあるホップ';

  @override
  String get verdictIspPathHopGenericFixed => 'インターネットプロバイダー内のあるホップ';

  @override
  String get solutionIspPathMessageMobile =>
      'お使いの機器やネットワークで直すものはありません。障害のある経路をモバイル通信事業者に報告してください（traceroute が途中で止まると伝えてください）。通常、経路が修正されれば解消します。';

  @override
  String get solutionIspPathMessageFixed =>
      'お使いの機器やネットワークで直すものはありません。障害のある経路をインターネットプロバイダーに報告してください（traceroute が途中で止まると伝えてください）。通常、経路が修正されれば解消します。';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'お使いの$mediumは$usesに十分で、それ以上にも対応できます';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured それでも調子が悪いと感じる場合、おそらく特定のアプリや Web サイトの問題で、接続の問題ではありません。';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'お使いの$mediumは$failing以外のすべてに十分です';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'お使いの$mediumは$failingには弱すぎます';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '$mediumで測定:\nダウンロード $down Mbps、アップロード $up Mbps。';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '$mediumで測定:\nダウンロード $down Mbps。';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '$mediumで測定:\nアップロード $up Mbps。';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '$mediumで測定。';
  }

  @override
  String get verdictUploadNotAssessed => 'アップロードテストを実行できなかったため、評価していません。';

  @override
  String get verdictCauseGatewayWeak =>
      'ルーターの応答が遅い、またはパケットを落としています。これはプロバイダーではなく Wi-Fi 自体を示しています。';

  @override
  String get verdictCauseSaturated =>
      '混雑しているときに接続が急激に遅くなります。ネットワーク上の誰か、または何か（ダウンロード、バックアップ、テレビ）が回線を使っています。';

  @override
  String get verdictCauseThroughput =>
      '接続速度が十分ではありません。インターネットプランが遅すぎるか、プロバイダーが回線を制限しています。';

  @override
  String get verdictCauseGeneric =>
      '応答時間とパケット損失の変動が大きすぎて、最も要求の厳しいリアルタイム用途には向きません。';

  @override
  String get adviceMoveCloser =>
      'ルーターに近づくか、ルーターが対応していれば 5 GHz のネットワークを試してください。';

  @override
  String get advicePauseTheHog =>
      '回線を大量に使っている人やものを特定し、一時停止してもらってください。難しい場合は待つか、Wi-Fi を再起動してください（相手の接続も切れます）。';

  @override
  String get adviceDropTheCamera => 'カメラをオフにしてください。接続は音声なら引き続き伝えられます。';

  @override
  String get actionTestAgain => 'もう一度テスト';

  @override
  String get actionTestAgainWifi => 'Wi-Fi でもう一度テスト';

  @override
  String get actionTestAgainMobile => 'モバイルデータでもう一度テスト';

  @override
  String get actionTurnOnWifi => 'Wi-Fi をオンにする';

  @override
  String get confirmTurnOnWifi => 'Wi-Fi がオフです。設定を開いてオンにしますか？';

  @override
  String get actionTurnOnMobileData => 'モバイルデータをオンにする';

  @override
  String get confirmTurnOnMobileData => 'モバイルデータがオフです。設定を開いてオンにしますか？';

  @override
  String get actionOpenFlightSettings => '機内モードの設定を開く';

  @override
  String get confirmFlightMode => '機内モードになっています。設定を開いてオフにしますか？';

  @override
  String get actionOpenSignInPage => 'サインインページを開く';

  @override
  String get confirmCaptivePortal => 'サインインページによってブロックされています。今すぐ開きますか？';

  @override
  String get actionOpenMobileDataSettings => 'モバイルデータの設定を開く';

  @override
  String get confirmMobileDataSettings => 'ローミングとデータを確認するため、モバイルデータの設定を開きますか？';

  @override
  String get actionOpenPrivateDns => 'プライベート DNS の設定を開く';

  @override
  String get confirmPrivateDns => '1.1.1.1 に切り替えられるよう、プライベート DNS の設定を開きますか？';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'モバイルデータ',
      'ethernet': '有線接続',
      'vpn': 'VPN 接続',
      'other': '接続',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': '音楽ストリーミング',
      'voiceCalls': '音声通話',
      'webBrowsing': 'Web ブラウジング',
      'losslessMusic': 'ロスレス音楽',
      'videoCalls720': 'ビデオ通話（720p）',
      'teamGames': 'チーム対戦ゲーム',
      'videoCallsHd': 'ビデオ通話（HD）',
      'hdVideo': 'HD 動画（1080p）',
      'fastGames': '高速オンラインゲーム',
      'video4k': '4K 動画',
      'other': 'この用途',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => '負荷の高い用途';

  @override
  String listTwo(String a, String b) {
    return '$aと$b';
  }

  @override
  String listAnd(String head, String last) {
    return '$headと$last';
  }

  @override
  String shortfallDownload(String value) {
    return 'ダウンロード $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'アップロード $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return '遅延 $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'ジッター $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'パケット損失 $value%';
  }

  @override
  String get logHeadDeviceLink => 'デバイスのリンク';

  @override
  String get logHeadRouter => 'ルーター';

  @override
  String get logHeadInternetReachability => 'インターネット到達性';

  @override
  String get logHeadPorts => 'ポート';

  @override
  String get logHeadPopularSites => '主要サイト';

  @override
  String get logHeadMeasurements => '測定';

  @override
  String get logHeadGoodFor => '対応可能';

  @override
  String get logHeadNotGoodFor => '不十分な用途';

  @override
  String logHeadTestsPerformed(int count) {
    return '実行したテスト（$count）';
  }

  @override
  String get logYes => 'はい';

  @override
  String get logNo => 'いいえ';

  @override
  String get logUnknown => '不明';

  @override
  String get logNotApplicable => '該当なし';

  @override
  String get logNotMeasured => '未測定';

  @override
  String get logNotReported => '報告なし';

  @override
  String logConnectivity(String kind, String flight) {
    return '接続: $kind、機内モード: $flight';
  }

  @override
  String get logFlightOn => 'オン ✈️';

  @override
  String get logFlightOff => 'オフ ✅';

  @override
  String logGateway(String value) {
    return 'ゲートウェイ: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'ゲートウェイ到達可能: $answer';
  }

  @override
  String logInternet(String state) {
    return 'インターネット: $state';
  }

  @override
  String get logInternetReachableYes => '到達可能 ✅';

  @override
  String get logInternetReachableNo => '応答なし ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'キャプティブサインインページ: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return '生の IP アドレス到達可能: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return '名前解決（$host）: $answer';
  }

  @override
  String logRouteReached(String answer) {
    return '経路がインターネットに到達: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return '経路がインターネットに到達: $answer（最終ホップ: $hop）';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'ポート $port/$service: $state';
  }

  @override
  String get logPortOpen => 'オープン ✅';

  @override
  String get logPortBlocked => 'ブロック ❌';

  @override
  String logPopularCountry(String value) {
    return '国: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return '到達可能な主要サイト: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return '測定に使用: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'モバイルデータが使用中のリンクのため測定しました（Wi-Fi 未接続、またはモバイルでの再テストを選択）';

  @override
  String logCellularSignalReported(int level) {
    return 'モバイル信号: 4 段階中 $level';
  }

  @override
  String get logCellularSignalMissing => 'モバイル信号: 報告なし';

  @override
  String logDownloadLine(String value) {
    return 'ダウンロード: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'アップロード: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return '速度テストで転送: 受信 $received、送信 $sent';
  }

  @override
  String get logLabelRouter => 'ルーター';

  @override
  String get logLabelInternet => 'インターネット';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$labelの応答時間: $sent 回のプローブに応答なし';
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
    return '$labelの応答時間: 平均 $avg ms（最小 $min、最大 $max）、ジッター $jitter ms、損失 $loss%（$received/$sent 応答）';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return '混雑時の応答時間: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return '混雑時の応答時間: $ms ms（アイドル時の $ratio 倍）';
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
    return 'この診断で使用した合計データ量: $traffic';
  }

  @override
  String get logTotalCovers => 'この合計は速度テストだけでなく、上のすべてのテストを含みます';

  @override
  String logTrafficSent(String size) {
    return '送信 $size';
  }

  @override
  String logTrafficReceived(String size) {
    return '受信 $size';
  }
}
