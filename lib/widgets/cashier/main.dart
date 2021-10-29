import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/config.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/cashier-dialog.dart';
import 'package:iroha/widgets/common-dialog.dart';
import 'package:iroha/widgets/header.dart';

class IrohaCashier extends StatefulWidget {
  IrohaCashier({Key? key}) : super(key: key);

  @override
  _IrohaCashierState createState() => _IrohaCashierState();
}

class _IrohaCashierState extends State<IrohaCashier> {
  int _tableNumber = 1;

  @override
  Widget build(BuildContext context) {
    return IrohaWithHeader(text: '会計', children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: DropdownButton<int>(
                    value: _tableNumber,
                    items: [
                      for (int i = 1; i <= IrohaConfig.tableCount; i++)
                        DropdownMenuItem(
                          child:
                              Text('$i番テーブル', style: TextStyle(fontSize: 25)),
                          value: i,
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _tableNumber = value ?? 0;
                      });
                    })),
            Consumer(builder: (context, watch, child) {
              final orders = watch(eatInOrdersProvider);

              return TextButton(
                  onPressed: () => onPaymentButtonPressed(context, orders),
                  child: Text('支払いへ進む', style: TextStyle(fontSize: 20)));
            })
          ])
    ]);
  }

  Future<void> onPaymentButtonPressed(
      BuildContext context, List<IrohaOrder> orders) async {
    orders = orders
        .where(
            (order) => order.tableNumber == _tableNumber && order.paid == null)
        .toList();
    Map<String, int> foods = {};
    for (final order in orders) {
      for (final food in order.getCounts()) {
        foods[food.id] = (foods[food.id] ?? 0) + food.count;
      }
    }

    bool isPaid = await IrohaCashierDialog.show(
        context,
        IrohaFoodCount.toList(foods),
        IrohaFoodCount.getPrice(foods, IrohaOrderKind.EAT_IN));

    if (isPaid) {
      for (final order in orders) {
        await context
            .read(eatInOrdersProvider.notifier)
            .markAs(order.id, IrohaOrderStatus.PAID, DateTime.now());
      }

      await IrohaCommonDialog.showDone(context, 'サーバーに送信しました。');
    }
  }
}
