import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/main.dart";
import "package:iroha/widgets/orders-board/order-view.dart";

class IrohaOrdersListView extends ConsumerWidget {
    final void Function() onAddButtonClicked;

	IrohaOrdersListView({required this.onAddButtonClicked, Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context, ScopedReader watch) {
		var orders = watch(ordersProvider);

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
						...orders.map((data) =>
							IrohaOrderView(data: data)
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
}
