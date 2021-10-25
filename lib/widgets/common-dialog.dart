import "package:flutter/material.dart";

class IrohaCommonDialog {
  	static Future<void> showDone(BuildContext context, String text) async {
		await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: const Text("完了"),
					content: Text(text),
					actions: [
						TextButton(
							child: const Text("りょうかい"),
							onPressed: () {
								Navigator.of(context).pop();
							}
						)
					]
				);
			}
		);
	}

	static Future<bool> showConfirm(BuildContext context, String text) async {
		final bool result = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return AlertDialog(
					title: const Text("確認"),
					content: Text(text),
					actions: [
						TextButton(
							child: const Text("やっぱりやめる"),
							onPressed: () {
								Navigator.of(context).pop(false);
							}
						),
						TextButton(
							child: const Text("もちろん"),
							onPressed: () {
								Navigator.of(context).pop(true);
							}
						)
					]
				);
			}
		);

		return result;
	}
}
