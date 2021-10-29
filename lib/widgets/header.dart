import 'package:flutter/material.dart';

class IrohaWithHeader extends StatelessWidget {
  final List<Widget> children;
  final String text;

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
