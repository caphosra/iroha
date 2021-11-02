import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/cooked-board/order-view.dart';
import 'package:iroha/widgets/header.dart';

///
/// 準備済みの注文を表示するUI
///
class IrohaCookedBoard extends StatefulWidget {
  ///
  /// 準備済みの注文を表示するUI
  ///
  IrohaCookedBoard({Key? key}) : super(key: key);

  @override
  _IrohaCookedBoardState createState() => _IrohaCookedBoardState();
}

///
/// [IrohaCookedBoard] の状態
///
class _IrohaCookedBoardState extends State<IrohaCookedBoard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var orders = watch(eatInOrdersProvider);

      orders = orders
          .where((data) => data.cooked != null && data.served == null)
          .toList();
      orders.sort((a, b) =>
          a.posted.millisecondsSinceEpoch - b.posted.millisecondsSinceEpoch);
      final List<Widget> ordersWidgets = orders
          .map((data) =>
              IrohaOrderView(data: data, onListChanged: () => setState(() {})))
          .toList();

      return IrohaWithHeader(text: '提供', children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(child: Wrap(children: ordersWidgets)))
      ]);
    });
  }
}
