import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iroha/main.dart';

class IrohaCheckEditor extends StatefulWidget {
	IrohaCheckEditor({Key? key}) : super(key: key);

	final Map<String, int> _menuItemCounter = <String, int>{ };

	@override
    _IrohaCheckEditorState createState() => _IrohaCheckEditorState();
}

class _IrohaCheckEditorState extends State<IrohaCheckEditor> {
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

								return DataTable(
									columns: [
										DataColumn(
											label: Text(
												"料理",
												style: TextStyle(fontSize: 20)
											)
										),
										DataColumn(
											label: Text(
												"個数",
												style: TextStyle(fontSize: 20)
											)
										)
									],
									rows: menu.map((menuItem) =>
										DataRow(
											cells: [
												DataCell(
													Text(
														menuItem,
														style: TextStyle(fontSize: 25)
													)
												),
												DataCell(
													DropdownButton<int>(
														value: widget._menuItemCounter[menuItem],
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
																widget._menuItemCounter[menuItem] = value ?? 0;
															});
														}
													)
												)
											]
										)
									).toList()
								);
							}
						)
					)
				)
			]
		);
    }
}
