import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/models/menu-items.dart";
import "package:iroha/models/order.dart";
import "package:iroha/widgets/foods-table.dart";

class IrohaTakeOut extends StatefulWidget {
	IrohaTakeOut({Key? key}) : super(key: key);

	@override
    _IrohaTakeOutState createState() => _IrohaTakeOutState();
}

class _IrohaTakeOutState extends State<IrohaTakeOut> {
	final Map<String, int> _menuItemCounter = <String, int>{ };

	@override
    Widget build(BuildContext context) {
        return Stack(
			children: [
				ListView(
					children: <Widget>[
						Center(
							child: Text(
								"持ち帰り",
								style: TextStyle(
									fontSize: 30
								)
							)
						),
						Column(
							mainAxisAlignment: MainAxisAlignment.center,
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								Container(
									margin: EdgeInsets.all(10),
									height: 2,
									color: Colors.blue
								),
								_buildFoodsTable(context),
								Container(
									margin: EdgeInsets.all(10),
									height: 2,
									color: Colors.blue
								),
								TextButton(
									onPressed: _onPaymentButtonClicked,
									child: Text(
										"支払いへ進む",
										style: TextStyle(
											fontSize: 20
										)
									)
								)
							]
						)
					]
				)
			]
		);
    }

	@override
	void initState() {
		super.initState();

		final menuNames = takeOutMenuItems.items.map((item) => item.name);

		for (var counter = 0; counter < menuNames.length; counter++) {
			_menuItemCounter[menuNames.elementAt(counter)] = 0;
		}

		setState(() { });
	}

	Widget _buildFoodsTable(BuildContext context) {
		return IrohaFoodsTable(
			data: takeOutMenuItems.items
				.map((item) => item.name)
				.toList(),
			builder: (context, String item) {
				return DropdownButton<int>(
					value: _menuItemCounter[item],
					items: [
						for (int i = 0; i <= 5; i++)
							DropdownMenuItem(
								child: Text(
									i.toString(),
									style: TextStyle(fontSize: 20)
								),
								value: i,
							)
					],
					onChanged: (value) {
						setState(() {
							_menuItemCounter[item] = value ?? 0;
						});
					}
				);
			}
		);
	}

	Future<void> _onPaymentButtonClicked() async {
		Widget cancelButton = TextButton(
			child: Text("やっぱりやめる"),
			onPressed:  () {
				Navigator.of(context).pop(false);
			},
		);
		Widget continueButton = Consumer(
			builder: (context, watch, child) {
				return TextButton(
					child: Text("もちろん"),
					onPressed:  () {
						context
							.read(takeOutOrdersProvider.notifier)
							.add(-1, _menuItemCounter);

						Navigator.of(context).pop(true);
					}
				);
			}
		);

		bool isPaid = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: Text("確認"),
					content: Text("本当にこの注文でいいですか?"),
					actions: [
						cancelButton,
						continueButton,
					]
				);
			}
		);

		if (isPaid) {
			await showDialog(
				context: context,
				builder: (BuildContext ctx) {
					return AlertDialog(
						title: Text("完了"),
						content: Text("サーバーに送信しました。"),
						actions: [
							TextButton(
								onPressed: () {
									Navigator.of(context).pop();
								},
								child: Text("OK")
							)
						]
					);
				}
			);
		}
	}
}
