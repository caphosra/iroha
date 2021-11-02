import 'package:firebase_database/firebase_database.dart';

///
/// サーバーに保存されている設定
///
class IrohaConfig {
  ///
  /// テーブルの数
  ///
  static var tableCount = 0;

  ///
  /// サーバーにある設定を反映します。
  ///
  static Future<void> update() async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems = await ref.child('config').get();
    final items = rawItems.value as Map<dynamic, dynamic>;
    tableCount = items['tableCount'];
  }
}
