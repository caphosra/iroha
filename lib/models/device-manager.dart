import 'dart:io';

import 'package:flutter/foundation.dart';

class DeviceManager {
  static bool isAdmin() {
    return const bool.fromEnvironment('ADMIN');
  }

  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }
}
