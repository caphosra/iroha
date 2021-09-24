import "package:firebase_database/firebase_database.dart";

class MenuItems {
	static List<String>? _items;

	static Future<List<String>> get() async {
		if (_items == null) {
			_items = await _update();
		}
		return _items ?? [];
	}

	static Future<List<String>> _update() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("menu-items").get();
		final items = rawItems.value as Map<dynamic, dynamic>;
		return items.values.map((item) => item.toString()).toList();
	}
}
