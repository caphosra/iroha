import "dart:async";
import "dart:math";

import "package:firebase_core/firebase_core.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/material.dart";
import "package:iroha/models/order.dart";
import "package:iroha/widgets/bottom-bar.dart";
import "package:iroha/widgets/cooked-board/main.dart";
import "package:iroha/widgets/home/main.dart";
import "package:iroha/widgets/orders-board/main.dart";
import "package:tuple/tuple.dart";

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();

	await Firebase.initializeApp();

    runApp(IrohaApp());
}

final ordersProvider = StateNotifierProvider<IrohaOrderList, List<IrohaOrder>>((ref) {
	ref.onDispose(() { });

	var dataList = IrohaOrderList([]);
	dataList.update();

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
