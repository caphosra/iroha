import "package:flutter/material.dart";

class IrohaFoodsTable<T> extends StatelessWidget {
	final List<T> data;
	final String Function(T) foodNameFromItem;
	final Widget Function(T) counterFromItem;

	IrohaFoodsTable({
		required this.data,
		required this.foodNameFromItem,
		required this.counterFromItem,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
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
			rows: data.map((item) =>
				DataRow(
					cells: [
						DataCell(
							Text(
								foodNameFromItem(item),
								style: TextStyle(fontSize: 25)
							)
						),
						DataCell(
							counterFromItem(item)
						)
					]
				)
			).toList()
		);
	}
}
