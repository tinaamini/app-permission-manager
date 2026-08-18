// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'نگهبان مجوزها';

  @override
  String get hello => 'سلام';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get appPermission => 'مجوزهای اپ‌ها';

  @override
  String get groupPermission => 'مجوزهای گروهی';

  @override
  String get specialPermission => 'مجوزهای ویژه';

  @override
  String get dashboard => 'داشبورد';

  @override
  String get recentApps => 'برنامه‌های اخیر';

  @override
  String get lastScann => 'آخرین اسکن';

  @override
  String get notScannedYet => 'هنوز اسکن نشده';

  @override
  String get scanToStart => 'برای شروع، اسکن کنید';

  @override
  String get justNow => 'چند ثانیه پیش';

  @override
  String minutesAgo(int count) {
    return '$count دقیقه پیش';
  }

  @override
  String hoursAgo(int count) {
    return '$count ساعت پیش';
  }

  @override
  String daysAgo(int count) {
    return '$count روز پیش';
  }

  @override
  String monthsAgo(int count) {
    return '$count ماه پیش';
  }

  @override
  String yearsAgo(int count) {
    return '$count سال پیش';
  }

  @override
  String get noRiskApps => 'اپ‌های بدون ریسک';

  @override
  String get lowRiskApps => 'اپ‌های کم‌ریسک';

  @override
  String get mediumRiskApps => 'اپ‌های متوسط';

  @override
  String get highRiskApps => 'اپ‌های پرریسک';

  @override
  String get keepApps => 'علاقه‌مندی‌ها';

  @override
  String get trustedApps => 'لیست امن';

  @override
  String riskPercent(Object percent) {
    return '$percent٪ ریسک';
  }

  @override
  String get highRisk => 'ریسک بالا';

  @override
  String get mediumRisk => 'ریسک متوسط';

  @override
  String get lowRisk => 'ریسک کم';

  @override
  String get noRisk => 'بدون ریسک';

  @override
  String get openSettings => 'باز کردن تنظیمات';

  @override
  String get trustApp => 'لیست امن';

  @override
  String get appDetailSnackBarSuccess =>
      'این برنامه به‌عنوان برنامه امن تأیید شد';

  @override
  String get appDetailSnackBarFailed =>
      'این برنامه به‌عنوان برنامه ناامن تأیید شد';

  @override
  String get untrustApp => 'حذف از لیست امن';

  @override
  String get keepApp => 'علاقه‌مندی‌ها';

  @override
  String get removeKeep => 'حذف از علاقه‌مندی‌ها';

  @override
  String get alerts => 'هشدارها';

  @override
  String get noAlerts => 'هیچ تنظیم خطرناکی یافت نشد';

  @override
  String get accessibilityEnabled => 'دسترسی‌پذیری فعال است';

  @override
  String get locationAlways => 'موقعیت مکانی روی «همیشه» تنظیم شده';

  @override
  String get sinceLastScan => 'از آخرین اسکن';

  @override
  String get newApps => 'برنامه‌های جدید';

  @override
  String get changedPermissions => 'مجوزهای تغییریافته';

  @override
  String get runScan => 'اجرای اسکن';

  @override
  String get scanning => 'در حال اسکن';

  @override
  String get onboardingTitle1 =>
      'دسترسی های قدیمی،ارزش یک بررسی تازه را دارند.';

  @override
  String get onboardingDesc1 => 'شاید بعضی از آنها خطرناک باشند!';

  @override
  String get onboardingTitle2 =>
      'همه ی برنامه ها به عکس ها و پیامک\n های شما نیاز ندارند!';

  @override
  String get onboardingDesc2 =>
      'دسترسی های ضروری را بشناسید و موارد غیر \nضروری را بررسی کنید.';

  @override
  String get onboardingTitle3 => 'در چند ثانیه،وضعیت درسترسی ها \nمشخص میشود.';

  @override
  String get onboardingDesc3 =>
      'ا Privio،دسترسی های مهم و موارد نیازمند توجه را\n در یک نگاه نشان میدهد.';

  @override
  String get skip => 'رد کردن';

  @override
  String get next => 'بعدی';

  @override
  String get getStarted => 'شروع کنید';

  @override
  String get noAppsFound => 'اپی یافت نشد';

  @override
  String get noKeepApps => 'اپی در علاقه‌مندی‌ها وجود ندارد';

  @override
  String get noTrustedApps => 'اپی در لیست امن وجود ندارد';

  @override
  String get somethingWentWrong => 'مشکلی پیش آمد';

  @override
  String get tryAgain => 'دوباره تلاش کنید';

  @override
  String get usageAccessTitle => 'دسترسی به آمار استفاده';

  @override
  String get notificationAccessTitle => 'دسترسی به اعلان‌ها';

  @override
  String get displayOverApps => 'نمایش روی سایر اپ‌ها';

  @override
  String get batteryOptimization => 'بهینه‌سازی باتری';

  @override
  String get doNotDisturb => 'مزاحم نشوید';

  @override
  String get enabled => 'فعال';

  @override
  String get disabled => 'غیرفعال';

  @override
  String get actionNeeded => 'نیاز به اقدام';

  @override
  String get review => 'بررسی';

  @override
  String get secure => 'امن';

  @override
  String get low => 'کم';

  @override
  String get appsChecked => 'اپ چک شده';

  @override
  String get categories => 'دسته‌بندی';

  @override
  String get sensitiveAccess => 'دسترسی‌های حساس';

  @override
  String get viewStates => 'مشاهده وضعیت‌ها';

  @override
  String get locationPermission => 'دسترسی به موقعیت';

  @override
  String get cameraPermission => 'دسترسی به دوربین';

  @override
  String get microphonePermission => 'دسترسی به میکروفون';

  @override
  String get contactsPermission => 'دسترسی به مخاطبین';

  @override
  String get smsPermission => 'دسترسی به پیامک';

  @override
  String get callPermission => 'دسترسی به تماس‌ها';

  @override
  String get storagePermission => 'دسترسی به حافظه';

  @override
  String get calendarPermission => 'دسترسی به تقویم';

  @override
  String get notificationPermission => 'دسترسی به اعلان‌ها';

  @override
  String get activityPermission => 'دسترسی به فعالیت';

  @override
  String get appMarkedTrusted => 'برنامه به لیست امن اضافه شد';

  @override
  String get appUntrusted => 'برنامه از لیست امن حذف شد';

  @override
  String get appAddedToKeep => 'برنامه در لیست نگه‌داری ذخیره شد';

  @override
  String get appRemovedFromKeep => 'برنامه از لیست علاقه‌مندی‌ها خارج شد';

  @override
  String get appDetails => 'جزئیات برنامه';

  @override
  String get trustedAppsExcluded => 'این برنامه از هشدارهای ریسک مستثنی است';

  @override
  String get keepAppsWarning =>
      'حذف برنامه از این لیست باعث می‌شود دوباره در نتایج اسکن «برنامه‌های پرخطر» ظاهر شود، در صورتی که مجوزهای حساسی درخواست کند.';

  @override
  String get removeFromKeepDesc =>
      'این برنامه از لیست علاقه‌مندی‌ها حذف می‌شود و مجدداً از نظر خطرات احتمالی بررسی خواهد شد.';

  @override
  String get reviewedList => 'لیست بررسی‌شده';

  @override
  String get appsWithOverlayPermission =>
      'اپ‌های دارای مجوز نمایش روی سایر برنامه‌ها';

  @override
  String get noAppsWithOverlayPermission =>
      'هیچ اپی مجوز نمایش روی سایر برنامه‌ها را ندارد';

  @override
  String get markedAsSafe => 'علامت‌گذاری شده به‌عنوان ایمن';

  @override
  String get reviewedListDesc =>
      'این برنامه‌ها را به‌صورت دستی بررسی کرده‌اید و دیگر هشدار ریسک دریافت نخواهید کرد، مگر اینکه رفتارشان تغییر کند.';

  @override
  String get removeFromKeep => 'حذف از لیست علاقه‌مندی‌ها';

  @override
  String get cancel => 'انصراف';

  @override
  String get remove => 'حذف';

  @override
  String get whiteList => 'لیست سفید';

  @override
  String get appsYouFullyTrust => 'رنامه‌هایی که کاملاً امن می‌دانید';

  @override
  String get trustedListDesc =>
      'این برنامه‌ها از تمام هشدارها و اسکن‌های امنیتی مستثنی هستند. فقط به برنامه‌هایی اعتماد کنید که کاملاً از ایمن بودنشان مطمئنید.';

  @override
  String get removeTrust => 'حذف از امن';

  @override
  String get removeTrustDesc =>
      'این برنامه مجدداً بررسی می‌شود و ممکن است هشدارهای ریسک نشان داده شود.';

  @override
  String get untrust => 'ناامن';

  @override
  String get appsWithBatteryOptimization =>
      'اپ‌های دارای دسترسی نامحدود به باتری';

  @override
  String get noAppsWithBatteryOptimization =>
      'هیچ اپی دسترسی نامحدود به باتری ندارد';

  @override
  String get appsWithDoNotDisturb => 'برنامه‌های دارای دسترسی مزاحم نشو';

  @override
  String get noAppsWithDoNotDisturb => 'هیچ برنامه‌ای دسترسی مزاحم نشو ندارد';

  @override
  String get securityOverview => 'مرور امنیتی';

  @override
  String get securityOverviewDesc =>
      'سطح ریسک این برنامه بر اساس مجوزهایی که به آن داده‌اید محاسبه می‌شود.\n\nبرخی مجوزها دسترسی گسترده‌ای به دستگاه شما فراهم می‌کنند. این مجوزها ممکن است برای برخی قابلیت‌ها لازم باشند، اما در صورت سوءاستفاده می‌توانند خطرناک باشند.\n\nریسک بالاتر به معنای مخرب بودن برنامه نیست — بلکه یعنی دسترسی بیشتری دارد.';

  @override
  String get lowRiskDesc => 'مجوزهای محدود با کمترین تأثیر';

  @override
  String get mediumRiskDesc => 'مجوزهای حساس مورد نیاز برای عملکرد اصلی برنامه';

  @override
  String get highRiskDesc =>
      'مجوزهایی که برای این نوع برنامه غیرمعمول یا غیرضروری هستند';

  @override
  String get reduceRiskTip =>
      'می‌توانید با غیرفعال کردن مجوزهایی که استفاده نمی‌شوند، ریسک را کاهش دهید. مجوزها را می‌توانید هر زمان از تنظیمات سیستم تغییر دهید.';

  @override
  String get appIsKept => 'در لیست علاقه‌مندی';

  @override
  String get kept => 'علاقه‌مندی';

  @override
  String get manual => 'دستی';

  @override
  String get youWillManuallyNavigate =>
      'برای مدیریت مجوزها، به‌صورت دستی وارد تنظیمات سیستم خواهید شد.';

  @override
  String get continueBtn => 'ادامه';

  @override
  String get trusting => 'در حال علامت‌گذاری به‌عنوان امن..';

  @override
  String get trusted => 'امن';

  @override
  String get dashboardPermission => 'داشبورد مجوزها';

  @override
  String get systemPrivacyDashboard => 'داشبورد حریم خصوصی سیستم';

  @override
  String get systemPrivacyDashboardDesc =>
      'فعالیت مجوزها را مشاهده کنید و دسترسی‌ها را مستقیماً از تنظیمات گوشی مدیریت کنید.';

  @override
  String get openPrivacy => 'باز کردن حریم خصوصی';

  @override
  String get permissionManager => 'مدیریت مجوزها';

  @override
  String get ifItDoesntOpen => 'اگر باز نشد:\nتنظیمات ← حریم خصوصی ← ...';

  @override
  String get noPreviousScan => 'هنوز اسکنی انجام نشده';

  @override
  String lastScan(String time) {
    return 'آخرین اسکن: $time';
  }

  @override
  String get changed => 'تغییر یافته';

  @override
  String get newLabel => 'جدید';

  @override
  String get runScanToCompare => 'یک اسکن اجرا کنید تا تغییرات مقایسه شوند.';

  @override
  String get noChangesSinceLastScan => 'از آخرین اسکن هیچ تغییری مشاهده نشده.';

  @override
  String get added => 'اضافه‌شده';

  @override
  String get removed => 'حذف‌شده';

  @override
  String get reviewYourAppPermissions => 'مجوزهای برنامه‌هایتان را بررسی کنید';

  @override
  String get understandYourPermissions =>
      'مجوزها را بشناسید. کنترل را در دست بگیرید.';

  @override
  String get accessibilityEnabledDesc =>
      'این مجوز به برنامه اجازه می‌دهد محتوای صفحه را بخواند و تعاملات را کنترل کند.';

  @override
  String locationAlwaysDesc(String appName) {
    return '$appName حتی زمانی که از آن استفاده نمی‌کنید به موقعیت مکانی شما دسترسی دارد.';
  }

  @override
  String get reviewInSettings => 'بررسی در تنظیمات';

  @override
  String get noSensitiveConfigurationsDetected =>
      'هیچ تنظیمات حساسی شناسایی نشد.';

  @override
  String get batteryOptimizationDesc =>
      'برخی برنامه‌ها می‌توانند بهینه‌سازی باتری را نادیده بگیرند و در پس‌زمینه به اجرا ادامه دهند، که ممکن است مصرف باتری را افزایش دهد.';

  @override
  String get openBatteryOptimizationSettings =>
      'باز کردن تنظیمات بهینه‌سازی باتری';

  @override
  String get displayOverAppsDesc =>
      'برنامه‌هایی که این مجوز را دارند می‌توانند روی سایر برنامه‌ها نمایش داده شوند. این قابلیت ممکن است برای حباب‌های چت، ابزارهای شناور یا پوشش‌های نمایشی استفاده شود.';

  @override
  String get openDisplayOverAppsSettings =>
      'باز کردن تنظیمات نمایش روی برنامه‌ها';

  @override
  String get overlayPermissionNote =>
      'اندروید اجازه نمی‌دهد برنامه‌ها مجوزهای پوشش را مستقیماً فهرست کنند. برای بررسی برنامه‌هایی با این دسترسی، از تنظیمات سیستم استفاده کنید.';

  @override
  String get displayOverOtherApps => 'نمایش روی سایر برنامه‌ها';

  @override
  String get doNotDisturbDesc =>
      'مزاحم نشوید اعلان‌ها و هشدارها را به حالت سکوت در می‌آورد. این تنظیم روی نحوه و زمان ارسال اعلان‌ها تأثیر می‌گذارد.';

  @override
  String get openDoNotDisturbSettings => 'باز کردن تنظیمات مزاحم نشوید';

  @override
  String get whatIsNotificationAccess => 'دسترسی به اعلان‌ها چیست؟';

  @override
  String get notificationAccessDesc =>
      'به برنامه‌ها اجازه می‌دهد اعلان‌ها از جمله پیام‌ها و هشدارها را بخوانند. این ممکن است اطلاعات حساس را در معرض دید قرار دهد.';

  @override
  String get openNotificationAccessSettings =>
      'باز کردن تنظیمات دسترسی به اعلان‌ها';

  @override
  String get appsWithNotificationAccess =>
      'برنامه‌های دارای دسترسی به اعلان‌ها';

  @override
  String get noAppsWithNotificationAccess =>
      'هیچ برنامه‌ای با دسترسی به اعلان‌ها یافت نشد';

  @override
  String get descSpecialPermission =>
      'مجوزهای سطح بالای سیستمی که می‌توانند بر حریم خصوصی شما تأثیر بگذارند.';

  @override
  String get usageStatsPermission => 'دسترسی به اطلاعات استفاده از برنامه‌ها';

  @override
  String get notificationAccessPermission => 'دسترسی به اعلان‌ها';

  @override
  String get overlayPermission => 'نمایش بر روی برنامه‌های دیگر';

  @override
  String get unrestrictedBatteryTitle => 'بدون محدودیت باتری';

  @override
  String get unrestrictedBatteryDesc =>
      'برنامه‌هایی که می‌توانند در پس‌زمینه اجرا شوند';

  @override
  String get doNotDisturbPermission => 'کنترل مزاحمت‌های اعلان‌ها';

  @override
  String get specialPermissionWarning =>
      'این مجوز دسترسی گسترده‌ای به داده‌های سیستم فراهم می‌کند.';

  @override
  String get specialPermissionWarningDesc =>
      'فقط برای برنامه‌هایی که به آن‌ها اعتماد دارید فعال کنید.';

  @override
  String get usageAccessTitle2 => 'دسترسی به داده‌های استفاده چیست؟';

  @override
  String get usageAccessDesc =>
      'به برنامه‌ها اجازه می‌دهد ببینند هر برنامه چند وقت و چقدر استفاده می‌شود. این دسترسی می‌تواند الگوهای استفاده شما را که ممکن است حساس باشند نشان دهد.';

  @override
  String get appsWithUsageAccessTitle => 'برنامه‌های دارای دسترسی استفاده';

  @override
  String get noUsageAccessApps => 'هیچ برنامه‌ای با دسترسی استفاده یافت نشد';

  @override
  String get openUsageAccessSettings => 'باز کردن تنظیمات دسترسی استفاده';

  @override
  String get enableUsageAccessMessage =>
      'برای نمایش برنامه‌های استفاده‌شده امروز، لطفاً دسترسی استفاده را فعال کنید.';

  @override
  String get safe => 'امن';

  @override
  String get deviceRiskStatusTitleDanger => 'ریسک‌های حریم خصوصی شناسایی شد';

  @override
  String get attentionNeeded => 'نیاز به توجه';

  @override
  String get attentionNeededSubtitle => 'برخی برنامه‌ها نیاز به بررسی دارند';

  @override
  String get mostlyProtected => 'تا حد زیادی ایمن';

  @override
  String get minorRisksDetected => 'چند ریسک جزئی شناسایی شد';

  @override
  String get allGood => 'همه‌چیز خوب است';

  @override
  String get yourPrivacyLooksStrong =>
      'حریم خصوصی شما در وضعیت مطلوبی قرار دارد';

  @override
  String get noAppsUseThisPermission =>
      'هیچ برنامه‌ای از این مجوز استفاده نمی‌کند';

  @override
  String lastUsed(String date, String duration) {
    return 'آخرین استفاده: $date · مدت استفاده امروز: $duration';
  }

  @override
  String get permLocation => 'موقعیت مکانی';

  @override
  String get permBackgroundLocation => 'موقعیت در پس‌زمینه';

  @override
  String get permCamera => 'دوربین';

  @override
  String get permMicrophone => 'میکروفون';

  @override
  String get permContacts => 'مخاطبین';

  @override
  String get permSms => 'پیامک';

  @override
  String get secureSystem => 'سیستم امن';

  @override
  String get theDeviceIsSecure => 'دستگاه ایمن است';

  @override
  String get calls => 'تماس‌ها';

  @override
  String get riskFree => 'بدون خطر';

  @override
  String get highRisks => 'خطر بالا';

  @override
  String get mediumRisks => 'خطر متوسط';

  @override
  String get lowRisks => 'کم خطر';

  @override
  String get startScan => 'برای شروع بررسی، ضربه بزنید.';

  @override
  String get photos => 'عکس ها';

  @override
  String get permSmss => ' پیامک ها';

  @override
  String get permCallLogs => 'گزارش تماس';

  @override
  String get permPhone => 'تلفن';

  @override
  String get permStorage => 'حافظه';

  @override
  String get permCalendar => 'تقویم';

  @override
  String get permBluetooth => 'بلوتوث';

  @override
  String get permNotifications => 'اعلان‌ها';

  @override
  String get permSensors => 'حسگرها';

  @override
  String permEnabled(String label) {
    return '$label فعال';
  }

  @override
  String permDisabled(String label) {
    return '$label غیرفعال';
  }

  @override
  String get usageTime => 'زمان استفاده';

  @override
  String get noAppsUsedToday => 'امروز هیچ برنامه‌ای استفاده نشده';

  @override
  String get todaySummary => 'خلاصه امروز';

  @override
  String get appsUsedToday => 'برنامه‌های استفاده شده امروز';

  @override
  String get highRiskAppsUsed => 'برنامه‌های پرخطر استفاده شده';

  @override
  String get totalUsage => 'کل زمان استفاده';
}
