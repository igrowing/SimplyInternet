// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get homeTitle =>
      'อินเทอร์เน็ตใช้งานไม่ได้ใช่ไหม?\nไม่เสถียร? ใช้งานได้บางส่วน?';

  @override
  String get homeDiagnoseButton => 'ค้นหาปัญหาและเสนอวิธีแก้ไข';

  @override
  String get homeUrlPrompt =>
      'เว็บไซต์หรือบริการใดบริการหนึ่งใช้งานไม่ได้ใช่ไหม?\nวางลิงก์ (URL) ไว้ที่นี่:';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'ตรวจสอบ';

  @override
  String get homeSettingsTooltip => 'การตั้งค่า';

  @override
  String get homeRunningDiagnosis => 'กำลังตรวจสอบอย่างละเอียด…';

  @override
  String get homeRunningUrlCheck => 'กำลังตรวจสอบเว็บไซต์…';

  @override
  String get homeCheckFailedTitle => 'การตรวจสอบไม่เสร็จสมบูรณ์';

  @override
  String get homeUnknownError => 'ข้อผิดพลาดที่ไม่ทราบสาเหตุ';

  @override
  String get homeTryAgain => 'ลองอีกครั้ง';

  @override
  String get commonBack => 'ย้อนกลับ';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsLanguageCaption =>
      'แอปทั้งหมดได้รับการแปลแล้ว รวมถึงผลการวินิจฉัยและรายละเอียดทางเทคนิค';

  @override
  String get settingsTheme => 'ธีม';

  @override
  String get settingsThemeSystem => 'ระบบ';

  @override
  String get settingsThemeLight => 'สว่าง';

  @override
  String get settingsThemeDark => 'มืด';

  @override
  String get settingsFontSize => 'ขนาดตัวอักษร';

  @override
  String get settingsFontSmall => 'เล็ก';

  @override
  String get settingsFontNormal => 'ปกติ';

  @override
  String get settingsFontLarge => 'ใหญ่';

  @override
  String get settingsCheckForUpdate => 'ตรวจสอบการอัปเดต';

  @override
  String get settingsBuyMeACoffee => 'เลี้ยงกาแฟฉันสักแก้ว';

  @override
  String get resultWhatToDo => 'สิ่งที่ควรทำ';

  @override
  String get resultDialogNotNow => 'ไว้ก่อน';

  @override
  String get resultDialogYes => 'ใช่';

  @override
  String get resultNothingToOpen => 'ไม่มีอะไรให้เปิดสำหรับขั้นตอนนี้';

  @override
  String resultActionFailed(String error) {
    return 'ไม่สามารถดำเนินการนี้ได้: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'การเชื่อมต่อของคุณทำอะไรได้บ้าง ($fits จาก $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'ไม่สามารถวัดความเร็วอัปโหลดได้ จึงไม่ได้ประเมินผล';

  @override
  String get techDetailsTitle => 'รายละเอียดทางเทคนิค';

  @override
  String get techDetailsCopy => 'คัดลอก';

  @override
  String get techDetailsCopied => 'คัดลอกรายละเอียดทางเทคนิคแล้ว';

  @override
  String get urlOpenInBrowser => 'เปิดในเบราว์เซอร์';

  @override
  String get urlCheckAnother => 'ตรวจสอบรายการอื่น';

  @override
  String get urlCouldNotOpenBrowser => 'ไม่สามารถเปิดเบราว์เซอร์ได้';

  @override
  String urlCouldNotOpen(String error) {
    return 'ไม่สามารถเปิดได้: $error';
  }

  @override
  String get urlNothingToTestAgain => 'ไม่มีอะไรให้ทดสอบอีกครั้ง';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'ไม่สามารถเปิดการตั้งค่าได้: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'ทดสอบผ่านอินเทอร์เน็ตมือถือ';

  @override
  String get crossMediumTestOverWifi => 'ทดสอบผ่าน Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'ปิด Wi-Fi แล้วกลับมา — การตรวจสอบจะทำงานอีกครั้งเอง';

  @override
  String get crossMediumHintWifi =>
      'เปิด Wi-Fi แล้วกลับมา — การตรวจสอบจะทำงานอีกครั้งเอง';

  @override
  String get verdictFlightModeTitle => 'คุณอยู่ในโหมดเครื่องบิน';

  @override
  String get verdictFlightModeDetail =>
      'ระบบไร้สายถูกปิดอยู่ ดังนั้นตราบใดที่โหมดเครื่องบินเปิดอยู่ จะไม่มีอะไรเชื่อมต่ออินเทอร์เน็ตได้';

  @override
  String get solutionFlightModeMessage => 'ปิดโหมดเครื่องบิน แล้วลองอีกครั้ง';

  @override
  String get verdictNotConnectedTitle => 'ไม่ได้เชื่อมต่อกับเครือข่ายใด ๆ';

  @override
  String get verdictNotConnectedDetail =>
      'ดูเหมือนว่าทั้ง Wi-Fi และเน็ตมือถือถูกปิดอยู่ จึงไม่มีทางเชื่อมต่ออินเทอร์เน็ตได้';

  @override
  String get solutionNotConnectedMessage =>
      'เปิด Wi-Fi หรือเน็ตมือถือ แล้วลองอีกครั้ง';

  @override
  String get verdictRouterNotRespondingTitle => 'เราเตอร์ไม่ตอบสนอง';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'คุณเชื่อมต่อกับเครือข่ายแล้ว แต่ $where ไม่ตอบสนอง อาจค้างหรือไฟดับ';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'เราเตอร์ของคุณ ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'เราเตอร์ของคุณ';

  @override
  String get solutionRouterNotRespondingMessage =>
      'รีสตาร์ตเราเตอร์: ถอดปลั๊ก รอ 30 วินาที เสียบกลับ แล้วให้เวลาบูตประมาณ 2-5 นาที จากนั้นทดสอบอีกครั้ง';

  @override
  String get verdictCaptivePortalTitle => 'ต้องลงชื่อเข้าใช้ (captive portal)';

  @override
  String get verdictCaptivePortalDetail =>
      'เครือข่ายต้องการให้คุณลงชื่อเข้าใช้หรือยอมรับข้อกำหนดบนหน้าเว็บก่อนจึงจะให้ออนไลน์ได้ พบได้บ่อยในโรงแรม ร้านกาแฟ และสนามบิน';

  @override
  String get solutionCaptivePortalMessage =>
      'เปิดหน้าลงชื่อเข้าใช้และทำการเข้าสู่ระบบให้เสร็จ จากนั้นทดสอบอีกครั้ง';

  @override
  String get verdictNoInternetMobileTitle =>
      'เชื่อมต่อเน็ตมือถือแล้ว แต่ไม่มีอินเทอร์เน็ต';

  @override
  String get verdictNoInternetMobileDetail =>
      'โทรศัพท์ของคุณเข้าถึงเครือข่ายในระดับพื้นฐาน แต่ไม่มีเส้นทางที่ใช้งานได้ไปยังอินเทอร์เน็ต ซึ่งชี้ไปที่ปัญหาในเครือข่ายของผู้ให้บริการ ไม่ใช่ที่โทรศัพท์ของคุณ';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. เปิด-ปิดโหมดเครื่องบิน หรือรีสตาร์ตโทรศัพท์ เพื่อเชื่อมต่อกับเสาสัญญาณใหม่\n2. หากทดสอบยังล้มเหลวหลังผ่านไป 2-5 นาที ให้ติดต่อผู้ให้บริการมือถือของคุณ — ปัญหาอยู่ที่ฝั่งของเขา';

  @override
  String get verdictNoInternetIspTitle =>
      'เชื่อมต่อกับเราเตอร์แล้ว แต่ไม่มีอินเทอร์เน็ต';

  @override
  String get verdictNoInternetIspDetail =>
      'เราเตอร์ของคุณทำงานได้ แต่ไม่มีการเชื่อมต่อที่ใช้งานได้ไปยังผู้ให้บริการอินเทอร์เน็ต (ISP) ของคุณ ปัญหาอยู่นอกบ้านของคุณ';

  @override
  String get solutionNoInternetIspMessage =>
      '1. ตรวจสอบว่าเราเตอร์ของคุณเสียบกับช่องเสียบโทรศัพท์/DSL ที่ผนังหรือไม่\n2. ตรวจสอบว่าสายไม่ชำรุดหรือหลวม\n3. หากมีโทรศัพท์บ้าน ให้ยกหูฟังและฟังสัญญาณต่อสาย หากไม่ได้ยินสัญญาณ ให้ติดต่อบริษัทโทรศัพท์และ/หรือผู้ให้บริการอินเทอร์เน็ตเพื่อซ่อมสายของคุณ\n4. รีสตาร์ตเราเตอร์หนึ่งครั้งเพื่อสร้างการเชื่อมต่อกับ ISP ใหม่ หากทดสอบยังล้มเหลวหลังผ่านไป 2-5 นาที ให้ติดต่อผู้ให้บริการอินเทอร์เน็ตของคุณ — ปัญหาอยู่ที่ฝั่งของเขา';

  @override
  String get verdictMobileNoDataTitle =>
      'เน็ตมือถือเชื่อมต่ออยู่แต่ใช้งานไม่ได้';

  @override
  String get verdictMobileNoDataDetail =>
      'โทรศัพท์ของคุณอยู่บนเครือข่ายมือถือ แต่ไม่มีข้อมูลผ่าน โดยทั่วไปหมายความว่าโรมมิ่งข้อมูลปิดอยู่ ปริมาณเน็ตหมด หรือผู้ให้บริการมีปัญหาเฉพาะพื้นที่';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. หากอยู่ต่างประเทศหรือบนเครือข่ายอื่น ให้เปิดโรมมิ่งข้อมูลในการตั้งค่ามือถือ\n2. ตรวจสอบว่าแพ็กเกจของคุณยังมีปริมาณเน็ตเหลืออยู่\n3. $reception\n4. หากยังล้มเหลว ให้ติดต่อผู้ให้บริการมือถือของคุณ';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'ปิดแล้วเปิดเน็ตมือถือใหม่',
      'weak':
          'สัญญาณอ่อน: ย้ายไปยังจุดที่รับสัญญาณดีกว่า แล้วปิดและเปิดเน็ตมือถือใหม่',
      'other': 'ย้ายไปยังจุดที่สัญญาณดีกว่า หรือปิดและเปิดเน็ตมือถือใหม่',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'ปัญหา DNS';

  @override
  String get verdictDnsProblemDetail =>
      'เข้าถึงอินเทอร์เน็ตได้ แต่ชื่อเว็บไซต์ไม่ถูกแปลเป็นที่อยู่ นี่คือปัญหา DNS และมักแก้ได้ง่ายด้วยการเปลี่ยนไปใช้ตัวแปล DNS สาธารณะ';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. เปลี่ยน DNS ส่วนตัวของคุณเป็นตัวแปลสาธารณะที่เชื่อถือได้ เช่น 1.1.1.1 (Cloudflare) หรือ 8.8.8.8 (Google) แล้วทดสอบอีกครั้ง\n2. หากยังล้มเหลว ให้ปิดและเปิดเน็ตมือถือใหม่ หรือรีสตาร์ตโทรศัพท์ เพื่อให้ได้การเชื่อมต่อใหม่\n3. หากยังล้มเหลว ให้ติดต่อผู้ให้บริการมือถือของคุณ — ผู้ให้บริการบางรายมีตัวแปล DNS ของตัวเองที่อาจมีปัญหาเอง';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. เปลี่ยน DNS ส่วนตัวของคุณเป็นตัวแปลสาธารณะที่เชื่อถือได้ เช่น 1.1.1.1 (Cloudflare) หรือ 8.8.8.8 (Google) แล้วทดสอบอีกครั้ง\n2. หากอยู่บนเครือข่ายที่มีการจัดการ (ที่ทำงาน โรงเรียน Wi-Fi สาธารณะ) ให้ติดต่อผู้ดูแลเครือข่ายเพื่อแก้ไข DNS\n3. หากอยู่บนเครือข่ายของคุณเอง ให้ตรวจสอบการตั้งค่าเราเตอร์ ควรตั้งค่า DNS สำรองเป็นตัวแปลสาธารณะด้วย (ตัวอย่าง: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8) เผื่อกรณีที่ตัวหลัก (ผู้ให้บริการอินเทอร์เน็ตของคุณ) ล้มเหลว';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'พอร์ต $port ถูกบล็อก';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'การเข้าถึงอินเทอร์เน็ตทั่วไปใช้งานได้ แต่ทราฟฟิก $service บนพอร์ต $port ถูกบล็อก — น่าจะโดยไฟร์วอลล์บนเครือข่ายนี้ แอปบางตัวที่พึ่งพาพอร์ตนี้จะใช้งานไม่ได้';
  }

  @override
  String get solutionPortBlockedMobile =>
      'ผู้ให้บริการมือถือของคุณน่าจะบล็อกตามนโยบาย — ลองใช้ Wi-Fi หรือ VPN แทน หรือติดต่อผู้ให้บริการหากคุณต้องการเปิดพอร์ตนี้บนเครือข่ายมือถือ';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'หากตอนนี้คุณเชื่อมต่อกับเครือข่ายที่มีการจัดการ (ที่ทำงาน โรงเรียน Wi-Fi สาธารณะ) พอร์ต $port ถูกบล็อกตามนโยบาย — ลองใช้เน็ตมือถือหรือ VPN แทน บนเครือข่ายของคุณเอง ให้ตรวจสอบกฎไฟร์วอลล์ในการตั้งค่าเราเตอร์';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'ปัญหาเส้นทางเครือข่ายที่ผู้ให้บริการของคุณ';

  @override
  String get verdictIspPathIspTitle => 'ปัญหาเส้นทางเครือข่ายที่ ISP ของคุณ';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'การเชื่อมต่อของคุณไปถึงอินเทอร์เน็ต แต่ทราฟฟิกหยุดกลางทาง หลังจาก $hop ความผิดพลาดอยู่ที่ผู้ให้บริการมือถือหรือเส้นทางแบ็กโบน ไม่ใช่ที่โทรศัพท์ของคุณ';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'การเชื่อมต่อของคุณไปถึงอินเทอร์เน็ต แต่ทราฟฟิกหยุดกลางทาง หลังจาก $hop ความผิดพลาดอยู่ที่ผู้ให้บริการอินเทอร์เน็ตหรือเส้นทางแบ็กโบน ไม่ใช่ที่อุปกรณ์หรือเราเตอร์ของคุณ';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'จุดเชื่อมภายในผู้ให้บริการมือถือของคุณ';

  @override
  String get verdictIspPathHopGenericFixed =>
      'จุดเชื่อมภายในผู้ให้บริการอินเทอร์เน็ตของคุณ';

  @override
  String get solutionIspPathMessageMobile =>
      'ไม่มีอะไรต้องแก้ไขบนอุปกรณ์หรือในเครือข่ายของคุณ แจ้งเส้นทางที่ล้มเหลวให้ผู้ให้บริการมือถือของคุณ (บอกว่า traceroute หยุดกลางทาง) โดยทั่วไปจะหายเมื่อเขาแก้ไขเส้นทางแล้ว';

  @override
  String get solutionIspPathMessageFixed =>
      'ไม่มีอะไรต้องแก้ไขบนอุปกรณ์หรือในเครือข่ายของคุณ แจ้งเส้นทางที่ล้มเหลวให้ผู้ให้บริการอินเทอร์เน็ตของคุณ (บอกว่า traceroute หยุดกลางทาง) โดยทั่วไปจะหายเมื่อเขาแก้ไขเส้นทางแล้ว';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return '$medium ของคุณเพียงพอสำหรับ $uses — และมากกว่านั้น';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured หากยังรู้สึกว่ามีบางอย่างผิดปกติ ส่วนใหญ่มักเป็นแอปหรือเว็บไซต์ใดเว็บไซต์หนึ่ง — ไม่ใช่การเชื่อมต่อของคุณ';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return '$medium ของคุณเพียงพอสำหรับทุกอย่างยกเว้น $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return '$medium ของคุณอ่อนเกินไปสำหรับ $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'วัดผ่าน $medium:\nดาวน์โหลด $down Mbps อัปโหลด $up Mbps';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'วัดผ่าน $medium:\nดาวน์โหลด $down Mbps';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'วัดผ่าน $medium:\nอัปโหลด $up Mbps';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'วัดผ่าน $medium';
  }

  @override
  String get verdictUploadNotAssessed =>
      'ไม่สามารถรันการทดสอบอัปโหลดได้ จึงไม่ได้ประเมิน';

  @override
  String get verdictCauseGatewayWeak =>
      'เราเตอร์ของคุณตอบสนองช้าหรือทิ้งแพ็กเก็ต ซึ่งชี้ไปที่ตัว Wi-Fi เอง ไม่ใช่ผู้ให้บริการของคุณ';

  @override
  String get verdictCauseSaturated =>
      'การเชื่อมต่อช้าลงอย่างมากขณะมีการใช้งานหนัก มีใครหรืออะไรบางอย่างบนเครือข่ายของคุณ (การดาวน์โหลด การสำรองข้อมูล ทีวี) กำลังใช้สายอยู่';

  @override
  String get verdictCauseThroughput =>
      'ความเร็วการเชื่อมต่อไม่เพียงพอ อาจเป็นเพราะแพ็กเกจอินเทอร์เน็ตของคุณช้าเกินไป หรือผู้ให้บริการจำกัดความเร็วสาย';

  @override
  String get verdictCauseGeneric =>
      'เวลาตอบสนองและการสูญเสียแพ็กเก็ตแปรปรวนมากเกินไปสำหรับงานเรียลไทม์ที่ต้องการทรัพยากรสูงที่สุด';

  @override
  String get adviceMoveCloser =>
      'เข้าใกล้เราเตอร์มากขึ้น หรือลองใช้เครือข่าย 5 GHz หากเราเตอร์ของคุณมีให้';

  @override
  String get advicePauseTheHog =>
      'หาว่าใครหรืออะไรใช้สายหนัก แล้วขอให้หยุดชั่วคราว มิฉะนั้นให้รอ หรือรีสตาร์ต Wi-Fi ของคุณ — นั่นจะตัดการเชื่อมต่อของเขาด้วย';

  @override
  String get adviceDropTheCamera =>
      'ปิดกล้องของคุณ — การเชื่อมต่อยังส่งเสียงได้อยู่';

  @override
  String get actionTestAgain => 'ทดสอบอีกครั้ง';

  @override
  String get actionTestAgainWifi => 'ทดสอบอีกครั้งผ่าน Wi-Fi';

  @override
  String get actionTestAgainMobile => 'ทดสอบอีกครั้งผ่านเน็ตมือถือ';

  @override
  String get actionTurnOnWifi => 'เปิด Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'Wi-Fi ปิดอยู่ เปิดการตั้งค่าเพื่อเปิดใช้งานไหม';

  @override
  String get actionTurnOnMobileData => 'เปิดเน็ตมือถือ';

  @override
  String get confirmTurnOnMobileData =>
      'เน็ตมือถือปิดอยู่ เปิดการตั้งค่าเพื่อเปิดใช้งานไหม';

  @override
  String get actionOpenFlightSettings => 'เปิดการตั้งค่าโหมดเครื่องบิน';

  @override
  String get confirmFlightMode =>
      'คุณอยู่ในโหมดเครื่องบิน เปิดการตั้งค่าเพื่อปิดโหมดไหม';

  @override
  String get actionOpenSignInPage => 'เปิดหน้าลงชื่อเข้าใช้';

  @override
  String get confirmCaptivePortal =>
      'คุณถูกบล็อกโดยหน้าลงชื่อเข้าใช้ เปิดตอนนี้ไหม';

  @override
  String get actionOpenMobileDataSettings => 'เปิดการตั้งค่าเน็ตมือถือ';

  @override
  String get confirmMobileDataSettings =>
      'เปิดการตั้งค่าเน็ตมือถือเพื่อตรวจสอบโรมมิ่งและปริมาณเน็ตไหม';

  @override
  String get actionOpenPrivateDns => 'เปิดการตั้งค่า Private DNS';

  @override
  String get confirmPrivateDns =>
      'เปิดการตั้งค่า Private DNS เพื่อให้คุณเปลี่ยนไปใช้ 1.1.1.1 ไหม';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'เน็ตมือถือ',
      'ethernet': 'การเชื่อมต่อแบบมีสาย',
      'vpn': 'การเชื่อมต่อ VPN',
      'other': 'การเชื่อมต่อ',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'สตรีมเพลง',
      'voiceCalls': 'การโทรด้วยเสียง',
      'webBrowsing': 'การท่องเว็บ',
      'losslessMusic': 'เพลงแบบไม่สูญเสียคุณภาพ',
      'videoCalls720': 'วิดีโอคอล (720p)',
      'teamGames': 'เกมแบบทีม',
      'videoCallsHd': 'วิดีโอคอล (HD)',
      'hdVideo': 'วิดีโอ HD (1080p)',
      'fastGames': 'เกมออนไลน์ที่ต้องตอบสนองเร็ว',
      'video4k': 'วิดีโอ 4K',
      'other': 'กิจกรรมนี้',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'อะไรก็ตามที่ใช้ทรัพยากรมาก';

  @override
  String listTwo(String a, String b) {
    return '$a และ $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head และ $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'ดาวน์โหลด $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'อัปโหลด $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'ความหน่วง $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'จิตเตอร์ $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'การสูญเสียแพ็กเก็ต $value%';
  }

  @override
  String get logHeadDeviceLink => 'การเชื่อมต่อของอุปกรณ์';

  @override
  String get logHeadRouter => 'เราเตอร์';

  @override
  String get logHeadInternetReachability => 'การเข้าถึงอินเทอร์เน็ต';

  @override
  String get logHeadPorts => 'พอร์ต';

  @override
  String get logHeadPopularSites => 'เว็บไซต์ยอดนิยม';

  @override
  String get logHeadMeasurements => 'การวัด';

  @override
  String get logHeadGoodFor => 'เพียงพอสำหรับ';

  @override
  String get logHeadNotGoodFor => 'ไม่เพียงพอสำหรับ';

  @override
  String logHeadTestsPerformed(int count) {
    return 'การทดสอบที่ทำแล้ว ($count)';
  }

  @override
  String get logYes => 'ใช่';

  @override
  String get logNo => 'ไม่';

  @override
  String get logUnknown => 'ไม่ทราบ';

  @override
  String get logNotApplicable => 'ไม่มี';

  @override
  String get logNotMeasured => 'ไม่ได้วัด';

  @override
  String get logNotReported => 'ไม่ได้รายงาน';

  @override
  String logConnectivity(String kind, String flight) {
    return 'การเชื่อมต่อ: $kind, โหมดเครื่องบิน: $flight';
  }

  @override
  String get logFlightOn => 'เปิด ✈️';

  @override
  String get logFlightOff => 'ปิด ✅';

  @override
  String logGateway(String value) {
    return 'เกตเวย์: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'เข้าถึงเกตเวย์ได้: $answer';
  }

  @override
  String logInternet(String state) {
    return 'อินเทอร์เน็ต: $state';
  }

  @override
  String get logInternetReachableYes => 'เข้าถึงได้ ✅';

  @override
  String get logInternetReachableNo => 'ไม่มีการตอบกลับ ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'หน้าลงชื่อเข้าใช้ captive: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'เข้าถึงที่อยู่ IP โดยตรงได้: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'แปลชื่อได้ ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'เส้นทางไปถึงอินเทอร์เน็ต: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'เส้นทางไปถึงอินเทอร์เน็ต: $answer (จุดเชื่อมสุดท้าย: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'พอร์ต $port/$service: $state';
  }

  @override
  String get logPortOpen => 'เปิด ✅';

  @override
  String get logPortBlocked => 'ถูกบล็อก ❌';

  @override
  String logPopularCountry(String value) {
    return 'ประเทศ: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'เว็บไซต์ยอดนิยมที่เข้าถึงได้: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'ทดสอบผ่าน: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'วัดเน็ตมือถือเพราะเป็นการเชื่อมต่อที่ใช้งานอยู่ (ไม่ได้เชื่อมต่อ Wi-Fi หรือคุณเลือกทดสอบซ้ำผ่านเน็ตมือถือ)';

  @override
  String logCellularSignalReported(int level) {
    return 'สัญญาณมือถือ: $level จาก 4';
  }

  @override
  String get logCellularSignalMissing => 'สัญญาณมือถือ: ไม่ได้รายงาน';

  @override
  String logDownloadLine(String value) {
    return 'ดาวน์โหลด: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'อัปโหลด: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'ปริมาณที่ส่งโดยการทดสอบความเร็ว: รับ $received ส่ง $sent';
  }

  @override
  String get logLabelRouter => 'เราเตอร์';

  @override
  String get logLabelInternet => 'อินเทอร์เน็ต';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'เวลาตอบสนอง $label: ไม่มีการตอบกลับ $sent โพรบ';
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
    return 'เวลาตอบสนอง $label: เฉลี่ย $avg ms (ต่ำสุด $min, สูงสุด $max), จิตเตอร์ $jitter ms, สูญเสีย $loss% ($received/$sent การตอบกลับ)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'เวลาตอบสนองขณะใช้งานหนัก: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'เวลาตอบสนองขณะใช้งานหนัก: $ms ms ($ratio× ของขณะว่าง)';
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
    return 'ข้อมูลทั้งหมดที่การวินิจฉัยนี้ใช้: $traffic';
  }

  @override
  String get logTotalCovers =>
      'ยอดรวมนี้ครอบคลุมการทดสอบทั้งหมดข้างต้น ไม่ใช่แค่การทดสอบความเร็ว';

  @override
  String logTrafficSent(String size) {
    return 'ส่ง $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'รับ $size';
  }
}
