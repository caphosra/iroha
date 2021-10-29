import 'package:flutter/material.dart';

class IrohaLogo extends StatelessWidget {
  final String logoImagePath;

  IrohaLogo({required this.logoImagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Image(
            image: AssetImage(this.logoImagePath), width: 300, height: 300));
  }
}
