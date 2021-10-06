import "package:firebase_database/firebase_database.dart";
import "package:iroha/models/order-kind.dart";

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
	List<IrohaMenuItem> items = [];
	final IrohaOrderKind kind;

	MenuItems({required this.kind});

	Future<void> update() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("menu-items").child(kind.get()).get();
		final values = rawItems.value as Map<dynamic, dynamic>;
		items = values.entries
			.map((item) => IrohaMenuItem.fromJson(item.value))
			.toList();
	}

	static MenuItems getMenu(IrohaOrderKind kind) {
		switch (kind) {
			case IrohaOrderKind.EAT_IN:
				return eatInMenuItems;
			case IrohaOrderKind.TAKE_OUT:
				return takeOutMenuItems;
		}
	}
}

final eatInMenuItems = MenuItems(kind: IrohaOrderKind.EAT_IN);
final takeOutMenuItems = MenuItems(kind: IrohaOrderKind.TAKE_OUT);
