import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iroha/models/device-manager.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:uuid/uuid.dart';

///
/// サーバーにある注文1つ
///
class IrohaOrder extends Comparable<IrohaOrder> {
  ///
  /// 注文のID
  ///
  /// Irohaで作成した注文ならばここのIDとしてUUIDが利用されます。
  ///
  final String id;

  ///
  /// 注文をしたテーブル番号
  ///
  final int tableNumber;

  ///
  /// 注文をサーバーに投稿した時刻
  ///
  DateTime posted;

  ///
  /// 料理の準備が終了した時刻
  ///
  DateTime? cooked;

  ///
  /// 料理を届けた時刻
  ///
  DateTime? served;

  ///
  /// 注文の会計が完了した時刻
  ///
  DateTime? paid;

  ///
  /// 注文の内容
  ///
  /// メニューの名前をkeyとして注文した料理の数をvalueとした`Map`で保持しています。
  ///
  /// ```dart
  /// order.foods["クッキー"]; // クッキーの個数
  /// ```
  ///
  final Map<String, int> foods;

  ///
  /// サーバーにある注文1つ
  ///
  IrohaOrder(
      {required this.id,
      required this.posted,
      required this.tableNumber,
      required this.foods});

  ///
  /// 注文の状態を変更します。
  ///
  /// 変更にはアクションが起こされた時刻が必要です。
  ///
  void markAs(IrohaOrderStatus status, DateTime time) {
    switch (status) {
      case IrohaOrderStatus.POSTED:
        posted = time;
        break;
      case IrohaOrderStatus.COOKED:
        cooked = time;
        break;
      case IrohaOrderStatus.SERVED:
        served = time;
        break;
      case IrohaOrderStatus.PAID:
        paid = time;
        break;
    }
  }

  ///
  /// メニューの内容を [IrohaFoodCount] のリストへと変換します。
  ///
  /// [IrohaFoodCount.toList] と同一の動作をします。
  ///
  List<IrohaFoodCount> getCounts() => IrohaFoodCount.toList(foods);

  ///
  /// この注文をjson形式に変換します。
  ///
  Map<dynamic, dynamic> toJson() {
    final json = <dynamic, dynamic>{
      'tableNumber': tableNumber,
      'posted': posted.toString(),
      'cooked': cooked.toString(),
      'served': served.toString(),
      'paid': paid.toString()
    };
    json.addAll(foods);
    return json;
  }

  ///
  /// json形式からメニューを読み出して返します。
  ///
  /// 必要な変数が足りない場合の挙動は保証されません。
  ///
  static IrohaOrder fromJson(
      String id, Map<dynamic, dynamic> json, MenuItems menu) {
    var order = IrohaOrder(
        id: id,
        tableNumber: json['tableNumber'],
        posted: DateTime.parse(json['posted']),
        foods: {});
    order.cooked = DateTime.tryParse(json['cooked']);
    order.served = DateTime.tryParse(json['served']);
    order.paid = DateTime.tryParse(json['paid']);
    for (final item in menu.items.map((item) => item.name)) {
      order.foods[item] = json[item];
    }
    return order;
  }

  ///
  /// メニューを時間で並びかえできるように比較できるようにします。
  ///
  @override
  int compareTo(IrohaOrder other) {
    final duration =
        posted.millisecondsSinceEpoch - other.posted.millisecondsSinceEpoch;
    return duration;
  }
}

///
/// 注文の状態
///
enum IrohaOrderStatus { POSTED, COOKED, SERVED, PAID }

///
/// 料理とそれがいくつ注文されたかを保持するもの
///
class IrohaFoodCount {
  ///
  /// メニューの名前
  ///
  final String id;

  ///
  /// 注文された数
  ///
  final int count;

  ///
  /// 料理とそれがいくつ注文されたかを保持するもの
  ///
  IrohaFoodCount({required this.id, required this.count});

  ///
  /// メニューの内容を [IrohaFoodCount] のリストへと変換します。
  ///
  static List<IrohaFoodCount> toList(Map<String, int> counts) {
    return counts.entries
        .map((item) => IrohaFoodCount(id: item.key, count: item.value))
        .toList();
  }

