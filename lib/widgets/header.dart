import 'package:flutter/material.dart';

///
/// UIにタイトルをつけるためのUI
///
class IrohaWithHeader extends StatelessWidget {
  ///
  /// タイトルをつける対象のUI
  ///
  final List<Widget> children;

  ///
  /// タイトルの文字列
  ///
  final String text;

  ///
  /// UIにタイトルをつけるためのUI
  ///
  IrohaWithHeader({required this.children, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(children: <Widget>[
        Center(child: Text(text, style: TextStyle(fontSize: 30))),
        ...children
      ])
    ]);
  }
}
