import 'package:flutter/material.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/foods-table.dart';

///
/// Irohaの実装で使われるダイアログ
///
class IrohaDialog {
  ///
  /// 完了を確認するダイアログを表示します。
  ///
  static Future<void> showDone(BuildContext context, String text) async {
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              title: const Text('完了'),
              content: Text(text),
              actions: [
                TextButton(
                    child: const Text('りょうかい'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  ///
  /// "はい"と"いいえ"の意志確認するダイアログを表示します。
  ///
  static Future<bool> showConfirm(BuildContext context, String text) async {
    final bool result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              title: const Text('確認'),
              content: Text(text),
              actions: [
                TextButton(
                    child: const Text('やっぱりやめる'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                    child: const Text('もちろん'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    })
              ]);
        });

    return result;
  }

  ///
  /// 会計を行うダイアログを表示します。
  ///
  static Future<bool> showCashier(
      BuildContext context, List<IrohaFoodCount> items, int price) async {
    final bool isPaid = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
              title: const Text('お会計'),
              content: SingleChildScrollView(
                  child: ListBody(children: [
                const Text('以下の注文でOKですか?'),
                IrohaFoodsTable<IrohaFoodCount>(
                    data: items, builder: _buildTable),
                Center(child: Text('$price円', style: TextStyle(fontSize: 30)))
              ])),
              actions: [
                TextButton(
                    child: const Text('支払い完了'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }),
                TextButton(
                    child: const Text('キャンセル'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    })
              ]);
        });

    return isPaid;
  }

  ///
  /// 表の中身を生成します。
  ///
  /// [IrohaDialog.showCashier] の内部で使用されます。
  ///
  static Widget _buildTable(BuildContext context, IrohaFoodCount food) {
    return Text(food.count.toString(), style: TextStyle(fontSize: 15));
  }
}
