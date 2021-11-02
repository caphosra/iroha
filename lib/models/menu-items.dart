import 'package:firebase_database/firebase_database.dart';
import 'package:iroha/models/order-kind.dart';

///
/// サーバー上にあるメニュー1つ分
///
class IrohaMenuItem {
  ///
  /// メニューの名前
  ///
  final String name;

  ///
  /// メニューの価格
  ///
  final int price;

  ///
  /// サーバー上にあるメニュー1つ分
  ///
  IrohaMenuItem({required this.name, required this.price});

  ///
  /// このメニューをjson形式に変換します。
  ///
  Map<dynamic, dynamic> toJson() {
    var json = <dynamic, dynamic>{'name': name, 'price': price};
    return json;
  }

  ///
  /// json形式からメニューを読み出して返します。
  ///
  /// 必要な変数が足りない場合の挙動は保証されません。
  ///
  static IrohaMenuItem fromJson(Map<dynamic, dynamic> json) {
    return IrohaMenuItem(name: json['name'], price: json['price']);
  }
}

///
/// サーバー上にあるメニューのリスト
///
/// 内部的に [IrohaMenuItem] のリストをサーバーから取得しています。
///
class MenuItems {
  ///
  /// メニューのリスト
  ///
  List<IrohaMenuItem> items = [];

  ///
  /// メニューの種類
  ///
  final IrohaOrderKind kind;

  ///
  /// サーバー上にあるメニューのリスト
  ///
  /// 内部的に [IrohaMenuItem] のリストをサーバーから取得しています。
  ///
  MenuItems({required this.kind});

  ///
  /// **[非同期]** メニューのリストをサーバーから取得します。
  ///
  Future<void> update() async {
    final ref = FirebaseDatabase.instance.reference();
    final rawItems = await ref.child('menu-items').child(kind.get()).get();
    final values = (rawItems.value ?? {}) as Map<dynamic, dynamic>;
    items = values.entries
        .map((item) => IrohaMenuItem.fromJson(item.value))
        .toList();
  }

  ///
  /// メニューのリストをメニューの種類に基づいて取得します。
  ///
  static MenuItems getMenu(IrohaOrderKind kind) {
    switch (kind) {
      case IrohaOrderKind.EAT_IN:
        return eatInMenuItems;
      case IrohaOrderKind.TAKE_OUT:
        return takeOutMenuItems;
    }
  }
}

///
/// 店内で食べられる料理のメニュー
///
/// 'eat in'というエセ英単語については突っ込んではいけない。
///
final eatInMenuItems = MenuItems(kind: IrohaOrderKind.EAT_IN);

///
/// 持ち帰りの料理のメニュー
///
/// 'take out'というエセ英単語については突っ込んではいけない。
///
final takeOutMenuItems = MenuItems(kind: IrohaOrderKind.TAKE_OUT);
