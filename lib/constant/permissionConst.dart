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


  static const Map<String, String> displayPermissions = {
    'android.permission.CAMERA': 'Camera',
    'android.permission.RECORD_AUDIO': 'Microphone',
    'android.permission.ACCESS_FINE_LOCATION': 'Precise Location',
    'android.permission.ACCESS_COARSE_LOCATION': 'Approximate Location',
    'android.permission.READ_CONTACTS': 'Contacts',
    'android.permission.READ_CALL_LOG': 'Call Logs',
    'android.permission.READ_SMS': 'SMS',
    'android.permission.SEND_SMS': 'Send SMS',
    'android.permission.SYSTEM_ALERT_WINDOW': 'Draw over apps',
    'android.permission.PACKAGE_USAGE_STATS': 'Usage Access',
    'android.permission.MANAGE_EXTERNAL_STORAGE': 'All Files Access',
    // Media (Android 13+)
    'android.permission.READ_MEDIA_IMAGES': 'Photos',
    'android.permission.READ_MEDIA_VIDEO': 'Videos',
    'android.permission.READ_MEDIA_AUDIO': 'Audio',

    // Storage (Android 12-)
    'android.permission.READ_EXTERNAL_STORAGE': 'Photos & Videos (Storage)',
    'android.permission.WRITE_EXTERNAL_STORAGE': 'Modify Storage',
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
