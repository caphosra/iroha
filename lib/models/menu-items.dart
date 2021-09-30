import "package:firebase_database/firebase_database.dart";

class IrohaMenuItem {
	String name;
	int price;

	IrohaMenuItem({required this.name, required this.price});

	Map<dynamic, dynamic> toJson() {
		var json = <dynamic, dynamic>{
			"name": name,
			"price": price
		};
		return json;
	}

	static IrohaMenuItem fromJson(Map<dynamic, dynamic> json) {
		return IrohaMenuItem(
			name: json["name"],
			price: json["price"]
		);
	}
}

class MenuItems {
	static List<IrohaMenuItem> items = [];

	static Future<void> update() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("menu-items").get();
		final values = rawItems.value as Map<dynamic, dynamic>;
		items = values.entries
			.map((item) => IrohaMenuItem.fromJson(item.value))
			.toList();
	}
}