  ///
  /// 価格を計算します。
  ///
  static int getPrice(Map<String, int> counts, IrohaOrderKind kind) {
    var price = 0;
    for (final item in MenuItems.getMenu(kind).items) {
      price += (counts[item.name] ?? 0) * item.price;
    }
    return price;
  }

  ///
  /// メニューの名前を文字列として返します。
  ///
  @override
  String toString() {
    return id;
  }
}

///
/// [Map] の拡張
///
extension MapEx on Map<String, int> {
  ///
  /// メニューを保持している`Map<String, int>`を
  /// [IrohaFoodCount] のリストへと変換します。
  ///
  List<IrohaFoodCount> toFoodCounts() => entries
      .map((item) => IrohaFoodCount(id: item.key, count: item.value))
      .toList();
}

///
/// サーバー上にある注文のリスト
///
class IrohaOrderList extends StateNotifier<List<IrohaOrder>> {
  ///
  /// 注文の種類
  ///
  final IrohaOrderKind kind;

  ///
  /// サーバー上にある注文のリスト
  ///
  IrohaOrderList({required this.kind, List<IrohaOrder>? initial})
      : super(initial ?? []);

  ///
  /// **[非同期]** サーバーに注文を追加します。
  ///
  Future<void> add(int tableNumber, Map<String, int> foods) async {
    final uuid = Uuid().v4();
    final order = IrohaOrder(
        id: uuid,
        posted: DateTime.now(),
        tableNumber: tableNumber,
        foods: foods);
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').child(kind.get()).child(uuid).set(order.toJson());
  }

  ///
  /// **[非同期]** サーバーにある注文を削除します。
  ///
  Future<void> delete(String id) async {
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').child(kind.get()).child(id).remove();
  }

  ///
  /// **[非同期]** サーバーにあるデータを読み込みます。
  ///
  Future<void> update() async {
    state = await _downloadData();
  }

  ///
  /// **[非同期]** 注文の状態を変更します。
  ///
  Future<void> markAs(String id, IrohaOrderStatus status, DateTime time) async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems =
        await ref.child('orders').child(kind.get()).child(id).get();

    var value = rawItems.value as Map<dynamic, dynamic>;

    if (DeviceManager.isIOS()) {
      value = value[id] as Map<dynamic, dynamic>;
    }

    final items = IrohaOrder.fromJson(id, value, MenuItems.getMenu(kind));

    items.markAs(status, time);
    await ref.child('orders').child(kind.get()).child(id).set(items.toJson());
  }

  ///
  /// **[非同期]** サーバーにある注文を全て削除します。
  ///
  Future<void> resetAll() async {
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').remove();
  }

  ///
  /// **[非同期]** 注文が変更されていないか監視し、変更があれば更新します。
  ///
  Future<void> keepWatching() async {
    final ref = FirebaseDatabase.instance.reference();
    final stream = ref.child('orders').child(kind.get()).onValue;
    await for (final event in stream) {
      final items = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;
      state = _toList(items);
    }
  }

  ///
  /// **[非同期]** サーバーにあるデータを読み込みます。
  ///
  /// [IrohaOrderList.update] と違い、更新は行いません。
  ///
  Future<List<IrohaOrder>> _downloadData() async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems = await ref.child('orders').child(kind.get()).get();
    final items = rawItems.value as Map<dynamic, dynamic>;

    return _toList(items);
  }

  ///
  /// サーバーから取得したデータを注文へと変換します。
  ///
  List<IrohaOrder> _toList(Map<dynamic, dynamic> items) {
    return items.entries.map((order) {
      return IrohaOrder.fromJson(
          order.key, order.value, MenuItems.getMenu(kind));
    }).toList();
  }
}

///
/// 店内での注文
///
final eatInOrdersProvider =
    StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
  ref.onDispose(() {});

  final dataList = IrohaOrderList(kind: IrohaOrderKind.EAT_IN);
  dataList.keepWatching();

  return dataList;
});

///
/// 持ち帰りの注文
///
final takeOutOrdersProvider =
    StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
  ref.onDispose(() {});

  final dataList = IrohaOrderList(kind: IrohaOrderKind.TAKE_OUT);

  return dataList;
});
