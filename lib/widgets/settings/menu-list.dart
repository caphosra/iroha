import 'dart:math';

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';

class IrohaMenuViewer extends StatefulWidget {
  const IrohaMenuViewer({Key? key}) : super(key: key);

  @override
  _IrohaMenuViewerState createState() => _IrohaMenuViewerState();
}

class _IrohaMenuViewerState extends State<IrohaMenuViewer> {
  List<IrohaMenuItem> _menuItems = [];

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
                saveIconSize: 25,
                showCreateButton: true)));
  }

  double _getWidthFactor(double val) {
    final screenWidth = MediaQuery.of(context).size.width;
    return val * min(500, screenWidth) / screenWidth;
  }
}
