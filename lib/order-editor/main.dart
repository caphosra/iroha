import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/foods-table/main.dart";
import "package:iroha/main.dart";

class IrohaOrderEditor extends StatefulWidget {
	final void Function(Map<String, int> order) onOrderUpdated;

	IrohaOrderEditor({required this.onOrderUpdated, Key? key}) : super(key: key);

	@override
    _IrohaOrderEditorState createState() => _IrohaOrderEditorState();
}

class _IrohaOrderEditorState extends State<IrohaOrderEditor> {
	final Map<String, int> _menuItemCounter = <String, int>{ };

    @override
    Widget build(BuildContext context) {
        return _buildContent(context);
    }

	Widget _buildContent(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.start,
			mainAxisSize: MainAxisSize.min,
			children: <Widget>[
				Text(
					"1番テーブル",
					style: TextStyle(
						fontSize: 25
					)
				),
				Container(
					margin: EdgeInsets.all(10),
					height: 2,
					color: Colors.blue
				),
				Consumer(
					builder: _buildFoodsTable
				),
				Container(
					margin: EdgeInsets.all(10),
					height: 2,
					color: Colors.blue
				)
			]
		);
	}

	Widget _buildFoodsTable(BuildContext context, ScopedReader watch, Widget? child) {
		var menu = watch(menuDataProvider);

		if (_menuItemCounter.isEmpty) {
			for (var counter = 0; counter < menu.length; counter++) {
				_menuItemCounter[menu.elementAt(counter)] = 0;
			}

			widget.onOrderUpdated(_menuItemCounter);
		}

		return IrohaFoodsTable(
			data: menu,
			foodNameFromItem: (String item) {
				return item;
			},
			counterFromItem: (String item) {
				return DropdownButton<int>(
					value: _menuItemCounter[item],
					items: [
						for (int i = 0; i <= 5; i++)
							DropdownMenuItem(
								child: Text(
									i.toString(),
									style: TextStyle(fontSize: 25)
								),
								value: i,
							)
					],
					onChanged: (value) {
						setState(() {
							_menuItemCounter[item] = value ?? 0;

							widget.onOrderUpdated(_menuItemCounter);
						});
					}
				);
			}
		);
	}
}
