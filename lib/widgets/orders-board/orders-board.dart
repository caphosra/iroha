import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/order-editor.dart';
import 'package:iroha/widgets/orders-board/orders-list.dart';

///
/// 投稿済みの注文を表示するUI
///
class IrohaOrdersBoard extends StatefulWidget {
  ///
  /// 投稿済みの注文を表示するUI
  ///
  IrohaOrdersBoard({Key? key}) : super(key: key);

  @override
  _IrohaOrdersBoardState createState() => _IrohaOrdersBoardState();
}

///
/// [IrohaOrdersBoard] の状態
///
class _IrohaOrdersBoardState extends State<IrohaOrdersBoard> {
  ///
  /// テーブル番号
  ///
  int _tableNumber = 1;

  ///
  /// 料理が注文された数
  ///
  Map<String, int> _menuItemCounter = {};

  @override
  Widget build(BuildContext context) {
    return IrohaOrdersListView(
        onAddButtonClicked: () => _changeEditMode(context));
  }

  ///
  /// **(非同期)** 注文を追加するモードに切り替えます。
  ///
  Future<void> _changeEditMode(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: const Text('注文を追加'),
              content: IrohaOrderEditor(
                onOrderUpdated: _onOrderUpdated,
              ),
              actions: [
                Consumer(builder:
                    (BuildContext context, ScopedReader watch, Widget? child) {
                  return TextButton(
                      onPressed: () => _onAddButtonClicked(context, watch),
                      child: const Text('追加'));
                }),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('キャンセル'))
              ]);
        });
  }

  ///
  /// 注文が更新された時の処理を行います。
  ///
  void _onOrderUpdated(int tableNumber, Map<String, int> order) {
    _tableNumber = tableNumber;
    _menuItemCounter = order;
  }

  ///
  /// **(非同期)** 追加ボタンが押された時の処理を行います。
  ///
  Future<void> _onAddButtonClicked(
      BuildContext context, ScopedReader watch) async {
    await context
        .read(eatInOrdersProvider.notifier)
        .add(_tableNumber, _menuItemCounter);

    Navigator.pop(context);
  }
}
