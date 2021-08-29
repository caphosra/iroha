import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:iroha/checks-board/main.dart";
import "package:iroha/cooked-board/main.dart";
import "package:iroha/home/main.dart";
import "package:iroha/system/check-data.dart";
import 'package:iroha/system/menu-item-data.dart';

final checkDataProvider = StateNotifierProvider.autoDispose<CheckDataList, List<CheckData>>((ref) {
	ref.onDispose(() { });

	var dataList = CheckDataList([]);
	dataList.add(
		1,
		[
			CheckFoodData(id: "パンケーキ", count: 5),
			CheckFoodData(id: "コーヒー", count: 3)
		]
	);
	dataList.add(
		3,
		[
			CheckFoodData(id: "パンケーキ", count: 2),
			CheckFoodData(id: "コーヒー", count: 4)
		]
	);
	dataList.add(
		4,
		[
			CheckFoodData(id: "パンケーキ", count: 2),
			CheckFoodData(id: "コーヒー", count: 1)
		]
	);
	dataList.add(
		5,
		[
			CheckFoodData(id: "パンケーキ", count: 2),
			CheckFoodData(id: "コーヒー", count: 3)
		]
	);

	return dataList;
});

final menuDataProvider = StateNotifierProvider.autoDispose<MenuData, List<String>>((ref) {
	ref.onDispose(() { });

	var data = MenuData();

	data.add("パンケーキ");
	data.add("コーヒー");

	return data;
});

void main() {
    runApp(IrohaApp());
}

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
    int _selectedIndex = 0;

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
        IrohaChecksBoard(),
        IrohaCookedBoard(),
    ];

    void _onItemTapped(int index) {
        setState(() {
            _selectedIndex = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
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
}
