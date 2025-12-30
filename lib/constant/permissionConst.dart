class PermissionConst {
  static const sensitive = {
    'android.permission.CAMERA',
    'android.permission.RECORD_AUDIO',
    'android.permission.READ_CONTACTS',
  };

  static const dangerous = {
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.READ_SMS',
    'android.permission.SEND_SMS',
    'android.permission.READ_CALL_LOG',
  };

  static const special = {
    'android.permission.SYSTEM_ALERT_WINDOW',
    'android.permission.PACKAGE_USAGE_STATS',
    'android.permission.BIND_ACCESSIBILITY_SERVICE',
  };

  static const Map<String, String> displayPermissions = {
    'android.permission.CAMERA': 'Camera',
    'android.permission.RECORD_AUDIO': 'Microphone',
    'android.permission.ACCESS_FINE_LOCATION': 'Location (Precise)',
    'android.permission.ACCESS_COARSE_LOCATION': 'Location (Approx.)',
    'android.permission.READ_CONTACTS': 'Contacts',
    'android.permission.READ_SMS': 'SMS',
    'android.permission.SEND_SMS': 'Send SMS',
    'android.permission.READ_CALL_LOG': 'Call Logs',
    'android.permission.READ_CALENDAR': 'Calendar',
    'android.permission.BLUETOOTH': 'Bluetooth',
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
