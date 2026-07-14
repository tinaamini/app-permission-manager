class PermissionConst {

  static const Set<String> normal = {
    'android.permission.INTERNET',
    'android.permission.ACCESS_NETWORK_STATE',
    'android.permission.FOREGROUND_SERVICE',
    'android.permission.POST_NOTIFICATIONS',
  };


  static const sensitive = {
    'android.permission.CAMERA',
    'android.permission.RECORD_AUDIO',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.READ_CONTACTS',
    'android.permission.WRITE_CONTACTS',
    'android.permission.READ_CALENDAR',
    'android.permission.WRITE_CALENDAR',
  };

  static const dangerous = {
    'android.permission.READ_CALL_LOG',
    'android.permission.WRITE_CALL_LOG',
    'android.permission.READ_SMS',
    'android.permission.SEND_SMS',
    'android.permission.RECEIVE_SMS',
    'android.permission.RECEIVE_MMS',
    'android.permission.ANSWER_PHONE_CALLS',
    'android.permission.READ_PHONE_STATE',
  };

  static const special = {
    'android.permission.SYSTEM_ALERT_WINDOW', // draw over other apps
    'android.permission.WRITE_SETTINGS',
    'android.permission.PACKAGE_USAGE_STATS',
    'android.permission.BIND_ACCESSIBILITY_SERVICE',
    'android.permission.MANAGE_EXTERNAL_STORAGE',
  };

  static const Set<String> callRelated = {
    'android.permission.READ_CALL_LOG',
    'android.permission.WRITE_CALL_LOG',
    'android.permission.READ_PHONE_STATE',
    'android.permission.ANSWER_PHONE_CALLS',
  };
  static const Set<String> smsRelated = {
    'android.permission.READ_SMS',
    'android.permission.SEND_SMS',
    'android.permission.RECEIVE_SMS',
    'android.permission.RECEIVE_MMS',
  };
  static const Set<String> locationRelated = {
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
  };
  static const Set<String> mediaRelated = {
    'android.permission.CAMERA',
    'android.permission.RECORD_AUDIO',
  };

  static const Map<String, Map<String, String>> displayPermissions = {
    'android.permission.CAMERA': {
      'en': 'Camera',
      'fa': 'دوربین',
    },
    'android.permission.RECORD_AUDIO': {
      'en': 'Microphone',
      'fa': 'میکروفون',
    },
    'android.permission.ACCESS_FINE_LOCATION': {
      'en': 'Precise Location',
      'fa': 'موقعیت دقیق',
    },
    'android.permission.ACCESS_COARSE_LOCATION': {
      'en': 'Approximate Location',
      'fa': 'موقعیت تقریبی',
    },
    'android.permission.READ_CONTACTS': {
      'en': 'Contacts',
      'fa': 'مخاطبین',
    },
    'android.permission.READ_CALL_LOG': {
      'en': 'Call Logs',
      'fa': 'لاگ تماس‌ها',
    },
    'android.permission.READ_SMS': {
      'en': 'SMS',
      'fa': 'پیامک‌ها',
    },
    'android.permission.SEND_SMS': {
      'en': 'Send SMS',
      'fa': 'ارسال پیامک',
    },
    'android.permission.SYSTEM_ALERT_WINDOW': {
      'en': 'Draw over apps',
      'fa': 'نمایش روی سایر برنامه‌ها',
    },
    'android.permission.PACKAGE_USAGE_STATS': {
      'en': 'Usage Access',
      'fa': 'دسترسی استفاده',
    },
    'android.permission.MANAGE_EXTERNAL_STORAGE': {
      'en': 'All Files Access',
      'fa': 'دسترسی کامل فایل‌ها',
    },
    'android.permission.READ_MEDIA_IMAGES': {
      'en': 'Photos',
      'fa': 'عکس‌ها',
    },
    'android.permission.READ_MEDIA_VIDEO': {
      'en': 'Videos',
      'fa': 'ویدیوها',
    },
    'android.permission.READ_MEDIA_AUDIO': {
      'en': 'Audio',
      'fa': 'صدا',
    },
    'android.permission.READ_EXTERNAL_STORAGE': {
      'en': 'Photos & Videos (Storage)',
      'fa': 'عکس و ویدیو (حافظه)',
    },
    'android.permission.WRITE_EXTERNAL_STORAGE': {
      'en': 'Modify Storage',
      'fa': 'ویرایش حافظه',
    },

    'android.permission.WRITE_SETTINGS': {
      'en': 'Modify System Settings',
      'fa': 'تغییر تنظیمات سیستم',
    },
    'android.permission.BIND_ACCESSIBILITY_SERVICE': {
      'en': 'Accessibility Service',
      'fa': 'سرویس دسترس‌پذیری',
    },
  };
  static const Set<String> dangerousPermissions = {
    'android.permission.CAMERA',
    'android.permission.RECORD_AUDIO',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.READ_SMS',
    'android.permission.SEND_SMS',
    'android.permission.READ_CALL_LOG',
  };
}