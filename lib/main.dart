import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:iroha/cooked-board/main.dart";
import "package:iroha/home/main.dart";
import "package:iroha/orders-board/main.dart";
import "package:iroha/system/menu-item-data.dart";
import "package:iroha/system/order.dart";

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
    static List<BottomNavigationBarItem> _bottomItems = const [
		BottomNavigationBarItem(
			icon: Icon(Icons.home),
			label: "ホーム"
		),
		BottomNavigationBarItem(
			icon: Icon(Icons.comment),
			label: "注文"
		),
		BottomNavigationBarItem(
			icon: Icon(Icons.emoji_food_beverage),
			label: "調理"
		)
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
            bottomNavigationBar: Container(
				decoration: BoxDecoration(
					boxShadow: [
						BoxShadow(color: Colors.black26, spreadRadius: 5, blurRadius: 20)
					]
				),
				child: ClipRRect(
					borderRadius: BorderRadius.only(
						topLeft: Radius.circular(20),
						topRight: Radius.circular(20)
					),
					child: BottomNavigationBar(
						items: _bottomItems,
						currentIndex: _selectedIndex,
						type: BottomNavigationBarType.fixed,
						selectedIconTheme: IconThemeData(size: 40),
						selectedFontSize: 20,
						selectedItemColor: Colors.orange,
						unselectedIconTheme: IconThemeData(size: 40),
						unselectedFontSize: 20,
						unselectedItemColor: Colors.blue,
						backgroundColor: Colors.white,
						onTap: _onItemTapped
					)
				)
			),
			backgroundColor: Colors.white
        );
    }

    void _onItemTapped(int index) {
        setState(() {
            _selectedIndex = index;
        });
    }
}
