import 'package:flutter/material.dart';
import 'package:iroha/widgets/home/logo.dart';
import 'package:iroha/widgets/home/status.dart';

///
/// Irohaのトップページ
///
class IrohaHome extends StatefulWidget {
  ///
  /// Irohaのトップページ
  ///
  IrohaHome({Key? key}) : super(key: key);

  @override
  _IrohaHomeState createState() => _IrohaHomeState();
}

///
/// [IrohaHome] の状態
///
class _IrohaHomeState extends State<IrohaHome>
    with SingleTickerProviderStateMixin {
  ///
  /// アニメーションを管理するもの
  ///
  late AnimationController _animationController;

  ///
  /// UIの初期化を行います。
  ///
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));

    _animationController.drive(CurveTween(curve: Curves.easeOutCirc));

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const IrohaLogo(logoImagePath: 'assets/logo.png'),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Opacity(
                    opacity: _animationController.value,
                    child: const IrohaStatusBox(text: 'Irohaへようこそ'));
              })
        ]));
  }

  ///
  /// UIの削除を行います。
  ///
  @override
  void dispose() {
    this._animationController.dispose();

    super.dispose();
  }
}
