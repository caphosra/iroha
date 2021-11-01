import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/models/excel-exporter.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:iroha/models/order.dart';
import 'package:iroha/widgets/header.dart';
import 'package:iroha/widgets/settings/menu-list.dart';

///
/// Irohaの設定を行うUI
///
class IrohaSettings extends StatefulWidget {
  ///
  /// Irohaの設定を行うUI
  ///
  IrohaSettings({Key? key}) : super(key: key);

  @override
  _IrohaSettingsState createState() => _IrohaSettingsState();
}

///
/// 二番目に大きい文字
///
class _SubtitleText extends StatelessWidget {
  ///
  /// 表示する文字列
  ///
  final text;

  ///
  /// 二番目に大きい文字
  ///
  const _SubtitleText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
        child: Text(text,
            style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.underline,
                color: Colors.transparent,
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                decorationColor: Colors.blue,
                decorationThickness: 3)));
  }
}

///
/// [IrohaSettings] の状態
///
class _IrohaSettingsState extends State<IrohaSettings> {
  @override
  Widget build(BuildContext context) {
    return IrohaWithHeader(text: '設定', children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: const _SubtitleText(text: 'サーバーデータ')),
            Text('サーバーデータをExcelファイルとしてダウンロードしたり初期化したりできます。',
                style: TextStyle(fontSize: 15)),
            Consumer(builder: (context, watch, child) {
              final eatInOrders = watch(eatInOrdersProvider);
              final takeOutOrders = watch(takeOutOrdersProvider);

              return Container(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                      onPressed: () =>
                          _downloadOrders(eatInOrders, takeOutOrders),
                      child: const Text('ダウンロード',
                          style: TextStyle(fontSize: 15))));
            }),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {},
                    child: const Text('初期化', style: TextStyle(fontSize: 15)))),
            const _SubtitleText(text: 'メニューの編集'),
            IrohaMenuViewer()
          ])
    ]);
  }

  ///
  /// 注文をExcelファイルにして保存します。
  ///
  void _downloadOrders(
      List<IrohaOrder> eatInOrders, List<IrohaOrder> takeOutOrders) {
    final exporter = ExcelExporter();

    exporter.generateMenuItemsPage();
    exporter.generateOrdersPage(IrohaOrderKind.EAT_IN, eatInOrders);
    exporter.generateOrdersPage(IrohaOrderKind.TAKE_OUT, takeOutOrders);
    exporter.save();
  }
}
