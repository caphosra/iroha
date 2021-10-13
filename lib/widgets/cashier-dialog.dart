import "package:flutter/material.dart";
import "package:iroha/models/order.dart";
import "package:iroha/widgets/foods-table.dart";

class IrohaCashierDialog {
	static Future<bool> show(BuildContext context, List<IrohaFoodCount> items, int price) async {
		bool isPaid = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: const Text("お会計"),
					content: SingleChildScrollView(
						child: ListBody(
							children: [
								const Text("以下の注文でOKですか?"),
								IrohaFoodsTable<IrohaFoodCount>(
									data: items,
									builder: _buildTable
								),
								Center(
									child: Text(
										"$price円",
										style: TextStyle(fontSize: 30)
									)
								)
							]
						)
					),
					actions: [
						TextButton(
							child: const Text("支払い完了"),
							onPressed: () {
								Navigator.of(context).pop(true);
							}
						),
						TextButton(
							child: const Text("キャンセル"),
							onPressed: () {
								Navigator.of(context).pop(false);
							}
						)
					]
				);
			}
		);

		return isPaid;
	}

	static Widget _buildTable(BuildContext context, IrohaFoodCount food) {
		return Text(
			food.count.toString(),
			style: TextStyle(fontSize: 20)
		);
	}
}
