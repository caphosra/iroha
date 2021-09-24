import "package:firebase_database/firebase_database.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:iroha/models/menu-items.dart";
import "package:uuid/uuid.dart";

typedef IrohaMenuID = String;

class IrohaOrder {
	final String id;
	final int tableNumber;
	DateTime posted;
	DateTime? cooked;
	DateTime? served;
	DateTime? paid;
	final Map<IrohaMenuID, int> foods;

	IrohaOrder({required this.id, required this.posted, required this.tableNumber, required this.foods});

	void markAsCooked(DateTime time) {
 		this.cooked = time;
	}

	void markAsPaid(DateTime time) {
 		this.paid = time;
	}

	void markAsPosted(DateTime time) {
 		this.posted = time;
	}

	void markAsServed(DateTime time) {
 		this.served = time;
	}

	Map<dynamic, dynamic> toJson() {
		var json = <dynamic, dynamic>{
			"tableNumber": tableNumber,
			"posted": posted.toString(),
			"cooked": cooked.toString(),
			"served": served.toString(),
			"paid": served.toString()
		};
		json.addAll(foods);
		return json;
	}

	static Future<IrohaOrder> fromJson(String id, Map<dynamic, dynamic> json) async {
		var order = IrohaOrder(
			id: id,
			tableNumber: json["tableNumber"],
			posted: DateTime.parse(json["posted"]),
			foods: { }
		);
		order.cooked = DateTime.tryParse(json["cooked"]);
		order.served = DateTime.tryParse(json["served"]);
		order.paid = DateTime.tryParse(json["paid"]);
		for (final item in await MenuItems.get()) {
			order.foods[item] = json[item];
		}
		return order;
	}
}

class IrohaOrderList extends StateNotifier<List<IrohaOrder>> {
	IrohaOrderList([List<IrohaOrder>? initial]) : super(initial ?? []);

	Future<void> add(int tableNumber, Map<IrohaMenuID, int> foods) async {
		final uuid = Uuid().v4();
		final order = IrohaOrder(
			id: uuid,
			posted: DateTime.now(),
			tableNumber: tableNumber,
			foods: foods
		);
		final ref = FirebaseDatabase.instance.reference();
		ref.child("orders").child(uuid).set(order.toJson());
		state = await _update();
	}

	Future<void> delete(String id) async {
		final ref = FirebaseDatabase.instance.reference();
		ref.child("orders").child(id).remove();
		state = await _update();
	}

	bool markAsCooked(String id, DateTime time) {
		var index = state.indexWhere((order) => order.id == id);
		if (index == -1) {
			return false;
		}
		else {
			state[index].markAsCooked(time);
			return true;
		}
	}

	bool markAsPaid(String id, DateTime time) {
 		var index = state.indexWhere((order) => order.id == id);
		if (index == -1) {
			return false;
		}
		else {
			state[index].markAsPaid(time);
			return true;
		}
	}

	bool markAsPosted(String id, DateTime time) {
 		var index = state.indexWhere((order) => order.id == id);
		if (index == -1) {
			return false;
		}
		else {
			state[index].markAsPosted(time);
			return true;
		}
	}

	bool markAsServed(String id, DateTime time) {
 		var index = state.indexWhere((order) => order.id == id);
		if (index == -1) {
			return false;
		}
		else {
			state[index].markAsServed(time);
			return true;
		}
	}

	Future<List<IrohaOrder>> _update() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("orders").get();
		final items = rawItems.value as Map<dynamic, dynamic>;
		return await Future.wait(
			items.entries
				.map((order) async {
					return await IrohaOrder.fromJson(
						order.key,
						order.value
					);
				})
				.toList()
		);
	}
}
