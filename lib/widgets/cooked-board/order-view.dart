import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/widgets/dialog.dart';
import 'package:iroha/widgets/foods-table.dart';
import 'package:iroha/widgets/orders-board/order-button.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/waiting-time.dart';

///
/// 注文を表示するUI
///
class IrohaOrderView extends StatelessWidget {
  ///
  /// 注文のデータ
  ///
  final IrohaOrder data;

  ///
  /// 注文が更新される時の処理
  ///
  final void Function() onListChanged;

  ///
  /// 注文を表示するUI
  ///
  IrohaOrderView({required this.data, required this.onListChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(5),
        width: 300,
        child: Container(
            margin: const EdgeInsets.all(5),
            child: Center(child: _buildContent(context))));
  }

  ///
  /// 注文の削除ボタンが押された時の処理を行います。
  ///
  Future<void> _onDeleteButtonClicked(BuildContext context) async {
    final result =
        await IrohaDialog.showConfirm(context, '本当にこの注文を削除しますか?');

    if (result) {
      context.read(eatInOrdersProvider.notifier).delete(data.id);

      onListChanged();
    }
  }

  ///
  /// 注文の完了ボタンが押された時の処理を行います。
  ///
  Future<void> _onDoneButtonClicked(BuildContext context) async {
    final result =
        await IrohaDialog.showConfirm(context, '本当にこの注文のお届けは終わりましたか?');

    if (result) {
      context
          .read(eatInOrdersProvider.notifier)
          .markAs(data.id, IrohaOrderStatus.SERVED, DateTime.now());

      onListChanged();
    }
  }

  ///
  /// 枠内のUIの構築を行います。
  ///
  Widget _buildContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('${data.tableNumber}番テーブル', style: TextStyle(fontSize: 15)),
          IrohaFoodsTable(
              data: data.getCounts(),
              builder: (context, IrohaFoodCount food) {
                if (food.count == 0) {
                  return null;
                } else {
                  return Text(food.count.toString(),
                      style: TextStyle(fontSize: 15));
                }
              }),
          IrohaWaitingTime(duration: DateTime.now().difference(data.posted)),
          Row(children: [
            IrohaOrderButton(
                icon: Icons.check,
                color: Colors.green.shade400,
                onPressed: () => _onDoneButtonClicked(context)),
            IrohaOrderButton(
                icon: Icons.delete,
                color: Colors.red.shade400,
                onPressed: () => _onDeleteButtonClicked(context))
          ])
        ]);
  }
}
