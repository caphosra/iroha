import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:iroha/main.dart";
import "package:iroha/widgets/cooked-board/order-view.dart";

class IrohaCookedBoard extends StatefulWidget {
	IrohaCookedBoard({Key? key}) : super(key: key);

	@override
  	_IrohaCookedBoardState createState() => _IrohaCookedBoardState();
}

class _IrohaCookedBoardState extends State<IrohaCookedBoard> {
    @override
    Widget build(BuildContext context) {
		return Consumer(
			builder: (context, watch, child) {
				var orders = watch(ordersProvider);

				var ordersWidgets = orders
					.where((data) =>
						data.cooked != null && data.served == null
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
										"提供",
										style: TextStyle(
											fontSize: 30
										)
									)
								),
								...ordersWidgets
							]
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
