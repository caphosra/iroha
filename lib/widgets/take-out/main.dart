import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/cashier-dialog.dart';
import 'package:iroha/widgets/common-dialog.dart';
import 'package:iroha/widgets/foods-table.dart';
import 'package:iroha/widgets/header.dart';

class IrohaTakeOut extends StatefulWidget {
  IrohaTakeOut({Key? key}) : super(key: key);

  @override
  _IrohaTakeOutState createState() => _IrohaTakeOutState();
}

class _IrohaTakeOutState extends State<IrohaTakeOut> {
  final Map<String, int> _menuItemCounter = <String, int>{};

  @override
  Widget build(BuildContext context) {
    return IrohaWithHeader(text: '持ち帰り', children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFoodsTable(context),
            TextButton(
                onPressed: _onPaymentButtonClicked,
                child: Text('支払いへ進む', style: TextStyle(fontSize: 15)))
          ])
    ]);
  }

  @override
  void initState() {
    super.initState();

    final menuNames = takeOutMenuItems.items.map((item) => item.name);

    for (var counter = 0; counter < menuNames.length; counter++) {
      _menuItemCounter[menuNames.elementAt(counter)] = 0;
    }

    setState(() {});
  }

  Widget _buildFoodsTable(BuildContext context) {
    return IrohaFoodsTable(
        data: takeOutMenuItems.items.map((item) => item.name).toList(),
        builder: (context, String item) {
          return DropdownButton<int>(
              value: _menuItemCounter[item],
              items: [
                for (int i = 0; i <= 5; i++)
                  DropdownMenuItem(
                    child: Text(i.toString(), style: TextStyle(fontSize: 15)),
                    value: i,
                  )
              ],
              onChanged: (value) {
                setState(() {
                  _menuItemCounter[item] = value ?? 0;
                });
              });
        });
  }

  Future<void> _onPaymentButtonClicked() async {
    final isPaid = await IrohaCashierDialog.show(
        context,
        IrohaFoodCount.toList(_menuItemCounter),
        IrohaFoodCount.getPrice(_menuItemCounter, IrohaOrderKind.TAKE_OUT));

    if (isPaid) {
      await context
          .read(takeOutOrdersProvider.notifier)
          .add(1, _menuItemCounter);

      await IrohaCommonDialog.showDone(context, 'サーバーに送信しました。');
    }
  }
}
