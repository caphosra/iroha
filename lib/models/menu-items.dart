import "package:firebase_database/firebase_database.dart";

class MenuItems {
	static List<String>? _items;

	static List<String> get() {
		if (_items == null) {
			throw Exception("You cannot use the menu items before initializing them.");
		}
		return _items ?? [];
	}

	static Future<List<String>> update() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("menu-items").get();
		final items = rawItems.value as Map<dynamic, dynamic>;
		_items = items.values.map((item) => item.toString()).toList();
		return _items ?? [];
	}
}
