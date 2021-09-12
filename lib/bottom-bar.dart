import "package:flutter/material.dart";
import "package:tuple/tuple.dart";

class IrohaBottomBar extends StatefulWidget {
	IrohaBottomBar({required this.items, required this.onSelected, Key? key}) : super(key: key);

	final List<Tuple2<String, IconData>> items;
	final void Function(int) onSelected;

    @override
    _IrohaBottomBarState createState() => _IrohaBottomBarState();
}

class _IrohaBottomBarState extends State<IrohaBottomBar> {
	int _selectedIndex = 0;

	@override
	Widget build(BuildContext context) {
		return Container(
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
					items: this.widget.items
						.map((item) {
							return BottomNavigationBarItem(
								icon: Icon(item.item2),
								label: item.item1
							);
						})
						.toList(),
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
		);
	}

	void _onItemTapped(int index) {
        setState(() {
			this.widget.onSelected(index);
            _selectedIndex = index;
        });
    }
}
