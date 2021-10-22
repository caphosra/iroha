import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/models/excel-exporter.dart";
import "package:iroha/models/order-kind.dart";
import "package:iroha/models/order.dart";
import "package:iroha/widgets/header.dart";
import "package:iroha/widgets/settings/menu-list.dart";

class IrohaSettings extends StatefulWidget {
	IrohaSettings({Key? key}) : super(key: key);

	@override
    _IrohaSettingsState createState() => _IrohaSettingsState();
}

class _SubtitleText extends StatelessWidget {
	final text;

	_SubtitleText({required this.text});

	@override
    Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.fromLTRB(
				0, 25, 0, 10
			),
			child: Text(
				text,
				style: TextStyle(
					fontSize: 25,
					decoration: TextDecoration.underline,
					color: Colors.transparent,
					shadows: [
						Shadow(
							color: Colors.black,
							offset: Offset(0, -5)
						)
					],
					decorationColor: Colors.blue,
					decorationThickness: 3
				)
			)
		);
	}
}

class _IrohaSettingsState extends State<IrohaSettings> {
	@override
    Widget build(BuildContext context) {
        return IrohaWithHeader(
			text: "設定",
			children: [
				Column(
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children: [
						Container(
							padding: EdgeInsets.all(10),
							child: _SubtitleText(
								text: "サーバーデータ"
							)
						),
						Text(
							"サーバーデータをExcelファイルとしてダウンロードしたり初期化したりできます。",
							style: TextStyle(
								fontSize: 20
							)
						),
						Consumer(
							builder: (context, watch, child) {
								var eatInOrders = watch(eatInOrdersProvider);
								var takeOutOrders = watch(takeOutOrdersProvider);

								return Container(
									padding: EdgeInsets.all(10),
									child: TextButton(
										onPressed: () => _downloadOrders(eatInOrders, takeOutOrders),
										child: Text(
											"ダウンロード",
											style: TextStyle(
												fontSize: 20
											)
										)
									)
								);
							}
						),
						Container(
							padding: EdgeInsets.all(10),
							child: TextButton(
								onPressed: () { },
								child: Text(
									"初期化",
									style: TextStyle(
										fontSize: 20
									)
								)
							)
						),
						_SubtitleText(
							text: "メニューの編集"
						),
						IrohaMenuViewer()
					]
				)
			]
		);
	}

	void _downloadOrders(List<IrohaOrder> eatInOrders, List<IrohaOrder> takeOutOrders) {
		final exporter = ExcelExporter();

		exporter.generateMenuItemsPage();
		exporter.generateOrdersPage(IrohaOrderKind.EAT_IN, eatInOrders);
		exporter.generateOrdersPage(IrohaOrderKind.TAKE_OUT, takeOutOrders);
		exporter.save();
	}
}
