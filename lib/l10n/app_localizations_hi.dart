// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get homeTitle =>
      'इंटरनेट काम नहीं कर रहा?\nअस्थिर है? आंशिक रूप से काम कर रहा है?';

  @override
  String get homeDiagnoseButton => 'समस्या ढूंढें और समाधान बताएं';

  @override
  String get homeUrlPrompt =>
      'कोई खास वेबसाइट या सेवा काम नहीं कर रही?\nयहां उसका लिंक (URL) पेस्ट करें:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'जांचें';

  @override
  String get homeSettingsTooltip => 'सेटिंग्स';

  @override
  String get homeRunningDiagnosis => 'पूरी जांच चल रही है…';

  @override
  String get homeRunningUrlCheck => 'वेबसाइट जांची जा रही है…';

  @override
  String get homeCheckFailedTitle => 'जांच पूरी नहीं हो सकी';

  @override
  String get homeUnknownError => 'अज्ञात त्रुटि';

  @override
  String get homeTryAgain => 'फिर कोशिश करें';

  @override
  String get commonBack => 'वापस';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageCaption =>
      'पूरा ऐप अनुवादित है, जिसमें डायग्नोसिस के नतीजे और उनके तकनीकी विवरण भी शामिल हैं।';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsThemeSystem => 'सिस्टम';

  @override
  String get settingsThemeLight => 'हल्का';

  @override
  String get settingsThemeDark => 'गहरा';

  @override
  String get settingsFontSize => 'फ़ॉन्ट आकार';

  @override
  String get settingsFontSmall => 'छोटा';

  @override
  String get settingsFontNormal => 'सामान्य';

  @override
  String get settingsFontLarge => 'बड़ा';

  @override
  String get settingsCheckForUpdate => 'अपडेट देखें';

  @override
  String get settingsBuyMeACoffee => 'मुझे कॉफ़ी पिलाएं';

  @override
  String get resultWhatToDo => 'क्या करें';

  @override
  String get resultDialogNotNow => 'अभी नहीं';

  @override
  String get resultDialogYes => 'हां';

  @override
  String get resultNothingToOpen => 'इस चरण के लिए कुछ भी खोलने को नहीं है।';

  @override
  String resultActionFailed(String error) {
    return 'यह कार्रवाई पूरी नहीं हो सकी: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'आपका कनेक्शन क्या कर सकता है ($fits में से $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'अपलोड मापा नहीं जा सका, इसलिए उसका आकलन नहीं हुआ।';

  @override
  String get techDetailsTitle => 'तकनीकी विवरण';

  @override
  String get techDetailsCopy => 'कॉपी करें';

  @override
  String get techDetailsCopied => 'तकनीकी विवरण कॉपी हो गया।';

  @override
  String get urlOpenInBrowser => 'ब्राउज़र में खोलें';

  @override
  String get urlCheckAnother => 'दूसरा जांचें';

  @override
  String get urlCouldNotOpenBrowser => 'ब्राउज़र नहीं खुल सका।';

  @override
  String urlCouldNotOpen(String error) {
    return 'खोला नहीं जा सका: $error';
  }

  @override
  String get urlNothingToTestAgain => 'फिर से जांचने के लिए कुछ नहीं है।';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'सेटिंग्स नहीं खुल सकीं: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'मोबाइल डेटा पर जांचें';

  @override
  String get crossMediumTestOverWifi => 'Wi-Fi पर जांचें';

  @override
  String get crossMediumHintMobile =>
      'Wi-Fi बंद करें, फिर वापस आएं — जांच खुद ही फिर से चलेगी।';

  @override
  String get crossMediumHintWifi =>
      'Wi-Fi चालू करें, फिर वापस आएं — जांच खुद ही फिर से चलेगी।';

  @override
  String get verdictFlightModeTitle => 'आप फ़्लाइट मोड में हैं';

  @override
  String get verdictFlightModeDetail =>
      'वायरलेस बंद है, इसलिए जब तक फ़्लाइट मोड चालू है तब तक कुछ भी इंटरनेट तक नहीं पहुँच सकता।';

  @override
  String get solutionFlightModeMessage =>
      'फ़्लाइट मोड बंद करें, फिर दोबारा कोशिश करें।';

  @override
  String get verdictNotConnectedTitle => 'किसी भी नेटवर्क से कनेक्ट नहीं';

  @override
  String get verdictNotConnectedDetail =>
      'Wi-Fi और मोबाइल डेटा दोनों बंद लग रहे हैं, इसलिए इंटरनेट तक पहुँचने का कोई रास्ता नहीं है।';

  @override
  String get solutionNotConnectedMessage =>
      'Wi-Fi या मोबाइल डेटा चालू करें, फिर दोबारा कोशिश करें।';

  @override
  String get verdictRouterNotRespondingTitle => 'राउटर जवाब नहीं दे रहा';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'आप नेटवर्क से कनेक्ट हैं, लेकिन $where जवाब नहीं दे रहा। शायद वह क्रैश हो गया हो या बिजली चली गई हो।';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'आपका राउटर ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'आपका राउटर';

  @override
  String get solutionRouterNotRespondingMessage =>
      'अपना राउटर रीस्टार्ट करें: उसे प्लग से निकालें, 30 सेकंड रुकें, वापस लगाएँ, और उसे चालू होने में लगभग 2-5 मिनट दें। फिर टेस्ट दोबारा चलाएँ।';

  @override
  String get verdictCaptivePortalTitle => 'साइन-इन ज़रूरी (कैप्टिव पोर्टल)';

  @override
  String get verdictCaptivePortalDetail =>
      'नेटवर्क चाहता है कि आप ऑनलाइन जाने से पहले किसी वेब पेज पर साइन इन करें या शर्तें स्वीकार करें — होटल, कैफ़े और हवाई अड्डों में आम है।';

  @override
  String get solutionCaptivePortalMessage =>
      'साइन-इन पेज खोलें और लॉगिन पूरा करें, फिर टेस्ट दोबारा चलाएँ।';

  @override
  String get verdictNoInternetMobileTitle =>
      'मोबाइल डेटा से कनेक्ट, लेकिन इंटरनेट नहीं';

  @override
  String get verdictNoInternetMobileDetail =>
      'आपका फ़ोन नेटवर्क तक बुनियादी स्तर पर पहुँचता है, लेकिन इंटरनेट तक कोई काम करने वाला रास्ता नहीं है। यह आपके फ़ोन की नहीं, आपके ऑपरेटर के नेटवर्क की समस्या की ओर इशारा करता है।';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. फ़्लाइट मोड चालू-बंद करें, या फ़ोन रीस्टार्ट करें, ताकि नए टावर से दोबारा कनेक्ट हो सके।\n2. अगर 2-5 मिनट बाद भी टेस्ट फ़ेल होता रहे, तो अपने मोबाइल ऑपरेटर से संपर्क करें — गड़बड़ी उनकी तरफ़ है।';

  @override
  String get verdictNoInternetIspTitle => 'राउटर से कनेक्ट, लेकिन इंटरनेट नहीं';

  @override
  String get verdictNoInternetIspDetail =>
      'आपका राउटर काम कर रहा है, लेकिन आपके इंटरनेट प्रदाता (ISP) से उसका कोई काम करने वाला कनेक्शन नहीं है। समस्या आपके घर के बाहर है।';

  @override
  String get solutionNoInternetIspMessage =>
      '1. जाँचें कि आपका राउटर दीवार के फ़ोन/DSL सॉकेट से जुड़ा है या नहीं।\n2. जाँचें कि केबल क्षतिग्रस्त या ढीली तो नहीं है।\n3. अगर आपके पास लैंडलाइन फ़ोन है, तो रिसीवर उठाएँ और डायल टोन सुनें। अगर डायल टोन न सुनाई दे, तो अपनी लाइन ठीक कराने के लिए अपनी फ़ोन कंपनी और/या इंटरनेट प्रदाता से संपर्क करें।\n4. ISP लिंक फिर से जोड़ने के लिए राउटर एक बार रीस्टार्ट करें। अगर 2-5 मिनट बाद भी टेस्ट फ़ेल होता रहे, तो अपने इंटरनेट प्रदाता से संपर्क करें — गड़बड़ी उनकी तरफ़ है।';

  @override
  String get verdictMobileNoDataTitle =>
      'मोबाइल डेटा कनेक्ट है पर काम नहीं कर रहा';

  @override
  String get verdictMobileNoDataDetail =>
      'आपका फ़ोन सेलुलर नेटवर्क पर है, लेकिन कोई डेटा नहीं आ-जा रहा। आमतौर पर इसका मतलब है कि डेटा रोमिंग बंद है, आपका डेटा कोटा खत्म हो गया है, या आपके ऑपरेटर के यहाँ स्थानीय गड़बड़ी है।';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. अगर आप विदेश में हैं या किसी दूसरे नेटवर्क पर हैं, तो मोबाइल सेटिंग में डेटा रोमिंग चालू करें।\n2. जाँचें कि आपके प्लान में अभी भी डेटा बचा है।\n3. $reception\n4. अगर फिर भी फ़ेल हो, तो अपने मोबाइल ऑपरेटर से संपर्क करें।';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'मोबाइल डेटा बंद करके दोबारा चालू करें।',
      'weak':
          'आपका सिग्नल कमज़ोर है: बेहतर रिसेप्शन वाली जगह जाएँ और मोबाइल डेटा बंद करके दोबारा चालू करें।',
      'other':
          'बेहतर सिग्नल वाली जगह जाएँ, या मोबाइल डेटा बंद करके दोबारा चालू करें।',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'DNS समस्या';

  @override
  String get verdictDnsProblemDetail =>
      'इंटरनेट पहुँच में है, लेकिन वेबसाइट के नाम पतों में नहीं बदले जा रहे। यह एक DNS समस्या है और आमतौर पर किसी सार्वजनिक DNS रिज़ॉल्वर पर स्विच करके आसानी से ठीक हो जाती है।';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. अपना Private DNS किसी भरोसेमंद सार्वजनिक रिज़ॉल्वर पर सेट करें, जैसे 1.1.1.1 (Cloudflare) या 8.8.8.8 (Google), फिर दोबारा टेस्ट करें।\n2. अगर फिर भी फ़ेल हो, तो नया कनेक्शन पाने के लिए मोबाइल डेटा बंद करके दोबारा चालू करें, या फ़ोन रीस्टार्ट करें।\n3. अगर फिर भी फ़ेल हो, तो अपने मोबाइल ऑपरेटर से संपर्क करें — कुछ ऑपरेटर अपने खुद के DNS रिज़ॉल्वर चलाते हैं जिनमें खुद गड़बड़ी होती है।';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. अपना Private DNS किसी भरोसेमंद सार्वजनिक रिज़ॉल्वर पर सेट करें, जैसे 1.1.1.1 (Cloudflare) या 8.8.8.8 (Google), फिर दोबारा टेस्ट करें।\n2. अगर आप किसी प्रबंधित नेटवर्क पर हैं (काम, स्कूल, सार्वजनिक Wi-Fi), तो DNS ठीक कराने के लिए नेटवर्क एडमिनिस्ट्रेटर से संपर्क करें।\n3. अगर आप अपने नेटवर्क पर हैं, तो अपनी राउटर सेटिंग जाँचें। सेकंडरी DNS को भी किसी सार्वजनिक रिज़ॉल्वर पर सेट करना अच्छा रहता है (उदाहरण: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), ताकि प्राइमरी (आपका इंटरनेट प्रदाता) फ़ेल होने पर काम चलता रहे।';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'पोर्ट $port ब्लॉक है';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'सामान्य इंटरनेट पहुँच काम कर रही है, लेकिन पोर्ट $port पर $service ट्रैफ़िक ब्लॉक हो रहा है — संभवतः इस नेटवर्क की फ़ायरवॉल द्वारा। इस पोर्ट पर निर्भर कुछ ऐप्स काम नहीं करेंगे।';
  }

  @override
  String get solutionPortBlockedMobile =>
      'आपका मोबाइल ऑपरेटर संभवतः इसे नीति के तहत ब्लॉक कर रहा है — इसके बजाय Wi-Fi या VPN आज़माएँ, या अगर आपको सेलुलर पर यह पोर्ट खुला चाहिए तो अपने ऑपरेटर से संपर्क करें।';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'अगर आप अभी किसी प्रबंधित नेटवर्क से जुड़े हैं (काम, स्कूल, सार्वजनिक Wi-Fi), तो पोर्ट $port नीति के तहत ब्लॉक है — इसके बजाय मोबाइल डेटा या VPN आज़माएँ। अपने नेटवर्क पर, राउटर सेटिंग में फ़ायरवॉल नियम जाँचें।';
  }

  @override
  String get verdictIspPathMobileTitle => 'आपके ऑपरेटर पर नेटवर्क पथ समस्या';

  @override
  String get verdictIspPathIspTitle => 'आपके ISP पर नेटवर्क पथ समस्या';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'आपका कनेक्शन इंटरनेट तक पहुँचता है लेकिन ट्रैफ़िक रास्ते में रुक जाता है, $hop के बाद। गड़बड़ी आपके मोबाइल ऑपरेटर या बैकबोन रूट पर है, आपके फ़ोन पर नहीं।';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'आपका कनेक्शन इंटरनेट तक पहुँचता है लेकिन ट्रैफ़िक रास्ते में रुक जाता है, $hop के बाद। गड़बड़ी आपके इंटरनेट प्रदाता या बैकबोन रूट पर है, आपके डिवाइस या राउटर पर नहीं।';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'आपके मोबाइल ऑपरेटर के अंदर के किसी हॉप';

  @override
  String get verdictIspPathHopGenericFixed =>
      'आपके इंटरनेट प्रदाता के अंदर के किसी हॉप';

  @override
  String get solutionIspPathMessageMobile =>
      'आपके डिवाइस या आपके नेटवर्क में ठीक करने को कुछ नहीं है। खराब रूट की सूचना अपने मोबाइल ऑपरेटर को दें (बताएँ कि traceroute बीच में ही रुक जाता है)। आमतौर पर रूट ठीक होते ही यह हल हो जाता है।';

  @override
  String get solutionIspPathMessageFixed =>
      'आपके डिवाइस या आपके नेटवर्क में ठीक करने को कुछ नहीं है। खराब रूट की सूचना अपने इंटरनेट प्रदाता को दें (बताएँ कि traceroute बीच में ही रुक जाता है)। आमतौर पर रूट ठीक होते ही यह हल हो जाता है।';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'आपका $medium $uses के लिए अच्छा है — और उससे ज़्यादा के लिए भी';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured अगर फिर भी कुछ गड़बड़ लगे, तो सबसे ज़्यादा संभावना है कि यह कोई एक ऐप या वेबसाइट है — आपका कनेक्शन नहीं।';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'आपका $medium $failing को छोड़कर हर चीज़ के लिए अच्छा है';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'आपका $medium $failing के लिए बहुत कमज़ोर है';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return '$medium पर मापा गया:\nडाउनलोड $down Mbps, अपलोड $up Mbps।';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return '$medium पर मापा गया:\nडाउनलोड $down Mbps।';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return '$medium पर मापा गया:\nअपलोड $up Mbps।';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return '$medium पर मापा गया।';
  }

  @override
  String get verdictUploadNotAssessed =>
      'अपलोड टेस्ट नहीं चल सका, इसलिए इसका आकलन नहीं हुआ।';

  @override
  String get verdictCauseGatewayWeak =>
      'आपका राउटर धीरे जवाब देता है या पैकेट गिराता है, जो आपके प्रदाता के बजाय खुद Wi-Fi की ओर इशारा करता है।';

  @override
  String get verdictCauseSaturated =>
      'व्यस्त रहने के दौरान कनेक्शन तेज़ी से धीमा हो जाता है। आपके नेटवर्क पर कोई और या कुछ और (कोई डाउनलोड, बैकअप, TV) लाइन इस्तेमाल कर रहा है।';

  @override
  String get verdictCauseThroughput =>
      'कनेक्शन की गति पर्याप्त नहीं है। या तो आपका इंटरनेट प्लान बहुत धीमा है या आपका प्रदाता लाइन को थ्रॉटल कर रहा है।';

  @override
  String get verdictCauseGeneric =>
      'सबसे मांग वाली रीयल-टाइम गतिविधियों के लिए रिस्पॉन्स टाइम और पैकेट लॉस बहुत ज़्यादा घटता-बढ़ता है।';

  @override
  String get adviceMoveCloser =>
      'राउटर के पास जाएँ, या अगर आपका राउटर 5 GHz नेटवर्क देता है तो वह आज़माएँ।';

  @override
  String get advicePauseTheHog =>
      'पता करें कि कौन या क्या लाइन बहुत इस्तेमाल कर रहा है और उसे रोकने को कहें। वरना इंतज़ार करें, या अपना Wi-Fi रीस्टार्ट करें — इससे उनका कनेक्शन भी कट जाता है।';

  @override
  String get adviceDropTheCamera =>
      'अपना कैमरा बंद करें — आपका कनेक्शन ऑडियो फिर भी ले जा सकता है।';

  @override
  String get actionTestAgain => 'फिर से टेस्ट करें';

  @override
  String get actionTestAgainWifi => 'Wi-Fi पर फिर से टेस्ट करें';

  @override
  String get actionTestAgainMobile => 'मोबाइल डेटा पर फिर से टेस्ट करें';

  @override
  String get actionTurnOnWifi => 'Wi-Fi चालू करें';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi बंद है। इसे चालू करने के लिए सेटिंग खोलें?';

  @override
  String get actionTurnOnMobileData => 'मोबाइल डेटा चालू करें';

  @override
  String get confirmTurnOnMobileData =>
      'मोबाइल डेटा बंद है। इसे चालू करने के लिए सेटिंग खोलें?';

  @override
  String get actionOpenFlightSettings => 'फ़्लाइट मोड सेटिंग खोलें';

  @override
  String get confirmFlightMode =>
      'आप फ़्लाइट मोड में हैं। इसे बंद करने के लिए सेटिंग खोलें?';

  @override
  String get actionOpenSignInPage => 'साइन-इन पेज खोलें';

  @override
  String get confirmCaptivePortal =>
      'आपको एक साइन-इन पेज ने रोका है। इसे अभी खोलें?';

  @override
  String get actionOpenMobileDataSettings => 'मोबाइल डेटा सेटिंग खोलें';

  @override
  String get confirmMobileDataSettings =>
      'रोमिंग और डेटा जाँचने के लिए मोबाइल डेटा सेटिंग खोलें?';

  @override
  String get actionOpenPrivateDns => 'Private DNS सेटिंग खोलें';

  @override
  String get confirmPrivateDns =>
      '1.1.1.1 पर स्विच करने के लिए Private DNS सेटिंग खोलें?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'मोबाइल डेटा',
      'ethernet': 'वायर्ड कनेक्शन',
      'vpn': 'VPN कनेक्शन',
      'other': 'कनेक्शन',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'म्यूज़िक स्ट्रीमिंग',
      'voiceCalls': 'वॉयस कॉल',
      'webBrowsing': 'वेब ब्राउज़िंग',
      'losslessMusic': 'लॉसलेस म्यूज़िक',
      'videoCalls720': 'वीडियो कॉल (720p)',
      'teamGames': 'टीम गेम',
      'videoCallsHd': 'वीडियो कॉल (HD)',
      'hdVideo': 'HD वीडियो (1080p)',
      'fastGames': 'तेज़ ऑनलाइन गेम',
      'video4k': '4K वीडियो',
      'other': 'यह गतिविधि',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'कोई भी मांग वाली चीज़';

  @override
  String listTwo(String a, String b) {
    return '$a और $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head और $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'डाउनलोड $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'अपलोड $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'लेटेंसी $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'जिटर $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'पैकेट लॉस $value%';
  }

  @override
  String get logHeadDeviceLink => 'डिवाइस लिंक';

  @override
  String get logHeadRouter => 'राउटर';

  @override
  String get logHeadInternetReachability => 'इंटरनेट पहुँच';

  @override
  String get logHeadPorts => 'पोर्ट';

  @override
  String get logHeadPopularSites => 'लोकप्रिय साइट';

  @override
  String get logHeadMeasurements => 'माप';

  @override
  String get logHeadGoodFor => 'इसके लिए अच्छा';

  @override
  String get logHeadNotGoodFor => 'इसके लिए पर्याप्त नहीं';

  @override
  String logHeadTestsPerformed(int count) {
    return 'किए गए टेस्ट ($count)';
  }

  @override
  String get logYes => 'हाँ';

  @override
  String get logNo => 'नहीं';

  @override
  String get logUnknown => 'अज्ञात';

  @override
  String get logNotApplicable => 'लागू नहीं';

  @override
  String get logNotMeasured => 'मापा नहीं गया';

  @override
  String get logNotReported => 'रिपोर्ट नहीं किया गया';

  @override
  String logConnectivity(String kind, String flight) {
    return 'कनेक्टिविटी: $kind, फ़्लाइट मोड: $flight';
  }

  @override
  String get logFlightOn => 'चालू ✈️';

  @override
  String get logFlightOff => 'बंद ✅';

  @override
  String logGateway(String value) {
    return 'गेटवे: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'गेटवे पहुँच में: $answer';
  }

  @override
  String logInternet(String state) {
    return 'इंटरनेट: $state';
  }

  @override
  String get logInternetReachableYes => 'पहुँच में ✅';

  @override
  String get logInternetReachableNo => 'कोई जवाब नहीं ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'कैप्टिव साइन-इन पेज: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'सीधा IP पता पहुँच में: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'नाम रिज़ॉल्व होता है ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'रूट इंटरनेट तक पहुँचा: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'रूट इंटरनेट तक पहुँचा: $answer (आखिरी हॉप: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'पोर्ट $port/$service: $state';
  }

  @override
  String get logPortOpen => 'खुला ✅';

  @override
  String get logPortBlocked => 'ब्लॉक ❌';

  @override
  String logPopularCountry(String value) {
    return 'देश: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'पहुँच में लोकप्रिय साइट: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'इस पर टेस्ट किया: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'मोबाइल डेटा को मापा गया क्योंकि यही इस्तेमाल में लिंक है (Wi-Fi कनेक्ट नहीं है, या आपने मोबाइल पर दोबारा टेस्ट चुना)';

  @override
  String logCellularSignalReported(int level) {
    return 'सेलुलर सिग्नल: 4 में से $level';
  }

  @override
  String get logCellularSignalMissing => 'सेलुलर सिग्नल: रिपोर्ट नहीं किया गया';

  @override
  String logDownloadLine(String value) {
    return 'डाउनलोड: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'अपलोड: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'स्पीड टेस्ट द्वारा भेजा-लिया गया: प्राप्त $received, भेजा $sent';
  }

  @override
  String get logLabelRouter => 'राउटर';

  @override
  String get logLabelInternet => 'इंटरनेट';

  @override
  String logLatencyNoReply(String label, int sent) {
    return '$label रिस्पॉन्स टाइम: $sent प्रोब का कोई जवाब नहीं';
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
    return '$label रिस्पॉन्स टाइम: औसत $avg ms (न्यूनतम $min, अधिकतम $max), जिटर $jitter ms, लॉस $loss% ($received/$sent जवाब)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'व्यस्त रहते हुए रिस्पॉन्स टाइम: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'व्यस्त रहते हुए रिस्पॉन्स टाइम: $ms ms (निष्क्रिय का $ratio×)';
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
    return 'इस डायग्नोसिस द्वारा इस्तेमाल कुल डेटा: $traffic';
  }

  @override
  String get logTotalCovers =>
      'यह कुल ऊपर के सभी टेस्ट को कवर करता है, सिर्फ़ स्पीड टेस्ट को नहीं';

  @override
  String logTrafficSent(String size) {
    return 'भेजा $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'प्राप्त $size';
  }
}
