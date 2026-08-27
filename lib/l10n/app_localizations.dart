import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Home screen headline above the diagnose button.
  ///
  /// In en, this message translates to:
  /// **'Internet not working?\nUnstable? Works partially?'**
  String get homeTitle;

  /// Home screen: button that starts the full diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Find the problem and give a solution'**
  String get homeDiagnoseButton;

  /// Home screen headline above the URL text field.
  ///
  /// In en, this message translates to:
  /// **'A particular website or service not working?\nPaste its link (URL) here:'**
  String get homeUrlPrompt;

  /// Placeholder text shown inside the empty URL field.
  ///
  /// In en, this message translates to:
  /// **'example.com or https://example.com/page'**
  String get homeUrlHint;

  /// Home screen: button that starts a single-URL check.
  ///
  /// In en, this message translates to:
  /// **'Check it'**
  String get homeCheckButton;

  /// Tooltip on the gear icon that opens the Settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsTooltip;

  /// Progress message shown while the full diagnosis runs.
  ///
  /// In en, this message translates to:
  /// **'Running comprehensive check…'**
  String get homeRunningDiagnosis;

  /// Progress message shown while a single-URL check runs.
  ///
  /// In en, this message translates to:
  /// **'Checking the website…'**
  String get homeRunningUrlCheck;

  /// Error screen headline when a check throws unexpectedly.
  ///
  /// In en, this message translates to:
  /// **'The check could not finish'**
  String get homeCheckFailedTitle;

  /// Fallback error detail when no specific message is available.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get homeUnknownError;

  /// Default retry button label on the error screen (diagnosis flow).
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeTryAgain;

  /// Generic "go back" button label, reused by the diagnosis result screen's back button and the URL-check error screen's retry button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Settings screen's AppBar title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings: label for the language-picker row.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Small caption under the language picker describing translation coverage.
  ///
  /// In en, this message translates to:
  /// **'The whole app is translated, including the diagnosis results and their technical details.'**
  String get settingsLanguageCaption;

  /// Settings: label above the theme selector.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Theme option: follow the device's light/dark setting.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Theme option: always light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Theme option: always dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Settings: label above the font-size selector.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// Font-size option: smaller than normal.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get settingsFontSmall;

  /// Font-size option: the default size.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get settingsFontNormal;

  /// Font-size option: larger than normal.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsFontLarge;

  /// Settings: button that opens the app's store listing.
  ///
  /// In en, this message translates to:
  /// **'Check for update'**
  String get settingsCheckForUpdate;

  /// Settings: link to the developer's donation page.
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get settingsBuyMeACoffee;

  /// Heading above the suggested-actions card on a result screen.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get resultWhatToDo;

  /// Confirmation dialog: decline button, before an action that needs confirmation.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get resultDialogNotNow;

  /// Confirmation dialog: accept button, before an action that needs confirmation.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get resultDialogYes;

  /// Snackbar shown when a suggested action has nothing to perform.
  ///
  /// In en, this message translates to:
  /// **'Nothing to open for this step.'**
  String get resultNothingToOpen;

  /// Snackbar shown when performing a suggested action throws.
  ///
  /// In en, this message translates to:
  /// **'Could not complete that action: {error}'**
  String resultActionFailed(String error);

  /// Collapsed header for the full "good for…" activity list.
  ///
  /// In en, this message translates to:
  /// **'What your connection can do ({fits} of {total})'**
  String resultCapabilityTitle(int fits, int total);

  /// Note shown in the capability list when the upload test did not run.
  ///
  /// In en, this message translates to:
  /// **'Upload could not be measured, therefore not assessed.'**
  String get resultUploadNotMeasured;

  /// Title of the collapsible technical-log section, shared by both result screens.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get techDetailsTitle;

  /// Button that copies the technical log to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get techDetailsCopy;

  /// Snackbar confirming the technical log was copied.
  ///
  /// In en, this message translates to:
  /// **'Technical details copied.'**
  String get techDetailsCopied;

  /// URL-check result: button that opens the checked URL in the browser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get urlOpenInBrowser;

  /// URL-check result: button that returns to the URL entry field.
  ///
  /// In en, this message translates to:
  /// **'Check another'**
  String get urlCheckAnother;

  /// Snackbar shown when opening the browser fails without an exception.
  ///
  /// In en, this message translates to:
  /// **'Could not open the browser.'**
  String get urlCouldNotOpenBrowser;

  /// Snackbar shown when opening the browser throws.
  ///
  /// In en, this message translates to:
  /// **'Could not open: {error}'**
  String urlCouldNotOpen(String error);

  /// Snackbar shown when the cross-medium retest cannot be armed.
  ///
  /// In en, this message translates to:
  /// **'Nothing to test again.'**
  String get urlNothingToTestAgain;

  /// Snackbar shown when arming the cross-medium retest throws.
  ///
  /// In en, this message translates to:
  /// **'Could not open the settings: {error}'**
  String urlCouldNotOpenSettings(String error);

  /// Button offering to re-run the URL check over mobile data instead of Wi-Fi.
  ///
  /// In en, this message translates to:
  /// **'Test over mobile data'**
  String get crossMediumTestOverMobile;

  /// Button offering to re-run the URL check over Wi-Fi instead of mobile data.
  ///
  /// In en, this message translates to:
  /// **'Test over Wi-Fi'**
  String get crossMediumTestOverWifi;

  /// Snackbar hint after tapping "Test over mobile data".
  ///
  /// In en, this message translates to:
  /// **'Turn Wi-Fi off, then come back — the check runs again by itself.'**
  String get crossMediumHintMobile;

  /// Snackbar hint after tapping "Test over Wi-Fi".
  ///
  /// In en, this message translates to:
  /// **'Turn Wi-Fi on, then come back — the check runs again by itself.'**
  String get crossMediumHintWifi;

  /// Diagnosis verdict headline: the device is in flight mode.
  ///
  /// In en, this message translates to:
  /// **'You are in flight mode'**
  String get verdictFlightModeTitle;

  /// Diagnosis verdict body for the flight-mode case.
  ///
  /// In en, this message translates to:
  /// **'Wireless is switched off, so nothing can reach the Internet while flight mode is on.'**
  String get verdictFlightModeDetail;

  /// What-to-do text for the flight-mode verdict.
  ///
  /// In en, this message translates to:
  /// **'Turn off flight mode, then try again.'**
  String get solutionFlightModeMessage;

  /// Diagnosis verdict headline: neither Wi-Fi nor mobile data is on.
  ///
  /// In en, this message translates to:
  /// **'Not connected to any network'**
  String get verdictNotConnectedTitle;

  /// Diagnosis verdict body when no link is available.
  ///
  /// In en, this message translates to:
  /// **'Both Wi-Fi and mobile data appear to be off, so there is no way to reach the Internet.'**
  String get verdictNotConnectedDetail;

  /// What-to-do text when no link is available.
  ///
  /// In en, this message translates to:
  /// **'Turn on Wi-Fi or mobile data, then try again.'**
  String get solutionNotConnectedMessage;

  /// Diagnosis verdict headline: the local router/gateway does not answer.
  ///
  /// In en, this message translates to:
  /// **'Router is not responding'**
  String get verdictRouterNotRespondingTitle;

  /// Diagnosis verdict body for a dead router. {where} is either "your router" or "your router (10.0.0.1)".
  ///
  /// In en, this message translates to:
  /// **'You\'re connected to the network, but {where} isn\'t answering. It may have crashed or lost power.'**
  String verdictRouterNotRespondingDetail(String where);

  /// The {where} value when the gateway IP is known.
  ///
  /// In en, this message translates to:
  /// **'your router ({gateway})'**
  String verdictRouterWhereNamed(String gateway);

  /// The {where} value when the gateway IP is not known.
  ///
  /// In en, this message translates to:
  /// **'your router'**
  String get verdictRouterWhereUnnamed;

  /// What-to-do text for a dead router.
  ///
  /// In en, this message translates to:
  /// **'Restart your router: unplug it, wait 30 seconds, plug it back in, and let it take about 2-5 minutes to start up. Then run the test again.'**
  String get solutionRouterNotRespondingMessage;

  /// Diagnosis verdict headline: a captive portal is intercepting traffic.
  ///
  /// In en, this message translates to:
  /// **'Sign-in required (captive portal)'**
  String get verdictCaptivePortalTitle;

  /// Diagnosis verdict body for a captive portal.
  ///
  /// In en, this message translates to:
  /// **'The network wants you to sign in or accept terms on a web page before it lets you online — common in hotels, cafes and airports.'**
  String get verdictCaptivePortalDetail;

  /// What-to-do text for a captive portal.
  ///
  /// In en, this message translates to:
  /// **'Open the sign-in page and complete the login, then run the test again.'**
  String get solutionCaptivePortalMessage;

  /// Diagnosis verdict headline: cellular link up but no Internet path.
  ///
  /// In en, this message translates to:
  /// **'Connected to mobile data, but no Internet'**
  String get verdictNoInternetMobileTitle;

  /// Diagnosis verdict body: no Internet on a cellular link.
  ///
  /// In en, this message translates to:
  /// **'Your phone reaches the network at a basic level, but it has no working path to the Internet. This points to a problem on your carrier\'s network, not your phone.'**
  String get verdictNoInternetMobileDetail;

  /// What-to-do text: no Internet on a cellular link.
  ///
  /// In en, this message translates to:
  /// **'1. Toggle airplane mode on and off, or restart your phone, to reconnect to a fresh tower.\n2. If the test still fails after 2-5 minutes, contact your mobile carrier — the outage is on their side.'**
  String get solutionNoInternetMobileMessage;

  /// Diagnosis verdict headline: router works but the WAN/ISP link is down.
  ///
  /// In en, this message translates to:
  /// **'Connected to router, but no Internet'**
  String get verdictNoInternetIspTitle;

  /// Diagnosis verdict body: router up but ISP link down.
  ///
  /// In en, this message translates to:
  /// **'Your router works, but it has no working connection to your Internet provider (ISP). The problem is outside your home.'**
  String get verdictNoInternetIspDetail;

  /// What-to-do text: router up but ISP link down.
  ///
  /// In en, this message translates to:
  /// **'1. Check whether your router is connected to the wall phone/DSL socket.\n2. Check the cable is not damaged or loose.\n3. If you have a landline phone, pick up the handset and listen for the dial tone. If you hear no dial tone, contact your phone company and/or Internet provider to fix your line.\n4. Restart your router once to re-establish the ISP link. If the test still fails after 2-5 minutes, contact your Internet provider — the outage is on their side.'**
  String get solutionNoInternetIspMessage;

  /// Diagnosis verdict headline: on the cellular network but no data passes.
  ///
  /// In en, this message translates to:
  /// **'Mobile data is connected but not working'**
  String get verdictMobileNoDataTitle;

  /// Diagnosis verdict body: cellular attached but no data.
  ///
  /// In en, this message translates to:
  /// **'Your phone is on the cellular network, but no data is getting through. This usually means data roaming is off, your data allowance is used up, or your carrier has a local outage.'**
  String get verdictMobileNoDataDetail;

  /// What-to-do text: cellular attached but no data. {reception} is one localized sentence.
  ///
  /// In en, this message translates to:
  /// **'1. If you are abroad or on another network, turn on data roaming in mobile settings.\n2. Check that you still have data allowance left on your plan.\n3. {reception}\n4. If it still fails, contact your mobile carrier.'**
  String solutionMobileNoDataMessage(String reception);

  /// Step 3 of the mobile-no-data advice, varying with the measured cellular signal.
  ///
  /// In en, this message translates to:
  /// **'{signal, select, good{Toggle mobile data off and on.} weak{Your signal is weak: move to a spot with better reception and toggle mobile data off and on.} other{Move to a spot with better signal, or toggle mobile data off and on.}}'**
  String solutionMobileNoDataReception(String signal);

  /// Diagnosis verdict headline: names do not resolve but IPs are reachable.
  ///
  /// In en, this message translates to:
  /// **'DNS problem'**
  String get verdictDnsProblemTitle;

  /// Diagnosis verdict body for a DNS resolution failure.
  ///
  /// In en, this message translates to:
  /// **'The Internet is reachable, but website names are not being translated into addresses. This is a DNS issue and is usually easy to fix by switching to a public DNS resolver.'**
  String get verdictDnsProblemDetail;

  /// What-to-do text for a DNS problem on a cellular link.
  ///
  /// In en, this message translates to:
  /// **'1. Switch your Private DNS to a reliable public resolver such as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.\n2. If it still fails, toggle mobile data off and on, or restart your phone, to get a fresh connection.\n3. If it still fails, contact your mobile carrier — some carriers run DNS resolvers that have outages of their own.'**
  String get solutionDnsProblemMessageMobile;

  /// What-to-do text for a DNS problem on Wi-Fi/wired.
  ///
  /// In en, this message translates to:
  /// **'1. Switch your Private DNS to a reliable public resolver such as 1.1.1.1 (Cloudflare) or 8.8.8.8 (Google), then test again.\n2. If you are on a managed network (work, school, public Wi-Fi), contact the network administrator to fix the DNS.\n3. If you are on your own network, check your router settings. It is good practice to configure the secondary DNS to a public resolver as well (examples: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), in case the primary (your Internet provider) fails.'**
  String get solutionDnsProblemMessageFixed;

  /// Diagnosis verdict headline: one port is firewalled while others work.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is blocked'**
  String verdictPortBlockedTitle(String port);

  /// Diagnosis verdict body for a blocked port.
  ///
  /// In en, this message translates to:
  /// **'General Internet access works, but {service} traffic on port {port} is being blocked — likely by a firewall on this network. Some apps that rely on this port will not work.'**
  String verdictPortBlockedDetail(String service, String port);

  /// What-to-do text for a blocked port on a cellular link.
  ///
  /// In en, this message translates to:
  /// **'Your mobile carrier is likely blocking it by policy — try Wi-Fi or a VPN instead, or contact your carrier if you need this port open over cellular.'**
  String get solutionPortBlockedMobile;

  /// What-to-do text for a blocked port on Wi-Fi/wired.
  ///
  /// In en, this message translates to:
  /// **'If you\'re currently connected to a managed network (work, school, public Wi-Fi), port {port} is blocked by policy — try mobile data or a VPN instead. On your own network, check the firewall rules in your router settings.'**
  String solutionPortBlockedFixed(String port);

  /// Diagnosis verdict headline: traffic dies inside the mobile carrier's network.
  ///
  /// In en, this message translates to:
  /// **'Network path problem at your carrier'**
  String get verdictIspPathMobileTitle;

  /// Diagnosis verdict headline: traffic dies inside the ISP/backbone.
  ///
  /// In en, this message translates to:
  /// **'Network path problem at your ISP'**
  String get verdictIspPathIspTitle;

  /// Diagnosis verdict body for a carrier path fault. {hop} is a hop address or a generic phrase.
  ///
  /// In en, this message translates to:
  /// **'Your connection reaches the Internet but traffic stops along the way, after {hop}. The fault is on your mobile carrier or backbone route, not on your phone.'**
  String verdictIspPathDetailMobile(String hop);

  /// Diagnosis verdict body for an ISP path fault. {hop} is a hop address or a generic phrase.
  ///
  /// In en, this message translates to:
  /// **'Your connection reaches the Internet but traffic stops along the way, after {hop}. The fault is on your Internet provider or backbone route, not on your device or router.'**
  String verdictIspPathDetailFixed(String hop);

  /// The {hop} value when the last responding hop is not known, on a cellular link.
  ///
  /// In en, this message translates to:
  /// **'a hop inside your mobile carrier'**
  String get verdictIspPathHopGenericMobile;

  /// The {hop} value when the last responding hop is not known, on Wi-Fi/wired.
  ///
  /// In en, this message translates to:
  /// **'a hop inside your Internet provider'**
  String get verdictIspPathHopGenericFixed;

  /// What-to-do text for a carrier path fault.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to fix on your device or in your network. Report the failing route to your mobile carrier (mention that traceroute stops partway). It usually clears once they fix the route.'**
  String get solutionIspPathMessageMobile;

  /// What-to-do text for an ISP path fault.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to fix on your device or in your network. Report the failing route to your Internet provider (mention that traceroute stops partway). It usually clears once they fix the route.'**
  String get solutionIspPathMessageFixed;

  /// Diagnosis verdict headline: the connection is healthy. {uses} is a list of activities.
  ///
  /// In en, this message translates to:
  /// **'Your {medium} is good for {uses} — and more'**
  String verdictCapabilityGoodTitle(String medium, String uses);

  /// Diagnosis verdict body for a healthy connection. {measured} is one localized sentence about the figures.
  ///
  /// In en, this message translates to:
  /// **'{measured} If something still feels wrong, it is most likely one app or website — not your connection.'**
  String verdictCapabilityGoodDetail(String measured);

  /// Diagnosis verdict headline: healthy except for a few activities.
  ///
  /// In en, this message translates to:
  /// **'Your {medium} is good for everything except {failing}'**
  String verdictCapabilityMostlyGoodTitle(String medium, String failing);

  /// Diagnosis verdict headline: too weak for most demanding activities.
  ///
  /// In en, this message translates to:
  /// **'Your {medium} is too weak for {failing}'**
  String verdictCapabilityDegradedTitle(String medium, String failing);

  /// The measured-figures sentence when both download and upload are known.
  ///
  /// In en, this message translates to:
  /// **'Measured over {medium}:\ndownload {down} Mbps, upload {up} Mbps.'**
  String verdictMeasuredBoth(String medium, String down, String up);

  /// The measured-figures sentence when only download is known.
  ///
  /// In en, this message translates to:
  /// **'Measured over {medium}:\ndownload {down} Mbps.'**
  String verdictMeasuredDownOnly(String medium, String down);

  /// The measured-figures sentence when only upload is known.
  ///
  /// In en, this message translates to:
  /// **'Measured over {medium}:\nupload {up} Mbps.'**
  String verdictMeasuredUpOnly(String medium, String up);

  /// The measured-figures sentence when no throughput figure is available.
  ///
  /// In en, this message translates to:
  /// **'Measured over {medium}.'**
  String verdictMeasuredNone(String medium);

  /// Verdict detail note when the upload probe did not run.
  ///
  /// In en, this message translates to:
  /// **'The upload test could not run, therefore not assessed.'**
  String get verdictUploadNotAssessed;

  /// Verdict detail cause: the local Wi-Fi hop is the weak part.
  ///
  /// In en, this message translates to:
  /// **'Your router answers slowly or drops packets, which points at the Wi-Fi itself rather than your provider.'**
  String get verdictCauseGatewayWeak;

  /// Verdict detail cause: the line is saturated by other traffic.
  ///
  /// In en, this message translates to:
  /// **'The connection slows down sharply while it is busy. Someone or something else on your network (a download, a backup, a TV) is using the line.'**
  String get verdictCauseSaturated;

  /// Verdict detail cause: raw throughput is the only shortfall.
  ///
  /// In en, this message translates to:
  /// **'The connection speed is not sufficient. Either your Internet plan is too slow or your provider is throttling the line.'**
  String get verdictCauseThroughput;

  /// Verdict detail cause fallback when no more specific cause applies.
  ///
  /// In en, this message translates to:
  /// **'Response times and packet loss vary too much for the most demanding real-time activities.'**
  String get verdictCauseGeneric;

  /// Remediation step for a weak local Wi-Fi hop.
  ///
  /// In en, this message translates to:
  /// **'Move closer to the router, or try the 5 GHz network if your router offers one.'**
  String get adviceMoveCloser;

  /// Remediation step for a saturated line.
  ///
  /// In en, this message translates to:
  /// **'Find who or what is using the line heavily and ask them to pause. Otherwise wait, or restart your Wi-Fi — that cuts their connection too.'**
  String get advicePauseTheHog;

  /// Remediation step: a voice-only call still fits when video does not.
  ///
  /// In en, this message translates to:
  /// **'Turn your camera off — your connection can still carry the audio.'**
  String get adviceDropTheCamera;

  /// Solution button: re-run the diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Test again'**
  String get actionTestAgain;

  /// Solution button: re-run the diagnosis on the same Wi-Fi link.
  ///
  /// In en, this message translates to:
  /// **'Test again over Wi-Fi'**
  String get actionTestAgainWifi;

  /// Solution button: re-run the diagnosis on the same mobile-data link.
  ///
  /// In en, this message translates to:
  /// **'Test again over mobile data'**
  String get actionTestAgainMobile;

  /// Solution button: open Wi-Fi settings.
  ///
  /// In en, this message translates to:
  /// **'Turn on Wi-Fi'**
  String get actionTurnOnWifi;

  /// Confirmation prompt before opening Wi-Fi settings.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi is off. Open settings to turn it on?'**
  String get confirmTurnOnWifi;

  /// Solution button: open mobile-data settings.
  ///
  /// In en, this message translates to:
  /// **'Turn on mobile data'**
  String get actionTurnOnMobileData;

  /// Confirmation prompt before opening mobile-data settings.
  ///
  /// In en, this message translates to:
  /// **'Mobile data is off. Open settings to turn it on?'**
  String get confirmTurnOnMobileData;

  /// Solution button: open the airplane-mode settings panel.
  ///
  /// In en, this message translates to:
  /// **'Open flight-mode settings'**
  String get actionOpenFlightSettings;

  /// Confirmation prompt before opening airplane-mode settings.
  ///
  /// In en, this message translates to:
  /// **'You\'re in flight mode. Open settings to turn it off?'**
  String get confirmFlightMode;

  /// Solution button: open the captive-portal sign-in page.
  ///
  /// In en, this message translates to:
  /// **'Open sign-in page'**
  String get actionOpenSignInPage;

  /// Confirmation prompt before opening the captive-portal page.
  ///
  /// In en, this message translates to:
  /// **'You\'re blocked by a sign-in page. Open it now?'**
  String get confirmCaptivePortal;

  /// Solution button: open mobile-data settings to check roaming/allowance.
  ///
  /// In en, this message translates to:
  /// **'Open mobile data settings'**
  String get actionOpenMobileDataSettings;

  /// Confirmation prompt before opening mobile-data settings for roaming/allowance.
  ///
  /// In en, this message translates to:
  /// **'Open mobile data settings to check roaming and data?'**
  String get confirmMobileDataSettings;

  /// Solution button: open the Private DNS settings.
  ///
  /// In en, this message translates to:
  /// **'Open Private DNS settings'**
  String get actionOpenPrivateDns;

  /// Confirmation prompt before opening Private DNS settings.
  ///
  /// In en, this message translates to:
  /// **'Open Private DNS settings so you can switch to 1.1.1.1?'**
  String get confirmPrivateDns;

  /// How the tested link is named in verdict sentences and the log.
  ///
  /// In en, this message translates to:
  /// **'{kind, select, wifi{Wi-Fi} mobile{mobile data} ethernet{wired connection} vpn{VPN connection} other{connection}}'**
  String mediumLabel(String kind);

  /// Display name of an everyday activity the diagnosis reports on.
  ///
  /// In en, this message translates to:
  /// **'{id, select, musicStreaming{music streaming} voiceCalls{voice calls} webBrowsing{web browsing} losslessMusic{lossless music} videoCalls720{video calls (720p)} teamGames{team games} videoCallsHd{video calls (HD)} hdVideo{HD video (1080p)} fastGames{fast online games} video4k{4K video} other{this activity}}'**
  String useCaseName(String id);

  /// Stand-in in the verdict sentence when no activity list is available.
  ///
  /// In en, this message translates to:
  /// **'anything demanding'**
  String get useCaseNoneDemanding;

  /// Joins exactly two items in a sentence list.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b}'**
  String listTwo(String a, String b);

  /// Joins the comma-separated {head} of a list with its {last} item.
  ///
  /// In en, this message translates to:
  /// **'{head} and {last}'**
  String listAnd(String head, String last);

  /// Capability-list / log phrase for a download shortfall.
  ///
  /// In en, this message translates to:
  /// **'download {value} Mbps'**
  String shortfallDownload(String value);

  /// Capability-list / log phrase for an upload shortfall.
  ///
  /// In en, this message translates to:
  /// **'upload {value} Mbps'**
  String shortfallUpload(String value);

  /// Capability-list / log phrase for a latency shortfall.
  ///
  /// In en, this message translates to:
  /// **'latency {value} ms'**
  String shortfallLatency(String value);

  /// Capability-list / log phrase for a jitter shortfall.
  ///
  /// In en, this message translates to:
  /// **'jitter {value} ms'**
  String shortfallJitter(String value);

  /// Capability-list / log phrase for a packet-loss shortfall.
  ///
  /// In en, this message translates to:
  /// **'packet loss {value}%'**
  String shortfallLoss(String value);

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Device link'**
  String get logHeadDeviceLink;

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Router'**
  String get logHeadRouter;

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Internet reachability'**
  String get logHeadInternetReachability;

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Ports'**
  String get logHeadPorts;

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Popular sites'**
  String get logHeadPopularSites;

  /// Technical log heading.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get logHeadMeasurements;

  /// Technical log heading: activities the link supports.
  ///
  /// In en, this message translates to:
  /// **'Good for'**
  String get logHeadGoodFor;

  /// Technical log heading: activities the link cannot carry.
  ///
  /// In en, this message translates to:
  /// **'Not good enough for'**
  String get logHeadNotGoodFor;

  /// Technical log heading with the number of probes that ran.
  ///
  /// In en, this message translates to:
  /// **'Tests performed ({count})'**
  String logHeadTestsPerformed(int count);

  /// Affirmative answer word in the technical log (followed by a ✅/❌ mark).
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get logYes;

  /// Negative answer word in the technical log (followed by a ✅/❌ mark).
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get logNo;

  /// Placeholder in the log when a value is not known.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get logUnknown;

  /// Placeholder in the log for a value that does not apply.
  ///
  /// In en, this message translates to:
  /// **'n/a'**
  String get logNotApplicable;

  /// Log value when a figure was not measured.
  ///
  /// In en, this message translates to:
  /// **'not measured'**
  String get logNotMeasured;

  /// Log value when the OS did not report a figure.
  ///
  /// In en, this message translates to:
  /// **'not reported'**
  String get logNotReported;

  /// Log line for the device link.
  ///
  /// In en, this message translates to:
  /// **'Connectivity: {kind}, flight mode: {flight}'**
  String logConnectivity(String kind, String flight);

  /// Flight-mode state in the connectivity log line.
  ///
  /// In en, this message translates to:
  /// **'on ✈️'**
  String get logFlightOn;

  /// Flight-mode state in the connectivity log line.
  ///
  /// In en, this message translates to:
  /// **'off ✅'**
  String get logFlightOff;

  /// Log line naming the gateway IP.
  ///
  /// In en, this message translates to:
  /// **'Gateway: {value}'**
  String logGateway(String value);

  /// Log line: whether the gateway answered.
  ///
  /// In en, this message translates to:
  /// **'Gateway reachable: {answer}'**
  String logGatewayReachable(String answer);

  /// Log line: whether the Internet answered.
  ///
  /// In en, this message translates to:
  /// **'Internet: {state}'**
  String logInternet(String state);

  /// Internet state in the reachability log line.
  ///
  /// In en, this message translates to:
  /// **'reachable ✅'**
  String get logInternetReachableYes;

  /// Internet state in the reachability log line.
  ///
  /// In en, this message translates to:
  /// **'no answer ❌'**
  String get logInternetReachableNo;

  /// Log line: whether a captive portal was found.
  ///
  /// In en, this message translates to:
  /// **'Captive sign-in page: {answer}'**
  String logCaptiveSignIn(String answer);

  /// Log line: whether a raw IP responded.
  ///
  /// In en, this message translates to:
  /// **'Raw IP address reachable: {answer}'**
  String logRawIpReachable(String answer);

  /// Log line: whether DNS resolved a probe host.
  ///
  /// In en, this message translates to:
  /// **'Name resolves ({host}): {answer}'**
  String logNameResolves(String host, String answer);

  /// Log line: whether traceroute reached the destination.
  ///
  /// In en, this message translates to:
  /// **'Route reached the Internet: {answer}'**
  String logRouteReached(String answer);

  /// Log line: traceroute result plus the last responding hop.
  ///
  /// In en, this message translates to:
  /// **'Route reached the Internet: {answer} (last hop: {hop})'**
  String logRouteReachedHop(String answer, String hop);

  /// Log line for one probed port.
  ///
  /// In en, this message translates to:
  /// **'Port {port}/{service}: {state}'**
  String logPortLine(int port, String service, String state);

  /// Port state in the port log line.
  ///
  /// In en, this message translates to:
  /// **'open ✅'**
  String get logPortOpen;

  /// Port state in the port log line.
  ///
  /// In en, this message translates to:
  /// **'blocked ❌'**
  String get logPortBlocked;

  /// Log line: detected country for the popular-site check.
  ///
  /// In en, this message translates to:
  /// **'Country: {value}'**
  String logPopularCountry(String value);

  /// Log line: how many popular sites responded.
  ///
  /// In en, this message translates to:
  /// **'Popular sites reachable: {reachable}/{total} {mark}'**
  String logPopularReachable(int reachable, int total, String mark);

  /// Log line: which medium the measurements used.
  ///
  /// In en, this message translates to:
  /// **'Tested over: {medium}'**
  String logTestedOver(String medium);

  /// Log line explaining why mobile data was the medium under test.
  ///
  /// In en, this message translates to:
  /// **'Mobile data was measured because it is the link in use (Wi-Fi not connected, or you chose to retest over mobile)'**
  String get logMobileMeasuredReason;

  /// Log line: cellular signal level on the Android 0-4 scale.
  ///
  /// In en, this message translates to:
  /// **'Cellular signal: {level} of 4'**
  String logCellularSignalReported(int level);

  /// Log line when the OS did not report a cellular signal level.
  ///
  /// In en, this message translates to:
  /// **'Cellular signal: not reported'**
  String get logCellularSignalMissing;

  /// Log line: measured download rate or "not measured".
  ///
  /// In en, this message translates to:
  /// **'Download: {value}'**
  String logDownloadLine(String value);

  /// Log line: measured upload rate or "not measured".
  ///
  /// In en, this message translates to:
  /// **'Upload: {value}'**
  String logUploadLine(String value);

  /// A throughput figure with its unit.
  ///
  /// In en, this message translates to:
  /// **'{value} Mbps'**
  String logMbps(String value);

  /// Log line: data moved by the throughput test.
  ///
  /// In en, this message translates to:
  /// **'Moved by the speed test: received {received}, sent {sent}'**
  String logSpeedTestMoved(String received, String sent);

  /// Label for the router latency log line.
  ///
  /// In en, this message translates to:
  /// **'Router'**
  String get logLabelRouter;

  /// Label for the Internet latency log line.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get logLabelInternet;

  /// Log line when latency probes got no answer.
  ///
  /// In en, this message translates to:
  /// **'{label} response time: no reply to {sent} probes'**
  String logLatencyNoReply(String label, int sent);

  /// Log line summarising a latency sample.
  ///
  /// In en, this message translates to:
  /// **'{label} response time: {avg} ms avg (min {min}, max {max}), jitter {jitter} ms, loss {loss}% ({received}/{sent} replies)'**
  String logLatencyLine(
    String label,
    int avg,
    int min,
    int max,
    String jitter,
    int loss,
    int received,
    int sent,
  );

  /// Log line: response time under load, without the idle ratio.
  ///
  /// In en, this message translates to:
  /// **'Response time while busy: {ms} ms'**
  String logResponseWhileBusy(int ms);

  /// Log line: response time under load with the multiple of the idle figure.
  ///
  /// In en, this message translates to:
  /// **'Response time while busy: {ms} ms ({ratio}x idle)'**
  String logResponseWhileBusyRatio(int ms, String ratio);

  /// Log line: an unsupported activity and why it fails.
  ///
  /// In en, this message translates to:
  /// **'{name} — {shortfalls}'**
  String logNotGoodForItem(String name, String shortfalls);

  /// Log line: one probe that ran and the data it moved.
  ///
  /// In en, this message translates to:
  /// **'{test} → {target}{traffic}'**
  String logTestRecord(String test, String target, String traffic);

  /// Log line: total data used by the whole diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Total data used by this diagnosis: {traffic}'**
  String logTotalData(String traffic);

  /// Log line clarifying what the data total includes.
  ///
  /// In en, this message translates to:
  /// **'That total covers every test above, not only the speed test'**
  String get logTotalCovers;

  /// Half of a traffic figure: bytes sent.
  ///
  /// In en, this message translates to:
  /// **'sent {size}'**
  String logTrafficSent(String size);

  /// Half of a traffic figure: bytes received.
  ///
  /// In en, this message translates to:
  /// **'received {size}'**
  String logTrafficReceived(String size);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pl',
    'pt',
    'ru',
    'th',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
