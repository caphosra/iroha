import 'package:flutter/material.dart';

class IrohaStatusBox extends StatelessWidget {
  final String text;

  IrohaStatusBox({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 5, blurRadius: 40)
        ]),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(this.text,
                        style: TextStyle(fontSize: 30, color: Colors.white))),
                color: Colors.blue)));
  }
}
