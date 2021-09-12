import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:iroha/bottom-bar.dart";
import "package:iroha/cooked-board/main.dart";
import "package:iroha/home/main.dart";
import "package:iroha/orders-board/main.dart";
import "package:iroha/system/menu-item-data.dart";
import "package:iroha/system/order.dart";
import "package:tuple/tuple.dart";

void main() {
    runApp(IrohaApp());
}

final menuDataProvider = StateNotifierProvider<MenuData, List<String>>((ref) {
	ref.onDispose(() { });

	var data = MenuData();

	data.add("パンケーキ");
	data.add("コーヒー");

	return data;
});

final ordersProvider = StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
	ref.onDispose(() { });

	var dataList = IrohaOrderList([]);

	return dataList;
});

class IrohaApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return ProviderScope(
			child: MaterialApp(
				title: "Iroha",
				theme: ThemeData(
					primarySwatch: Colors.blue,
					fontFamily: "KiwiMaru"
				),
				home: IrohaAppView()
			)
        );
    }
}

class IrohaAppView extends StatefulWidget {
    IrohaAppView({Key? key}) : super(key: key);

    @override
    _IrohaAppViewState createState() => _IrohaAppViewState();
}

class _IrohaAppViewState extends State<IrohaAppView> {
    static List<Tuple2<String, IconData>> items = const [
		Tuple2("ホーム", Icons.home),
		Tuple2("注文", Icons.comment),
		Tuple2("調理", Icons.emoji_food_beverage),
	];

	static List<Widget> _widgetOptions = [
        IrohaHome(),
        IrohaOrdersBoard(),
        IrohaCookedBoard(),
    ];

    int _selectedIndex = 0;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: _widgetOptions
					.map((widget) {
						return Container(
							width: min(MediaQuery.of(context).size.width, 500),
							child: widget
						);
					})
					.elementAt(_selectedIndex),
            ),
			extendBody: true,
            bottomNavigationBar: IrohaBottomBar(
				items: items,
				onSelected: _onSelected
			),
			backgroundColor: Colors.white
        );
    }

    void _onSelected(int index) {
        setState(() {
            _selectedIndex = index;
        });
    }
}
