import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/main.dart";
import "package:iroha/widgets/foods-table.dart";
import "package:iroha/widgets/orders-board/order-button.dart";
import "package:iroha/models/order.dart";
import "package:tuple/tuple.dart";

class IrohaOrderView extends StatelessWidget {
	final IrohaOrder data;
	final void Function() onListChanged;

	IrohaOrderView({required this.data, required this.onListChanged, Key? key}) : super(key: key);

	@override
    Widget build(BuildContext context) {
        return Container(
			decoration: BoxDecoration(
				border: Border.all(color: Colors.blue),
				borderRadius: BorderRadius.circular(20),
			),
			margin: EdgeInsets.all(20),
			width: 350,
			child: Container(
				margin: EdgeInsets.all(20),
				child: Center(
					child: _buildContent(context)
				)
			)
		);
    }

	void _onDeleteButtonClicked(BuildContext context) {
		Widget cancelButton = TextButton(
			child: Text("やっぱりやめる"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
		);
		Widget continueButton = Consumer(
			builder: (context, watch, child) {
				return TextButton(
					child: Text("もちろん"),
					onPressed:  () {
						context
							.read(ordersProvider.notifier)
							.delete(data.id);
						Navigator.of(context).pop();

						onListChanged();
					}
				);
			}
		);

		showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: Text("確認"),
					content: Text("本当にこの注文を削除しますか?"),
					actions: [
						cancelButton,
						continueButton,
					]
				);
			}
		);
	}

	void _onDoneButtonClicked(BuildContext context) {
		Widget cancelButton = TextButton(
			child: Text("やっぱりやめる"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
		);
		Widget continueButton = Consumer(
			builder: (context, watch, child) {
				return TextButton(
					child: Text("もちろん"),
					onPressed:  () {
						context
							.read(ordersProvider.notifier)
							.markAs(data.id, IrohaOrderStatus.COOKED, DateTime.now());
						Navigator.of(context).pop();

						onListChanged();
					}
				);
			}
		);

		showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: Text("確認"),
					content: Text("本当にこの注文を完了としますか?"),
					actions: [
						cancelButton,
						continueButton,
					]
				);
			}
		);
	}

	Widget _buildContent(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.start,
			children: <Widget>[
				Text(
					"${data.tableNumber}番テーブル",
					style: TextStyle(
						fontSize: 25
					)
				),
				Container(
					margin: EdgeInsets.all(10),
					height: 2,
					color: Colors.blue
				),
				IrohaFoodsTable(
					data: data.foods.entries
						.map((item) => Tuple2(item.key, item.value))
						.toList(),
					foodNameFromItem: (Tuple2<String, int> food) {
						return food.item1;
					},
					counterFromItem: (Tuple2<String, int> food) {
						return Text(
							food.item2.toString(),
							style: TextStyle(fontSize: 25)
						);
					}
				),
				Container(
					margin: EdgeInsets.all(10),
					height: 2,
					color: Colors.blue
				),
				Row(
					children: [
						IrohaOrderButton(
							icon: Icons.check,
							color: Colors.green.shade400,
							onPressed: () => _onDoneButtonClicked(context)
						),
						IrohaOrderButton(
							icon: Icons.delete,
							color: Colors.red.shade400,
							onPressed: () => _onDeleteButtonClicked(context)
						)
					]
				)
			]
		);
	}
}
