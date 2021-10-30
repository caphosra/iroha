import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iroha/models/device-manager.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:uuid/uuid.dart';

typedef IrohaMenuID = String;

class IrohaOrder extends Comparable<IrohaOrder> {
  final String id;
  final int tableNumber;
  DateTime posted;
  DateTime? cooked;
  DateTime? served;
  DateTime? paid;
  final Map<IrohaMenuID, int> foods;

  IrohaOrder(
      {required this.id,
      required this.posted,
      required this.tableNumber,
      required this.foods});

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

  List<IrohaFoodCount> getCounts() => foods.entries
      .map((item) => IrohaFoodCount(id: item.key, count: item.value))
      .toList();

  Map<dynamic, dynamic> toJson() {
    var json = <dynamic, dynamic>{
      'tableNumber': tableNumber,
      'posted': posted.toString(),
      'cooked': cooked.toString(),
      'served': served.toString(),
      'paid': paid.toString()
    };
    json.addAll(foods);
    return json;
  }

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

  @override
  int compareTo(IrohaOrder other) {
    final duration =
        posted.millisecondsSinceEpoch - other.posted.millisecondsSinceEpoch;
    return duration;
  }
}

enum IrohaOrderStatus { POSTED, COOKED, SERVED, PAID }

class IrohaFoodCount {
  IrohaMenuID id;
  int count;

  IrohaFoodCount({required this.id, required this.count});

  static List<IrohaFoodCount> toList(Map<String, int> counts) {
    return counts.entries
        .map((item) => IrohaFoodCount(id: item.key, count: item.value))
        .toList();
  }

  static int getPrice(Map<String, int> counts, IrohaOrderKind kind) {
    int price = 0;
    for (final item in MenuItems.getMenu(kind).items) {
      price += (counts[item.name] ?? 0) * item.price;
    }
    return price;
  }

  @override
  String toString() {
    return id;
  }
}

class IrohaOrderList extends StateNotifier<List<IrohaOrder>> {
  final IrohaOrderKind kind;

  IrohaOrderList({required this.kind, List<IrohaOrder>? initial})
      : super(initial ?? []);

  Future<void> add(int tableNumber, Map<IrohaMenuID, int> foods) async {
    final uuid = Uuid().v4();
    final order = IrohaOrder(
        id: uuid,
        posted: DateTime.now(),
        tableNumber: tableNumber,
        foods: foods);
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').child(kind.get()).child(uuid).set(order.toJson());
  }

  Future<void> delete(String id) async {
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').child(kind.get()).child(id).remove();
  }

  Future<void> update() async {
    state = await _downloadData();
  }

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

  Future<void> resetAll() async {
    final ref = FirebaseDatabase.instance.reference();
    await ref.child('orders').remove();
  }

  Future<void> keepWatching() async {
    final ref = FirebaseDatabase.instance.reference();
    final stream = ref.child('orders').child(kind.get()).onValue;
    await for (final event in stream) {
      final items = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;
      state = _toList(items);
    }
  }

  Future<List<IrohaOrder>> _downloadData() async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems = await ref.child('orders').child(kind.get()).get();
    final items = rawItems.value as Map<dynamic, dynamic>;

    return _toList(items);
  }

  List<IrohaOrder> _toList(Map<dynamic, dynamic> items) {
    return items.entries.map((order) {
      return IrohaOrder.fromJson(
          order.key, order.value, MenuItems.getMenu(kind));
    }).toList();
  }
}

final eatInOrdersProvider =
    StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
  ref.onDispose(() {});

  var dataList = IrohaOrderList(kind: IrohaOrderKind.EAT_IN);
  dataList.keepWatching();

  return dataList;
});

final takeOutOrdersProvider =
    StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
  ref.onDispose(() {});

  var dataList = IrohaOrderList(kind: IrohaOrderKind.TAKE_OUT);

  return dataList;
});
