import "package:flutter/material.dart";
import "package:iroha/home/logo.dart";
import "package:iroha/home/status.dart";

class IrohaHome extends StatefulWidget {
    IrohaHome({Key? key}) : super(key: key);

    @override
    _IrohaHomeState createState() => _IrohaHomeState();
}

class _IrohaHomeState extends State<IrohaHome> with SingleTickerProviderStateMixin {
	late AnimationController _animationController;

	@override
	void initState() {
    	_animationController = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 5000)
		);

		_animationController
			.drive(CurveTween(curve: Curves.easeOutCirc));

		_animationController.repeat(reverse: true);

		super.initState();
  	}

	@override
    Widget build(BuildContext context) {
        return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					IrohaLogo(logoImagePath: "assets/logo.png"),
					AnimatedBuilder(
						animation: _animationController,
						builder: (context, _) {
							return Opacity(
								opacity: _animationController.value,
								child: IrohaStatusBox(text: "Irohaへようこそ")
							);
						}
					)
				]
			)
		);
    }

	@override
	void dispose() {
		this._animationController.dispose();

		super.dispose();
	}
}
