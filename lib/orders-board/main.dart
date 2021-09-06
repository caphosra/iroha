import "dart:math";

import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/main.dart';
import "package:iroha/order-editor/main.dart";
import "package:iroha/orders-board/orders-list.dart";

class IrohaOrdersBoard extends StatefulWidget {
    IrohaOrdersBoard({Key? key}) : super(key: key);

	@override
    _IrohaOrdersBoardState createState() => _IrohaOrdersBoardState();
}

class _IrohaOrdersBoardState extends State<IrohaOrdersBoard> {
    Map<String, int> _menuItemCounter = <String, int>{ };

	@override
    Widget build(BuildContext context) {
		return Container(
			width: min(MediaQuery.of(context).size.width, 600),
			child: IrohaOrdersListView(
				onAddButtonClicked: () => _changeEditMode(context)
			)
		);
    }

	void _changeEditMode(BuildContext context) {
		showDialog(
			context: context,
			builder: (_) {
				return AlertDialog(
					title: Text("注文を追加"),
					content: IrohaOrderEditor(
						onOrderUpdated: _onOrderUpdated,
					),
					actions: [
						Consumer(
							builder: (BuildContext context, ScopedReader watch, Widget? child) {
								return TextButton(
									onPressed: () => _onAddButtonClicked(context, watch),
									child: Text("追加")
								);
							}
						),
						TextButton(
							onPressed: () {
								Navigator.pop(context);
							},
							child: Text("キャンセル")
						)
					]
				);
			}
		);
	}

	void _onOrderUpdated(Map<String, int> order) {
		_menuItemCounter = order;
	}

	void _onAddButtonClicked(BuildContext context, ScopedReader watch) {
		context.read(ordersProvider.notifier).addOrder(1, _menuItemCounter);

		Navigator.pop(context);
	}
}
