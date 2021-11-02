import 'package:flutter/material.dart';

///
/// 文字列を表示するUI
///
/// 起動を確認し、アニメーションが動くというテストの意味合いが強いです。
///
class IrohaStatusBox extends StatelessWidget {
  ///
  /// 表示される文字列
  ///
  final String text;

  ///
  /// 文字列を表示するUI
  ///
  /// 起動を確認し、アニメーションが動くというテストの意味合いが強いです。
  ///
  const IrohaStatusBox({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          const BoxShadow(
              color: Colors.black26, spreadRadius: 5, blurRadius: 40)
        ]),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
                child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Text(this.text,
                        style: const TextStyle(
                            fontSize: 30, color: Colors.white))),
                color: Colors.blue)));
  }
}
