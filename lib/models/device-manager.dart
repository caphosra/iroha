import 'dart:io';

import 'package:flutter/foundation.dart';

///
/// 各デバイスによって異なる要素を管理する
///
class DeviceManager {
  ///
  /// 管理者モードであるか取得します。
  ///
  /// ビルドする際に`--dart-define ADMIN='true'`というオプションをつけることで
  /// 管理者モードへと移行できます。
  ///
  static bool isAdmin() {
    return const bool.fromEnvironment('ADMIN');
  }

  ///
  /// 現在の環境がiOSであるか取得します。
  ///
  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }
}
