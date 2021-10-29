import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iroha/models/config.dart';
import 'package:iroha/models/device-manager.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/widgets/bottom-bar.dart';
import 'package:iroha/widgets/cashier/main.dart';
import 'package:iroha/widgets/cooked-board/main.dart';
import 'package:iroha/widgets/home/main.dart';
import 'package:iroha/widgets/orders-board/main.dart';
import 'package:iroha/widgets/settings/main.dart';
import 'package:iroha/widgets/take-out/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await eatInMenuItems.update();
  await takeOutMenuItems.update();
  await IrohaConfig.update();

  runApp(IrohaApp());
}

class IrohaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            title: 'Iroha',
            theme:
                ThemeData(primarySwatch: Colors.blue, fontFamily: 'KiwiMaru'),
            home: IrohaAppView()));
  }
}

class IrohaAppView extends StatefulWidget {
  IrohaAppView({Key? key}) : super(key: key);

  @override
  _IrohaAppViewState createState() => _IrohaAppViewState();
}

class IrohaPage {
  final String title;
  final IconData icon;
  final Widget widget;
  final bool isAdminOnly;

  IrohaPage(
      {required this.title,
      required this.icon,
      required this.widget,
      this.isAdminOnly = false});
}

class _IrohaAppViewState extends State<IrohaAppView> {
  static List<IrohaPage> _items = [
    IrohaPage(title: 'ホーム', icon: Icons.home, widget: IrohaHome()),
    IrohaPage(
        title: '調理',
        icon: Icons.emoji_food_beverage,
        widget: IrohaOrdersBoard()),
    IrohaPage(title: '提供', icon: Icons.comment, widget: IrohaCookedBoard()),
    IrohaPage(title: '持ち帰り', icon: Icons.outbox, widget: IrohaTakeOut()),
    IrohaPage(
        title: '会計',
        icon: Icons.calculate,
        widget: IrohaCashier(),
        isAdminOnly: true),
    IrohaPage(
        title: '設定',
        icon: Icons.settings,
        widget: IrohaSettings(),
        isAdminOnly: true)
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _items
              .where((page) => (!page.isAdminOnly) || DeviceManager.isAdmin())
              .map((page) {
            return Container(
                width: min(MediaQuery.of(context).size.width, 500),
                child: page.widget);
          }).elementAt(_selectedIndex),
        ),
        extendBody: true,
        bottomNavigationBar: IrohaBottomBar(
            items: _items
                .where((page) => (!page.isAdminOnly) || DeviceManager.isAdmin())
                .toList(),
            onSelected: _onSelected),
        backgroundColor: Colors.white);
  }

  void _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
