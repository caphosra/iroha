import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/main.dart";
import "package:iroha/widgets/order-editor.dart";
import "package:iroha/widgets/orders-board/orders-list.dart";

class IrohaOrdersBoard extends StatefulWidget {
    IrohaOrdersBoard({Key? key}) : super(key: key);

	@override
    _IrohaOrdersBoardState createState() => _IrohaOrdersBoardState();
}

class _IrohaOrdersBoardState extends State<IrohaOrdersBoard> {
	int _tableNumber = 1;
    Map<String, int> _menuItemCounter = <String, int>{ };

	@override
    Widget build(BuildContext context) {
		return IrohaOrdersListView(
			onAddButtonClicked: () => _changeEditMode(context)
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

	void _onOrderUpdated(int tableNumber, Map<String, int> order) {
		_tableNumber = tableNumber;
		_menuItemCounter = order;
	}

	void _onAddButtonClicked(BuildContext context, ScopedReader watch) {
		context
			.read(ordersProvider.notifier)
			.add(
				_tableNumber,
				_menuItemCounter
			);

		Navigator.pop(context);
	}
}
