import 'dart:math';

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';

///
/// メニューを編集するためのUI
///
class IrohaMenuViewer extends StatefulWidget {
  ///
  /// メニューを編集するためのUI
  ///
  const IrohaMenuViewer({Key? key}) : super(key: key);

  @override
  _IrohaMenuViewerState createState() => _IrohaMenuViewerState();
}

///
/// [IrohaMenuViewer] の状態
///
class _IrohaMenuViewerState extends State<IrohaMenuViewer> {
  ///
  /// メニューのリスト
  ///
  List<IrohaMenuItem> _menuItems = [];

  ///
  /// UIの初期化を行います。
  ///
  @override
  void initState() {
    _menuItems = MenuItems.getMenu(IrohaOrderKind.TAKE_OUT).items;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: min(500, MediaQuery.of(context).size.width),
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
            child: Editable(
                columns: [
              {
                'title': '名前',
                'widthFactor': _getWidthFactor(.5),
                'key': 'name'
              },
              {
                'title': '価格',
                'widthFactor': _getWidthFactor(.4),
                'key': 'price'
              }
            ],
                rows: _menuItems
                    .map((item) => {'name': item.name, 'price': item.price})
                    .toList(),
                showSaveIcon: true,
                saveIconColor: Colors.blue,
                saveIconSize: 15,
                showCreateButton: true)));
  }

  ///
  /// 表の横幅を取得します。
  ///
  double _getWidthFactor(double val) {
    final screenWidth = MediaQuery.of(context).size.width;
    return val * min(500, screenWidth) / screenWidth;
  }
}
