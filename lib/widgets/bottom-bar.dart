import 'package:flutter/material.dart';
import 'package:iroha/main.dart';

///
/// 下に表示される、ページの選択が行えるUI
///
class IrohaBottomBar extends StatefulWidget {
  ///
  /// 下に表示される、ページの選択が行えるUI
  ///
  IrohaBottomBar({required this.items, required this.onSelected, Key? key})
      : super(key: key);

  ///
  /// ページのリスト
  ///
  final List<IrohaPage> items;

  ///
  /// 選択された時の処理
  ///
  final void Function(int) onSelected;

  @override
  _IrohaBottomBarState createState() => _IrohaBottomBarState();
}

///
/// [IrohaBottomBar] の状態
///
class _IrohaBottomBarState extends State<IrohaBottomBar> {
  ///
  /// 選ばれているものの順番
  ///
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(boxShadow: [
          const BoxShadow(
              color: Colors.black26, spreadRadius: 5, blurRadius: 20)
        ]),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: BottomNavigationBar(
                items: this.widget.items.map((item) {
                  return BottomNavigationBarItem(
                      icon: Icon(item.icon), label: item.title);
                }).toList(),
                currentIndex: _selectedIndex,
                type: BottomNavigationBarType.fixed,
                selectedIconTheme: const IconThemeData(size: 40),
                selectedFontSize: 20,
                selectedItemColor: Colors.orange,
                unselectedIconTheme: const IconThemeData(size: 40),
                unselectedFontSize: 20,
                unselectedItemColor: Colors.blue,
                backgroundColor: Colors.white,
                onTap: _onItemTapped)));
  }

  ///
  /// ページのボタンが押された時の処理を行います。
  ///
  void _onItemTapped(int index) {
    setState(() {
      this.widget.onSelected(index);
      _selectedIndex = index;
    });
  }
}
