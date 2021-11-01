import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/header.dart';
import 'package:iroha/widgets/orders-board/order-view.dart';

///
/// 注文の表示を並べるUI
///
class IrohaOrdersListView extends StatefulWidget {
  ///
  /// 追加ボタンが押された時の処理
  ///
  final void Function() onAddButtonClicked;

  ///
  /// 注文の表示を並べるUI
  ///
  IrohaOrdersListView({required this.onAddButtonClicked, Key? key})
      : super(key: key);

  @override
  _IrohaOrdersListViewState createState() => _IrohaOrdersListViewState();
}

///
/// [IrohaOrdersListView] の状態
///
class _IrohaOrdersListViewState extends State<IrohaOrdersListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var orders = watch(eatInOrdersProvider);

      orders = orders.where((data) => data.cooked == null).toList();
      orders.sort((a, b) =>
          a.posted.millisecondsSinceEpoch - b.posted.millisecondsSinceEpoch);
      List<Widget> ordersWidgets = orders
          .map((data) =>
              IrohaOrderView(data: data, onListChanged: onListChanged))
          .toList();
      ordersWidgets.insert(0, _getAllOrders(orders));

      return Stack(children: [
        IrohaWithHeader(text: '調理', children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(child: Wrap(children: ordersWidgets)))
        ]),
        Positioned(
            child: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: widget.onAddButtonClicked),
            bottom: 110,
            right: 30)
      ]);
    });
  }

  ///
  /// 全ての注文をUIの状態で取得します。
  ///
  Widget _getAllOrders(List<IrohaOrder> orders) {
    final counter = Map<String, int>();
    for (final order in orders) {
      if (order.cooked != null) continue;
      for (final item in order.foods.entries) {
        counter[item.key] = (counter[item.key] ?? 0) + item.value;
      }
    }
    final data = IrohaOrder(
        id: 'top', posted: DateTime.now(), tableNumber: 0, foods: counter);
    return IrohaOrderView(
        data: data,
        onListChanged: () {},
        color: Colors.red,
        showTime: false,
        showButtons: false);
  }

  ///
  /// 注文のリストが更新された時の処理を行います。
  ///
  onListChanged() {
    setState(() {});
  }
}
