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
  /// 枠の色
  ///
  final Color color;

  ///
  /// 待ち時間を表示するか否か
  ///
  final bool showTime;

  ///
  /// ボタンを表示するか否か
  ///
  final bool showButtons;

  ///
  /// 注文を表示するUI
  ///
  IrohaOrderView(
      {required this.data,
      required this.onListChanged,
      this.color = Colors.blue,
      this.showTime = true,
      this.showButtons = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(5),
        width: 300,
        child: Container(
            margin: const EdgeInsets.all(5),
            child: Center(child: _buildContent(context))));
  }

  ///
  /// **[非同期]** 削除ボタンが押された時の処理を行います。
  ///
  Future<void> _onDeleteButtonClicked(BuildContext context) async {
    final result =
        await IrohaDialog.showConfirm(context, '本当にこの注文を削除しますか?');

    if (result) {
      await context.read(eatInOrdersProvider.notifier).delete(data.id);

      onListChanged();
    }
  }

  ///
  /// **[非同期]** 完了ボタンが押された時の処理を行います。
  ///
  Future<void> _onDoneButtonClicked(BuildContext context) async {
    final result =
        await IrohaDialog.showConfirm(context, '本当にこの注文を完了としますか?');

    if (result) {
      await context
          .read(eatInOrdersProvider.notifier)
          .markAs(data.id, IrohaOrderStatus.COOKED, DateTime.now());

      onListChanged();
    }
  }

  ///
  /// 枠の内側の構築を行います。
  ///
  Widget _buildContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('${data.tableNumber}番テーブル', style: TextStyle(fontSize: 15)),
          IrohaFoodsTable(
              data: data.getCounts(),
              color: color,
              builder: (context, IrohaFoodCount food) {
                if (food.count == 0) {
                  return null;
                } else {
                  return Text(food.count.toString(),
                      style: TextStyle(fontSize: 15));
                }
              }),
          showTime
              ? IrohaWaitingTime(
                  duration: DateTime.now().difference(data.posted))
              : Container(),
          showButtons
              ? Row(children: [
                  IrohaOrderButton(
                      icon: Icons.check,
                      color: Colors.green.shade400,
                      onPressed: () => _onDoneButtonClicked(context)),
                  IrohaOrderButton(
                      icon: Icons.delete,
                      color: Colors.red.shade400,
                      onPressed: () => _onDeleteButtonClicked(context))
                ])
              : Container()
        ]);
  }
}
