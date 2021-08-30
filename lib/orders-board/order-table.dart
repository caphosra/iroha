import "package:flutter/material.dart";
import "package:iroha/system/order.dart";

class IrohaOrderTable extends StatelessWidget {
	final IrohaOrder data;

	IrohaOrderTable({required this.data, Key? key}) : super(key: key);

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
			rows: data.foods.map((food) =>
				DataRow(
					cells: [
						DataCell(
							Text(
								food.id,
								style: TextStyle(fontSize: 25)
							)
						),
						DataCell(
							Text(
								"${food.count}個",
								style: TextStyle(fontSize: 25)
							)
						)
					]
				)
			).toList()
		);
	}
}
