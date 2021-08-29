import "dart:math";

import "package:flutter/material.dart";
import "package:iroha/check-editor/main.dart";
import "package:iroha/checks-board/checks-list.dart";

class IrohaChecksBoard extends StatefulWidget {
    IrohaChecksBoard({Key? key}) : super(key: key);

	@override
    _IrohaChecksBoardState createState() => _IrohaChecksBoardState();
}

class _IrohaChecksBoardState extends State<IrohaChecksBoard> {
	bool editMode = false;

    @override
    Widget build(BuildContext context) {
		return Container(
			width: min(MediaQuery.of(context).size.width, 600),
			child: editMode
				? IrohaCheckEditor()
				: IrohaChecksList(
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
