import 'package:flutter/material.dart';

///
/// 注文において使われるボタンを描画するUI
///
class IrohaOrderButton extends StatelessWidget {
  ///
  /// ボタンのアイコン
  ///
  final IconData icon;

  ///
  /// ボタンの色
  ///
  final Color color;

  ///
  /// ボタンが押された時の処理
  ///
  final void Function() onPressed;

  ///
  /// 注文において使われるボタンを描画するUI
  ///
  const IrohaOrderButton(
      {required this.icon,
      required this.color,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                    color: color,
                    child: TextButton(
                        onPressed: onPressed,
                        child: Container(
                            child: Icon(icon, color: Colors.white)))))));
  }
}
