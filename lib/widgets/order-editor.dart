import 'package:flutter/material.dart';
import 'package:iroha/models/config.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/widgets/foods-table.dart';

///
/// 注文を作成する為のUI
///
class IrohaOrderEditor extends StatefulWidget {
  ///
  /// 注文が更新された時の処理
  ///
  final void Function(int tableNumber, Map<String, int> order) onOrderUpdated;

  IrohaOrderEditor({required this.onOrderUpdated, Key? key}) : super(key: key);

  @override
  _IrohaOrderEditorState createState() => _IrohaOrderEditorState();
}

///
/// [IrohaOrderEditor] の状態
///
class _IrohaOrderEditorState extends State<IrohaOrderEditor> {
  ///
  /// テーブル番号
  ///
  int _tableNumber = 1;

  ///
  /// メニューと個数のリスト
  ///
  final Map<String, int> _menuItemCounter = {};

  @override
  void initState() {
    super.initState();

    final menuNames = eatInMenuItems.items.map((item) => item.name);

    for (var counter = 0; counter < menuNames.length; counter++) {
      _menuItemCounter[menuNames.elementAt(counter)] = 0;
    }

    widget.onOrderUpdated(_tableNumber, _menuItemCounter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 30,
              child: _buildTableDropDown(context),
            ),
            const Text('番テーブル', style: TextStyle(fontSize: 15))
          ]),
          _buildFoodsTable(context)
        ]);
  }

  ///
  /// 個数を選択するドロップダウンを生成します。
  ///
  Widget _buildTableDropDown(BuildContext context) {
    return DropdownButton<int>(
        value: _tableNumber,
        isExpanded: true,
        items: [
          for (var i = 1; i <= IrohaConfig.tableCount; i++)
            DropdownMenuItem(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(i.toString(),
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.right)),
                value: i)
        ],
        onChanged: (value) {
          setState(() {
            _tableNumber = value ?? 1;

            widget.onOrderUpdated(_tableNumber, _menuItemCounter);
          });
        });
  }

  ///
  /// メニューと個数の表を生成します。
  ///
  Widget _buildFoodsTable(BuildContext context) {
    return IrohaFoodsTable(
        data: eatInMenuItems.items.map((item) => item.name).toList(),
        builder: (context, String item) {
          return DropdownButton<int>(
              value: _menuItemCounter[item],
              items: [
                for (var i = 0; i <= 5; i++)
                  DropdownMenuItem(
                      child: Text(i.toString(), style: TextStyle(fontSize: 15)),
                      value: i)
              ],
              onChanged: (value) {
                setState(() {
                  _menuItemCounter[item] = value ?? 0;

                  widget.onOrderUpdated(_tableNumber, _menuItemCounter);
                });
              });
        });
  }
}
