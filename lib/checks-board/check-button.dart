import "package:flutter/material.dart";

class IrohaCheckButton extends StatelessWidget {
	IrohaCheckButton({required this.icon, required this.color, required this.onPressed, Key? key}) : super(key: key);

	final IconData icon;
	final Color color;
	final void Function() onPressed;

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: Container(
				padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
				child: ClipRRect(
					borderRadius: BorderRadius.all(Radius.circular(20)),
					child: Container(
						color: color,
						child: TextButton(
							onPressed: onPressed,
							child: Container(
								child: Icon(
									icon,
									color: Colors.white
								)
							)
						)
					)
				)
			)
		);
	}
}
