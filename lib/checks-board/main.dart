import "dart:math";

import "package:flutter/material.dart";
import "package:iroha/check-editor/main.dart";
import "package:iroha/checks-board/checks-list.dart";

class IrohaChecksBoard extends StatelessWidget {
    IrohaChecksBoard({Key? key}) : super(key: key);

	bool editMode = false;

    @override
    Widget build(BuildContext context) {
		return Container(
			width: min(MediaQuery.of(context).size.width, 600),
			child: editMode ? IrohaCheckEditor() : IrohaChecksList()
		);
    }

	void OnAddButtonClicked() {
		
	}
}
