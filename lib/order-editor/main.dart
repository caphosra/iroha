import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/foods-table/main.dart";
import "package:iroha/main.dart";

class IrohaOrderEditor extends StatefulWidget {
	final Map<String, int> _menuItemCounter = <String, int>{ };

	IrohaOrderEditor({Key? key}) : super(key: key);

	@override
    _IrohaOrderEditorState createState() => _IrohaOrderEditorState();
}

class _IrohaOrderEditorState extends State<IrohaOrderEditor> {
    @override
    Widget build(BuildContext context) {
        return ListView(
			children: <Widget>[
				Center(
					child: Text(
						"注文をとる",
						style: TextStyle(
							fontSize:30
						)
					)
				),
				Container(
					margin: EdgeInsets.all(20),
					decoration: BoxDecoration(
						border: Border.all(color: Colors.blue),
						borderRadius: BorderRadius.circular(20)
					),
					child: Container(
						margin: EdgeInsets.all(20),
						child: Consumer(
							builder: (context, watch, child) {
								var menu = watch(menuDataProvider);

								if (widget._menuItemCounter.isEmpty) {
									for (var counter = 0; counter < menu.length; counter++) {
										widget._menuItemCounter[menu.elementAt(counter)] = 0;
									}
								}

								return IrohaFoodsTable(
									data: menu,
									foodNameFromItem: (String item) {
										return item;
									},
									counterFromItem: (String item) {
										return DropdownButton<int>(
											value: widget._menuItemCounter[item],
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
													widget._menuItemCounter[item] = value ?? 0;
												});
											}
										);
									}
								);
							}
						)
					)
				)
			]
		);
    }
}
