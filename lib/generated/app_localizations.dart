import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Guard'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @appPermission.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get appPermission;

  /// No description provided for @groupPermission.
  ///
  /// In en, this message translates to:
  /// **'Group Permissions'**
  String get groupPermission;

  /// No description provided for @specialPermission.
  ///
  /// In en, this message translates to:
  /// **'Special Permissions'**
  String get specialPermission;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @recentApps.
  ///
  /// In en, this message translates to:
  /// **'Recent Apps'**
  String get recentApps;

  /// No description provided for @lastScann.
  ///
  /// In en, this message translates to:
  /// **'Last Scan'**
  String get lastScann;

  /// No description provided for @notScannedYet.
  ///
  /// In en, this message translates to:
  /// **'Not scanned yet'**
  String get notScannedYet;

  /// No description provided for @scanToStart.
  ///
  /// In en, this message translates to:
  /// **'Scan to get started'**
  String get scanToStart;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(int count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(int count);

  /// No description provided for @noRiskApps.
  ///
  /// In en, this message translates to:
  /// **'No Risk Apps'**
  String get noRiskApps;

  /// No description provided for @lowRiskApps.
  ///
  /// In en, this message translates to:
  /// **'Low Risk Apps'**
  String get lowRiskApps;

  /// No description provided for @mediumRiskApps.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk Apps'**
  String get mediumRiskApps;

  /// No description provided for @highRiskApps.
  ///
  /// In en, this message translates to:
  /// **'High Risk Apps'**
  String get highRiskApps;

  /// No description provided for @keepApps.
  ///
  /// In en, this message translates to:
  /// **'FAVORITES'**
  String get keepApps;

  /// No description provided for @trustedApps.
  ///
  /// In en, this message translates to:
  /// **'Safe list'**
  String get trustedApps;

  /// No description provided for @riskPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% RISK'**
  String riskPercent(Object percent);

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get highRisk;

  /// No description provided for @mediumRisk.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get mediumRisk;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get lowRisk;

  /// No description provided for @noRisk.
  ///
  /// In en, this message translates to:
  /// **'No Risk'**
  String get noRisk;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @trustApp.
  ///
  /// In en, this message translates to:
  /// **'Safe list'**
  String get trustApp;

  /// No description provided for @appDetailSnackBarSuccess.
  ///
  /// In en, this message translates to:
  /// **'App marked as Safe'**
  String get appDetailSnackBarSuccess;

  /// No description provided for @appDetailSnackBarFailed.
  ///
  /// In en, this message translates to:
  /// **'App unsafe'**
  String get appDetailSnackBarFailed;

  /// No description provided for @untrustApp.
  ///
  /// In en, this message translates to:
  /// **'Remove Safe'**
  String get untrustApp;

  /// No description provided for @keepApp.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get keepApp;

  /// No description provided for @removeKeep.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeKeep;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No sensitive configurations detected'**
  String get noAlerts;

  /// No description provided for @accessibilityEnabled.
  ///
  /// In en, this message translates to:
  /// **'Accessibility enabled'**
  String get accessibilityEnabled;

  /// No description provided for @locationAlways.
  ///
  /// In en, this message translates to:
  /// **'Location set to \"Always\"'**
  String get locationAlways;

  /// No description provided for @sinceLastScan.
  ///
  /// In en, this message translates to:
  /// **'Since last Scan'**
  String get sinceLastScan;

  /// No description provided for @newApps.
  ///
  /// In en, this message translates to:
  /// **'New apps'**
  String get newApps;

  /// No description provided for @changedPermissions.
  ///
  /// In en, this message translates to:
  /// **'Changed permissions'**
  String get changedPermissions;

  /// No description provided for @runScan.
  ///
  /// In en, this message translates to:
  /// **'Run scan'**
  String get runScan;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Old permissions deserve \n a second look.'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Some of them could be risky'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Not every app needs access to your\n photos and text messages.'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'See which permissions are essential,\n and review the ones that aren’t.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'See your permission status in seconds.'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Privio shows important permissions and \n what needs your attention — all at a glance.'**
  String get onboardingDesc3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @noAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No applications found'**
  String get noAppsFound;

  /// No description provided for @noKeepApps.
  ///
  /// In en, this message translates to:
  /// **'No apps in favorites'**
  String get noKeepApps;

  /// No description provided for @noTrustedApps.
  ///
  /// In en, this message translates to:
  /// **'No apps in safe list'**
  String get noTrustedApps;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @usageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage Data Access'**
  String get usageAccessTitle;

  /// No description provided for @notificationAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Access'**
  String get notificationAccessTitle;

  /// No description provided for @displayOverApps.
  ///
  /// In en, this message translates to:
  /// **'Display over other apps'**
  String get displayOverApps;

  /// No description provided for @batteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization'**
  String get batteryOptimization;

  /// No description provided for @doNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get doNotDisturb;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @actionNeeded.
  ///
  /// In en, this message translates to:
  /// **'ACTION NEEDED'**
  String get actionNeeded;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'REVIEW'**
  String get review;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'SECURE'**
  String get secure;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @appsChecked.
  ///
  /// In en, this message translates to:
  /// **'Apps Checked'**
  String get appsChecked;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @sensitiveAccess.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Access'**
  String get sensitiveAccess;

  /// No description provided for @viewStates.
  ///
  /// In en, this message translates to:
  /// **'View States'**
  String get viewStates;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationPermission;

  /// No description provided for @cameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get cameraPermission;

  /// No description provided for @microphonePermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone Access'**
  String get microphonePermission;

  /// No description provided for @contactsPermission.
  ///
  /// In en, this message translates to:
  /// **'Contacts Access'**
  String get contactsPermission;

  /// No description provided for @smsPermission.
  ///
  /// In en, this message translates to:
  /// **'SMS Access'**
  String get smsPermission;

  /// No description provided for @callPermission.
  ///
  /// In en, this message translates to:
  /// **'Call Access'**
  String get callPermission;

  /// No description provided for @storagePermission.
  ///
  /// In en, this message translates to:
  /// **'Storage Access'**
  String get storagePermission;

  /// No description provided for @calendarPermission.
  ///
  /// In en, this message translates to:
  /// **'Calendar Access'**
  String get calendarPermission;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notifications Access'**
  String get notificationPermission;

  /// No description provided for @activityPermission.
  ///
  /// In en, this message translates to:
  /// **'Activity Access'**
  String get activityPermission;

  /// No description provided for @appMarkedTrusted.
  ///
  /// In en, this message translates to:
  /// **'App marked as Safe'**
  String get appMarkedTrusted;

  /// No description provided for @appUntrusted.
  ///
  /// In en, this message translates to:
  /// **'App unsafe'**
  String get appUntrusted;

  /// No description provided for @appAddedToKeep.
  ///
  /// In en, this message translates to:
  /// **'App added to Favorites'**
  String get appAddedToKeep;

  /// No description provided for @appRemovedFromKeep.
  ///
  /// In en, this message translates to:
  /// **'App removed from Favorites list'**
  String get appRemovedFromKeep;

  /// No description provided for @appDetails.
  ///
  /// In en, this message translates to:
  /// **'APP DETAILS'**
  String get appDetails;

  /// No description provided for @trustedAppsExcluded.
  ///
  /// In en, this message translates to:
  /// **'Safe apps are excluded from risk warnings'**
  String get trustedAppsExcluded;

  /// No description provided for @keepAppsWarning.
  ///
  /// In en, this message translates to:
  /// **'Removing an app from this list will return it to the \"Risk Apps\" scan result if it requests sensitive permissions in the future.'**
  String get keepAppsWarning;

  /// No description provided for @removeFromKeepDesc.
  ///
  /// In en, this message translates to:
  /// **'This app will no longer be marked safe and will be analyzed again for potential risks.'**
  String get removeFromKeepDesc;

  /// No description provided for @reviewedList.
  ///
  /// In en, this message translates to:
  /// **'REVIEWED KIST'**
  String get reviewedList;

  /// No description provided for @appsWithOverlayPermission.
  ///
  /// In en, this message translates to:
  /// **'Apps with Display Over Other Apps'**
  String get appsWithOverlayPermission;

  /// No description provided for @noAppsWithOverlayPermission.
  ///
  /// In en, this message translates to:
  /// **'No apps have display over other apps permission'**
  String get noAppsWithOverlayPermission;

  /// No description provided for @markedAsSafe.
  ///
  /// In en, this message translates to:
  /// **'Marked as Safe'**
  String get markedAsSafe;

  /// No description provided for @reviewedListDesc.
  ///
  /// In en, this message translates to:
  /// **'These are apps you have manually reviewed. They will no longer trigger risk warnings unless their behavior changes significantly.'**
  String get reviewedListDesc;

  /// No description provided for @removeFromKeep.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromKeep;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @whiteList.
  ///
  /// In en, this message translates to:
  /// **'WHITE LIST'**
  String get whiteList;

  /// No description provided for @appsYouFullyTrust.
  ///
  /// In en, this message translates to:
  /// **'Apps you fully mark as safe'**
  String get appsYouFullyTrust;

  /// No description provided for @trustedListDesc.
  ///
  /// In en, this message translates to:
  /// **'These applications are excluded from all risk alerts and security scans. Only apps you are certain are safe.'**
  String get trustedListDesc;

  /// No description provided for @removeTrust.
  ///
  /// In en, this message translates to:
  /// **'Remove Safe List'**
  String get removeTrust;

  /// No description provided for @removeTrustDesc.
  ///
  /// In en, this message translates to:
  /// **'This app will be analyzed again and may show risk warnings.'**
  String get removeTrustDesc;

  /// No description provided for @untrust.
  ///
  /// In en, this message translates to:
  /// **'Unsafe'**
  String get untrust;

  /// No description provided for @appsWithBatteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Apps with Unrestricted Battery'**
  String get appsWithBatteryOptimization;

  /// No description provided for @noAppsWithBatteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'No apps have unrestricted battery access'**
  String get noAppsWithBatteryOptimization;

  /// No description provided for @appsWithDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Apps with Do Not Disturb Access'**
  String get appsWithDoNotDisturb;

  /// No description provided for @noAppsWithDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'No apps have Do Not Disturb access'**
  String get noAppsWithDoNotDisturb;

  /// No description provided for @securityOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Overview'**
  String get securityOverview;

  /// No description provided for @securityOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'This app\'s risk level is calculated based on the permissions you have granted.\n\nSome permissions provide powerful access to your device. While they may be required for certain features, they can increase potential impact if misused.\n\nA higher risk does not mean the app is malicious — it means it has greater access.'**
  String get securityOverviewDesc;

  /// No description provided for @lowRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'Limited permissions with minimal impact'**
  String get lowRiskDesc;

  /// No description provided for @mediumRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'Sensitive permissions required for core features'**
  String get mediumRiskDesc;

  /// No description provided for @highRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'Permissions that are unusual or unnecessary for this type of app'**
  String get highRiskDesc;

  /// No description provided for @reduceRiskTip.
  ///
  /// In en, this message translates to:
  /// **'You can reduce risk by disabling permissions that are not actively used. Permissions can be changed at any time from system settings.'**
  String get reduceRiskTip;

  /// No description provided for @appIsKept.
  ///
  /// In en, this message translates to:
  /// **'App is Favorited'**
  String get appIsKept;

  /// No description provided for @kept.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get kept;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @youWillManuallyNavigate.
  ///
  /// In en, this message translates to:
  /// **'You will manually navigate through the system settings to manage app permissions.'**
  String get youWillManuallyNavigate;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @trusting.
  ///
  /// In en, this message translates to:
  /// **'Marking safe...'**
  String get trusting;

  /// No description provided for @trusted.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get trusted;

  /// No description provided for @dashboardPermission.
  ///
  /// In en, this message translates to:
  /// **'DASHBOARD PERMISSION'**
  String get dashboardPermission;

  /// No description provided for @systemPrivacyDashboard.
  ///
  /// In en, this message translates to:
  /// **'System Privacy Dashboard'**
  String get systemPrivacyDashboard;

  /// No description provided for @systemPrivacyDashboardDesc.
  ///
  /// In en, this message translates to:
  /// **'View permission activity and manage access directly in your phone settings.'**
  String get systemPrivacyDashboardDesc;

  /// No description provided for @openPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Open Privacy'**
  String get openPrivacy;

  /// No description provided for @permissionManager.
  ///
  /// In en, this message translates to:
  /// **'Permission Manager'**
  String get permissionManager;

  /// No description provided for @ifItDoesntOpen.
  ///
  /// In en, this message translates to:
  /// **'If it doesn\'t open:\nSettings → Privacy → ...'**
  String get ifItDoesntOpen;

  /// No description provided for @noPreviousScan.
  ///
  /// In en, this message translates to:
  /// **'No previous scan yet'**
  String get noPreviousScan;

  /// No description provided for @lastScan.
  ///
  /// In en, this message translates to:
  /// **'Last Scan: {time}'**
  String lastScan(String time);

  /// No description provided for @changed.
  ///
  /// In en, this message translates to:
  /// **'CHANGED'**
  String get changed;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newLabel;

  /// No description provided for @runScanToCompare.
  ///
  /// In en, this message translates to:
  /// **'Run a scan to compare changes.'**
  String get runScanToCompare;

  /// No description provided for @noChangesSinceLastScan.
  ///
  /// In en, this message translates to:
  /// **'No changes since the last scan.'**
  String get noChangesSinceLastScan;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removed;

  /// No description provided for @reviewYourAppPermissions.
  ///
  /// In en, this message translates to:
  /// **'Review your app permissions'**
  String get reviewYourAppPermissions;

  /// No description provided for @understandYourPermissions.
  ///
  /// In en, this message translates to:
  /// **'Understand your permissions. Stay in control.'**
  String get understandYourPermissions;

  /// No description provided for @accessibilityEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'This permission allows an app to read screen content and control interactions.'**
  String get accessibilityEnabledDesc;

  /// No description provided for @locationAlwaysDesc.
  ///
  /// In en, this message translates to:
  /// **'{appName} can access your location even when you\'re not using it.'**
  String locationAlwaysDesc(String appName);

  /// No description provided for @reviewInSettings.
  ///
  /// In en, this message translates to:
  /// **'Review in Settings'**
  String get reviewInSettings;

  /// No description provided for @noSensitiveConfigurationsDetected.
  ///
  /// In en, this message translates to:
  /// **'No sensitive configurations detected.'**
  String get noSensitiveConfigurationsDetected;

  /// No description provided for @batteryOptimizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Some apps can ignore battery optimizations and continue running in the background, which may increase battery usage.'**
  String get batteryOptimizationDesc;

  /// No description provided for @openBatteryOptimizationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Battery Optimization Settings'**
  String get openBatteryOptimizationSettings;

  /// No description provided for @displayOverAppsDesc.
  ///
  /// In en, this message translates to:
  /// **'Apps with this permission can appear on top of other apps. This may be used for chat heads, floating tools, or overlays.'**
  String get displayOverAppsDesc;

  /// No description provided for @openDisplayOverAppsSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Display Over Apps Settings'**
  String get openDisplayOverAppsSettings;

  /// No description provided for @overlayPermissionNote.
  ///
  /// In en, this message translates to:
  /// **'Android does not allow apps to list overlay permissions directly. To review apps with this access, use the system settings.'**
  String get overlayPermissionNote;

  /// No description provided for @displayOverOtherApps.
  ///
  /// In en, this message translates to:
  /// **'Display over other apps'**
  String get displayOverOtherApps;

  /// No description provided for @doNotDisturbDesc.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb silences notifications and alerts. This setting affects how and when notifications are delivered.'**
  String get doNotDisturbDesc;

  /// No description provided for @openDoNotDisturbSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Do Not Disturb Settings'**
  String get openDoNotDisturbSettings;

  /// No description provided for @whatIsNotificationAccess.
  ///
  /// In en, this message translates to:
  /// **'What is Notification Access?'**
  String get whatIsNotificationAccess;

  /// No description provided for @notificationAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows apps to read notifications, including messages and alerts. This may expose sensitive information.'**
  String get notificationAccessDesc;

  /// No description provided for @openNotificationAccessSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Notification Access Settings'**
  String get openNotificationAccessSettings;

  /// No description provided for @appsWithNotificationAccess.
  ///
  /// In en, this message translates to:
  /// **'Apps with Notification Access'**
  String get appsWithNotificationAccess;

  /// No description provided for @noAppsWithNotificationAccess.
  ///
  /// In en, this message translates to:
  /// **'No apps with notification access found'**
  String get noAppsWithNotificationAccess;

  /// No description provided for @descSpecialPermission.
  ///
  /// In en, this message translates to:
  /// **'High-level system permissions that can affect your privacy.'**
  String get descSpecialPermission;

  /// No description provided for @usageStatsPermission.
  ///
  /// In en, this message translates to:
  /// **'View App Usage Statistics'**
  String get usageStatsPermission;

  /// No description provided for @notificationAccessPermission.
  ///
  /// In en, this message translates to:
  /// **'Read and Monitor Notifications'**
  String get notificationAccessPermission;

  /// No description provided for @overlayPermission.
  ///
  /// In en, this message translates to:
  /// **'Appear on Top of Other Apps'**
  String get overlayPermission;

  /// No description provided for @unrestrictedBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted Battery'**
  String get unrestrictedBatteryTitle;

  /// No description provided for @unrestrictedBatteryDesc.
  ///
  /// In en, this message translates to:
  /// **'Allowed Apps to Run in Background'**
  String get unrestrictedBatteryDesc;

  /// No description provided for @doNotDisturbPermission.
  ///
  /// In en, this message translates to:
  /// **'Control Notification Interruptions'**
  String get doNotDisturbPermission;

  /// No description provided for @specialPermissionWarning.
  ///
  /// In en, this message translates to:
  /// **'This permission grants extensive access to system data.'**
  String get specialPermissionWarning;

  /// No description provided for @specialPermissionWarningDesc.
  ///
  /// In en, this message translates to:
  /// **'Only enable it for apps you trust.'**
  String get specialPermissionWarningDesc;

  /// No description provided for @usageAccessTitle2.
  ///
  /// In en, this message translates to:
  /// **'What is Usage Data Access?'**
  String get usageAccessTitle2;

  /// No description provided for @usageAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows apps to see how often and for how long other apps are used. This access can expose usage patterns that may be sensitive.'**
  String get usageAccessDesc;

  /// No description provided for @appsWithUsageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps with Usage Access'**
  String get appsWithUsageAccessTitle;

  /// No description provided for @noUsageAccessApps.
  ///
  /// In en, this message translates to:
  /// **'No apps with usage access found'**
  String get noUsageAccessApps;

  /// No description provided for @openUsageAccessSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Usage Access Settings'**
  String get openUsageAccessSettings;

  /// No description provided for @enableUsageAccessMessage.
  ///
  /// In en, this message translates to:
  /// **'To show the apps used today, please enable Usage Access permission.'**
  String get enableUsageAccessMessage;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @deviceRiskStatusTitleDanger.
  ///
  /// In en, this message translates to:
  /// **'Privacy Risks Found'**
  String get deviceRiskStatusTitleDanger;

  /// No description provided for @attentionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Attention Needed'**
  String get attentionNeeded;

  /// No description provided for @attentionNeededSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Some apps may require review'**
  String get attentionNeededSubtitle;

  /// No description provided for @mostlyProtected.
  ///
  /// In en, this message translates to:
  /// **'Mostly Protected'**
  String get mostlyProtected;

  /// No description provided for @minorRisksDetected.
  ///
  /// In en, this message translates to:
  /// **'Minor risks detected'**
  String get minorRisksDetected;

  /// No description provided for @allGood.
  ///
  /// In en, this message translates to:
  /// **'All Good'**
  String get allGood;

  /// No description provided for @yourPrivacyLooksStrong.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Looks Strong'**
  String get yourPrivacyLooksStrong;

  /// No description provided for @noAppsUseThisPermission.
  ///
  /// In en, this message translates to:
  /// **'No apps use this permission'**
  String get noAppsUseThisPermission;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used at {date} · Used today {duration}'**
  String lastUsed(String date, String duration);

  /// No description provided for @permLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get permLocation;

  /// No description provided for @permBackgroundLocation.
  ///
  /// In en, this message translates to:
  /// **'Background location'**
  String get permBackgroundLocation;

  /// No description provided for @permCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permCamera;

  /// No description provided for @permMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get permMicrophone;

  /// No description provided for @permContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get permContacts;

  /// No description provided for @permSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get permSms;

  /// No description provided for @secureSystem.
  ///
  /// In en, this message translates to:
  /// **'Secure system'**
  String get secureSystem;

  /// No description provided for @theDeviceIsSecure.
  ///
  /// In en, this message translates to:
  /// **'The device is secure'**
  String get theDeviceIsSecure;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @riskFree.
  ///
  /// In en, this message translates to:
  /// **'Risk free'**
  String get riskFree;

  /// No description provided for @highRisks.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get highRisks;

  /// No description provided for @mediumRisks.
  ///
  /// In en, this message translates to:
  /// **'Medium risk'**
  String get mediumRisks;

  /// No description provided for @lowRisks.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get lowRisks;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Tap to start the scan.'**
  String get startScan;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @permSmss.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get permSmss;

  /// No description provided for @permCallLogs.
  ///
  /// In en, this message translates to:
  /// **'Call logs'**
  String get permCallLogs;

  /// No description provided for @permPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get permPhone;

  /// No description provided for @permStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get permStorage;

  /// No description provided for @permCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get permCalendar;

  /// No description provided for @permBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get permBluetooth;

  /// No description provided for @permNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotifications;

  /// No description provided for @permSensors.
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get permSensors;

  /// No description provided for @permEnabled.
  ///
  /// In en, this message translates to:
  /// **'{label} enabled'**
  String permEnabled(String label);

  /// No description provided for @permDisabled.
  ///
  /// In en, this message translates to:
  /// **'{label} disabled'**
  String permDisabled(String label);

  /// No description provided for @usageTime.
  ///
  /// In en, this message translates to:
  /// **'Usage Time'**
  String get usageTime;

  /// No description provided for @noAppsUsedToday.
  ///
  /// In en, this message translates to:
  /// **'No apps used today'**
  String get noAppsUsedToday;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today Summary'**
  String get todaySummary;

  /// No description provided for @appsUsedToday.
  ///
  /// In en, this message translates to:
  /// **'Apps used today'**
  String get appsUsedToday;

  /// No description provided for @highRiskAppsUsed.
  ///
  /// In en, this message translates to:
  /// **'High risk apps used'**
  String get highRiskAppsUsed;

  /// No description provided for @totalUsage.
  ///
  /// In en, this message translates to:
  /// **'Total usage'**
  String get totalUsage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
