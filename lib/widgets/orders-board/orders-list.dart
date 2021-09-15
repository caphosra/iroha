import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/main.dart";
import "package:iroha/widgets/orders-board/order-view.dart";

class IrohaOrdersListView extends StatefulWidget {
	final void Function() onAddButtonClicked;

	IrohaOrdersListView({required this.onAddButtonClicked, Key? key}) : super(key: key);

	@override
  	_IrohaOrdersListViewState createState() => _IrohaOrdersListViewState();
}

class _IrohaOrdersListViewState extends State<IrohaOrdersListView> {
    @override
    Widget build(BuildContext context) {
		return Consumer(
			builder: (context, watch, child) {
				var orders = watch(ordersProvider);

			var ordersWidgets = orders
				.where((data) =>
					data.cooked == null
				)
				.map((data) =>
					IrohaOrderView(
						data: data,
						onListChanged: onListChanged
					)
				).toList();

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
								...ordersWidgets
							]
						),
						Positioned(
							child: FloatingActionButton(
								child: const Icon(Icons.edit),
								onPressed: widget.onAddButtonClicked
							),
							bottom: 110,
							right: 30
						)
					]
				);
			}
		);
    }

	onListChanged() {
		setState(() { });
	}
}
