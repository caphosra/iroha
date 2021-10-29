import 'package:firebase_database/firebase_database.dart';

class IrohaConfig {
  static int tableCount = 0;

  static Future<void> update() async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems = await ref.child('config').get();
    final items = rawItems.value as Map<dynamic, dynamic>;
    tableCount = items['tableCount'];
  }
}
