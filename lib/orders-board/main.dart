import "dart:math";

import "package:flutter/material.dart";
import "package:iroha/order-editor/main.dart";
import "package:iroha/orders-board/orders-list.dart";

class IrohaOrdersBoard extends StatefulWidget {
    IrohaOrdersBoard({Key? key}) : super(key: key);

	@override
    _IrohaOrdersBoardState createState() => _IrohaOrdersBoardState();
}

class _IrohaOrdersBoardState extends State<IrohaOrdersBoard> {
	bool editMode = false;

    @override
    Widget build(BuildContext context) {
		return Container(
			width: min(MediaQuery.of(context).size.width, 600),
			child: editMode
				? IrohaOrderEditor()
				: IrohaOrdersListView(
					onAddButtonClicked: () => changeEditMode(true)
				)
		);
    }

	void changeEditMode(bool editMode) {
		setState(() {
			this.editMode = editMode;
		});
	}
}
