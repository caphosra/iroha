import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/checks-board/check.dart";
import "package:iroha/main.dart";

class IrohaChecksList extends ConsumerWidget {
    IrohaChecksList({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context, ScopedReader watch) {
		var checkDataList = watch(checkDataProvider);

		return Stack(
			children: [
				ListView(
					children: <Widget>[
						Center(
							child: Text(
								"注文",
								style: TextStyle(
									fontSize: 30
								)
							)
						),
						...checkDataList.map((data) =>
							IrohaCheck(data: data)
						).toList()
					]
				),
				Positioned(
					child: FloatingActionButton(
						child: const Icon(Icons.edit),
						onPressed: onAddButtonClicked
					),
					bottom: 110,
					right: 30
				)
			]
		);
    }

	void onAddButtonClicked() {

	}
}
