import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/widgets/common-dialog.dart";
import "package:iroha/widgets/foods-table.dart";
import "package:iroha/widgets/orders-board/order-button.dart";
import "package:iroha/models/order.dart";

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

	Future<void> _onDeleteButtonClicked(BuildContext context) async {
		final result = await IrohaCommonDialog.showConfirm(
			context,
			"本当にこの注文を削除しますか?"
		);

		if (result) {
			context
				.read(eatInOrdersProvider.notifier)
				.delete(data.id);

			onListChanged();
		}
	}

	Future<void> _onDoneButtonClicked(BuildContext context) async {
		final result = await IrohaCommonDialog.showConfirm(
			context,
			"本当にこの注文のお届けは終わりましたか?"
		);

		if (result) {
			context
				.read(eatInOrdersProvider.notifier)
				.markAs(data.id, IrohaOrderStatus.SERVED, DateTime.now());

			onListChanged();
		}
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
				IrohaFoodsTable(
					data: data.getCounts(),
					builder: (context, IrohaFoodCount food) {
						if (food.count == 0) {
							return null;
						}
						else {
							return Text(
								food.count.toString(),
								style: TextStyle(fontSize: 20)
							);
						}
					}
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
