// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Permission Guard';

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome';

  @override
  String get appPermission => 'App Permissions';

  @override
  String get groupPermission => 'Group Permissions';

  @override
  String get specialPermission => 'Special Permissions';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get recentApps => 'Recent Apps';

  @override
  String get lastScann => 'Last Scan';

  @override
  String get notScannedYet => 'Not scanned yet';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String monthsAgo(int count) {
    return '$count months ago';
  }

  @override
  String yearsAgo(int count) {
    return '$count years ago';
  }

  @override
  String get noRiskApps => 'No Risk Apps';

  @override
  String get lowRiskApps => 'Low Risk Apps';

  @override
  String get mediumRiskApps => 'Medium Risk Apps';

  @override
  String get highRiskApps => 'High Risk Apps';

  @override
  String get keepApps => 'KEEP APPS';

  @override
  String get trustedApps => 'Trusted Apps';

  @override
  String riskPercent(Object percent) {
    return '$percent% RISK';
  }

  @override
  String get highRisk => 'High Risk';

  @override
  String get mediumRisk => 'Medium Risk';

  @override
  String get lowRisk => 'Low Risk';

  @override
  String get noRisk => 'No Risk';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get trustApp => 'Trust App';

  @override
  String get appDetailSnackBarSuccess => 'App marked as Trusted';

  @override
  String get appDetailSnackBarFailed => 'App untrusted';

  @override
  String get untrustApp => 'Untrust';

  @override
  String get keepApp => 'Keep App';

  @override
  String get removeKeep => 'Remove from Keep';

  @override
  String get alerts => 'Alerts';

  @override
  String get noAlerts => 'No sensitive configurations detected';

  @override
  String get accessibilityEnabled => 'Accessibility enabled';

  @override
  String get locationAlways => 'Location set to \"Always\"';

  @override
  String get sinceLastScan => 'Since last Scan';

  @override
  String get newApps => 'New apps';

  @override
  String get changedPermissions => 'Changed permissions';

  @override
  String get runScan => 'Run scan';

  @override
  String get scanning => 'Scanning';

  @override
  String get onboardingTitle1 => 'Complete\n Transparency';

  @override
  String get onboardingDesc1 =>
      'We scan every app on your device to \n reveal exactly what data they\'re accessing \n behind the scenes.';

  @override
  String get onboardingTitle2 => 'Risk \n Intelligence';

  @override
  String get onboardingDesc2 =>
      'Our system\n  categorizes apps into\n risk levels to keep you safe.';

  @override
  String get onboardingTitle3 => 'Take \n Control';

  @override
  String get onboardingTitle4 => 'Choose Your\n Language';

  @override
  String get onboardingDesc3 =>
      'Easily manage permissions \n and trust the apps you know.';

  @override
  String get onboardingDesc4 =>
      'Select your preferred language to\n personalize your experience.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get noAppsFound => 'No applications found';

  @override
  String get noKeepApps => 'NO KEEP APP';

  @override
  String get noTrustedApps => 'NO TRUSTED APP';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get usageAccessTitle => 'Usage Data Access';

  @override
  String get notificationAccessTitle => 'Notification Access';

  @override
  String get displayOverApps => 'Display over other apps';

  @override
  String get batteryOptimization => 'Battery Optimization';

  @override
  String get doNotDisturb => 'Do Not Disturb';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get actionNeeded => 'ACTION NEEDED';

  @override
  String get review => 'REVIEW';

  @override
  String get secure => 'SECURE';

  @override
  String get low => 'Low';

  @override
  String get appsChecked => 'Apps Checked';

  @override
  String get categories => 'Categories';

  @override
  String get sensitiveAccess => 'Sensitive Access';

  @override
  String get viewStates => 'View States';

  @override
  String get locationPermission => 'Location Access';

  @override
  String get cameraPermission => 'Camera Access';

  @override
  String get microphonePermission => 'Microphone Access';

  @override
  String get contactsPermission => 'Contacts Access';

  @override
  String get smsPermission => 'SMS Access';

  @override
  String get callPermission => 'Call Access';

  @override
  String get storagePermission => 'Storage Access';

  @override
  String get calendarPermission => 'Calendar Access';

  @override
  String get notificationPermission => 'Notifications Access';

  @override
  String get activityPermission => 'Activity Access';

  @override
  String get appMarkedTrusted => 'App marked as Trusted';

  @override
  String get appUntrusted => 'App untrusted';

  @override
  String get appAddedToKeep => 'App added to Keep list';

  @override
  String get appRemovedFromKeep => 'App removed from Keep list';

  @override
  String get appDetails => 'APP DETAILS';

  @override
  String get trustedAppsExcluded =>
      'Trusted apps are excluded from risk warnings';

  @override
  String get keepAppsWarning =>
      'Removing an app from this list will return it to the \"Risk Apps\" scan result if it requests sensitive permissions in the future.';

  @override
  String get removeFromKeepDesc =>
      'This app will no longer be trusted and will be analyzed again for potential risks.';

  @override
  String get reviewedList => 'REVIEWED LIST';

  @override
  String get markedAsSafe => 'Marked as Safe';

  @override
  String get reviewedListDesc =>
      'These are apps you have manually reviewed. They will no longer trigger risk warnings unless their behavior changes significantly.';

  @override
  String get removeFromKeep => 'Remove from Keep';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get whiteList => 'WHITE LIST';

  @override
  String get appsYouFullyTrust => 'Apps you fully trust';

  @override
  String get trustedListDesc =>
      'These applications are excluded from all risk alerts and security scans. Only trust apps you are certain are safe.';

  @override
  String get removeTrust => 'Remove Trust';

  @override
  String get removeTrustDesc =>
      'This app will be analyzed again and may show risk warnings.';

  @override
  String get untrust => 'Untrust';

  @override
  String get securityOverview => 'Security Overview';

  @override
  String get securityOverviewDesc =>
      'This app\'s risk level is calculated based on the permissions you have granted.\n\nSome permissions provide powerful access to your device. While they may be required for certain features, they can increase potential impact if misused.\n\nA higher risk does not mean the app is malicious — it means it has greater access.';

  @override
  String get lowRiskDesc => 'Limited permissions with minimal impact';

  @override
  String get mediumRiskDesc =>
      'Sensitive permissions required for core features';

  @override
  String get highRiskDesc =>
      'Permissions that are unusual or unnecessary for this type of app';

  @override
  String get reduceRiskTip =>
      'You can reduce risk by disabling permissions that are not actively used. Permissions can be changed at any time from system settings.';

  @override
  String get appIsKept => 'App is Kept';

  @override
  String get kept => 'Kept';

  @override
  String get manual => 'Manual';

  @override
  String get youWillManuallyNavigate =>
      'You will manually navigate through the system settings to manage app permissions.';

  @override
  String get continueBtn => 'Continue';

  @override
  String get trusting => 'Trusting...';

  @override
  String get trusted => 'Trusted';

  @override
  String get dashboardPermission => 'DASHBOARD PERMISSION';

  @override
  String get systemPrivacyDashboard => 'System Privacy Dashboard';

  @override
  String get systemPrivacyDashboardDesc =>
      'View permission activity and manage access directly in your phone settings.';

  @override
  String get openPrivacy => 'Open Privacy';

  @override
  String get permissionManager => 'Permission Manager';

  @override
  String get ifItDoesntOpen => 'If it doesn\'t open:\nSettings → Privacy → ...';

  @override
  String get noPreviousScan => 'No previous scan yet';

  @override
  String lastScan(String time) {
    return 'Last Scan: $time';
  }

  @override
  String get changed => 'CHANGED';

  @override
  String get newLabel => 'NEW';

  @override
  String get runScanToCompare => 'Run a scan to compare changes.';

  @override
  String get noChangesSinceLastScan => 'No changes since the last scan.';

  @override
  String get added => 'Added';

  @override
  String get removed => 'Removed';

  @override
  String get reviewYourAppPermissions => 'Review your app permissions';

  @override
  String get understandYourPermissions =>
      'Understand your permissions. Stay in control.';

  @override
  String get accessibilityEnabledDesc =>
      'This permission allows an app to read screen content and control interactions.';

  @override
  String locationAlwaysDesc(String appName) {
    return '$appName can access your location even when you\'re not using it.';
  }

  @override
  String get reviewInSettings => 'Review in Settings';

  @override
  String get noSensitiveConfigurationsDetected =>
      'No sensitive configurations detected.';

  @override
  String get batteryOptimizationDesc =>
      'Some apps can ignore battery optimizations and continue running in the background, which may increase battery usage.';

  @override
  String get openBatteryOptimizationSettings =>
      'Open Battery Optimization Settings';

  @override
  String get displayOverAppsDesc =>
      'Apps with this permission can appear on top of other apps. This may be used for chat heads, floating tools, or overlays.';

  @override
  String get openDisplayOverAppsSettings => 'Open Display Over Apps Settings';

  @override
  String get overlayPermissionNote =>
      'Android does not allow apps to list overlay permissions directly. To review apps with this access, use the system settings.';

  @override
  String get displayOverOtherApps => 'Display over other apps';

  @override
  String get doNotDisturbDesc =>
      'Do Not Disturb silences notifications and alerts. This setting affects how and when notifications are delivered.';

  @override
  String get openDoNotDisturbSettings => 'Open Do Not Disturb Settings';

  @override
  String get whatIsNotificationAccess => 'What is Notification Access?';

  @override
  String get notificationAccessDesc =>
      'Allows apps to read notifications, including messages and alerts. This may expose sensitive information.';

  @override
  String get openNotificationAccessSettings =>
      'Open Notification Access Settings';

  @override
  String get appsWithNotificationAccess => 'Apps with Notification Access';

  @override
  String get noAppsWithNotificationAccess =>
      'No apps with notification access found';

  @override
  String get descSpecialPermission =>
      'High-level system permissions that can affect your privacy.';

  @override
  String get usageStatsPermission => 'View App Usage Statistics';

  @override
  String get notificationAccessPermission => 'Read and Monitor Notifications';

  @override
  String get overlayPermission => 'Appear on Top of Other Apps';

  @override
  String get unrestrictedBatteryTitle => 'Unrestricted Battery';

  @override
  String get unrestrictedBatteryDesc => 'Allowed Apps to Run in Background';

  @override
  String get doNotDisturbPermission => 'Control Notification Interruptions';

  @override
  String get specialPermissionWarning =>
      'This permission grants extensive access to system data.';

  @override
  String get specialPermissionWarningDesc =>
      'Only enable it for apps you trust.';

  @override
  String get usageAccessTitle2 => 'What is Usage Data Access?';

  @override
  String get usageAccessDesc =>
      'Allows apps to see how often and for how long other apps are used. This access can expose usage patterns that may be sensitive.';

  @override
  String get appsWithUsageAccessTitle => 'Apps with Usage Access';

  @override
  String get noUsageAccessApps => 'No apps with usage access found';

  @override
  String get openUsageAccessSettings => 'Open Usage Access Settings';

  @override
  String get enableUsageAccessMessage =>
      'To show the apps used today, please enable Usage Access permission.';

  @override
  String get safe => 'Safe';

  @override
  String get deviceRiskStatusTitleDanger => 'Privacy Risks Found';

  @override
  String get attentionNeeded => 'Attention Needed';

  @override
  String get attentionNeededSubtitle => 'Some apps may require review';

  @override
  String get mostlyProtected => 'Mostly Protected';

  @override
  String get minorRisksDetected => 'Minor risks detected';

  @override
  String get allGood => 'All Good';

  @override
  String get yourPrivacyLooksStrong => 'Your Privacy Looks Strong';

  @override
  String get noAppsUseThisPermission => 'No apps use this permission';

  @override
  String lastUsed(String date, String duration) {
    return 'Last used at $date · Used today $duration';
  }

  @override
  String get permLocation => 'Location';

  @override
  String get permBackgroundLocation => 'Background location';

  @override
  String get permCamera => 'Camera';

  @override
  String get permMicrophone => 'Microphone';

  @override
  String get permContacts => 'Contacts';

  @override
  String get permSms => 'SMS';

  @override
  String get permCallLogs => 'Call logs';

  @override
  String get permPhone => 'Phone';

  @override
  String get permStorage => 'Storage';

  @override
  String get permCalendar => 'Calendar';

  @override
  String get permBluetooth => 'Bluetooth';

  @override
  String get permNotifications => 'Notifications';

  @override
  String get permSensors => 'Sensors';

  @override
  String permEnabled(String label) {
    return '$label enabled';
  }

  @override
  String permDisabled(String label) {
    return '$label disabled';
  }

  @override
  String get usageTime => 'Usage Time';

  @override
  String get noAppsUsedToday => 'No apps used today';

  @override
  String get todaySummary => 'Today Summary';

  @override
  String get appsUsedToday => 'Apps used today';

  @override
  String get highRiskAppsUsed => 'High risk apps used';

  @override
  String get totalUsage => 'Total usage';
}
