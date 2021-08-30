import "package:flutter/material.dart";
import "package:iroha/foods-table/main.dart";
import "package:iroha/orders-board/order-button.dart";
import "package:iroha/system/order.dart";

class IrohaOrderView extends StatelessWidget {
    final IrohaOrder data;

	IrohaOrderView({required this.data, Key? key}) : super(key: key);

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

	void onDeleteButtonClicked(BuildContext context) {
		Widget cancelButton = TextButton(
			child: Text("やっぱりやめる"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
		);
		Widget continueButton = TextButton(
			child: Text("もちろん"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
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

	void onDoneButtonClicked(BuildContext context) {
		Widget cancelButton = TextButton(
			child: Text("やっぱりやめる"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
		);
		Widget continueButton = TextButton(
			child: Text("もちろん"),
			onPressed:  () {
				Navigator.of(context).pop();
			},
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
					data: data.foods,
					foodNameFromItem: (IrohaNumberOfFoods food) {
						return food.id;
					},
					counterFromItem: (IrohaNumberOfFoods food) {
						return Text(
							food.count.toString(),
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
							onPressed: () => onDoneButtonClicked(context)
						),
						IrohaOrderButton(
							icon: Icons.delete,
							color: Colors.red.shade400,
							onPressed: () => onDeleteButtonClicked(context)
						)
					]
				)
			]
		);
	}
}
