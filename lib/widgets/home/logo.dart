import 'package:flutter/material.dart';

///
/// Irohaのロゴを表示するUI
///
class IrohaLogo extends StatelessWidget {
  ///
  /// Irohaのロゴへのパス
  ///
  final String logoImagePath;

  ///
  /// Irohaのロゴを表示するUI
  ///
  const IrohaLogo({required this.logoImagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Image(
            image: AssetImage(this.logoImagePath), width: 300, height: 300));
  }
}
