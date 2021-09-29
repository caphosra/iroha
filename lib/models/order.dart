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

	void markAs(IrohaOrderStatus status, DateTime time) {
		switch (status) {
			case IrohaOrderStatus.POSTED:
				posted = time;
				break;
			case IrohaOrderStatus.COOKED:
				cooked = time;
				break;
			case IrohaOrderStatus.SERVED:
				served = time;
				break;
			case IrohaOrderStatus.PAID:
				paid = time;
				break;
		}
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

enum IrohaOrderStatus {
	POSTED,
	COOKED,
	SERVED,
	PAID
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
	}

	Future<void> delete(String id) async {
		final ref = FirebaseDatabase.instance.reference();
		ref.child("orders").child(id).remove();
	}

	Future<void> update() async {
		state = await _downloadData();
	}

	Future<void> markAs(String id, IrohaOrderStatus status, DateTime time) async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("orders").child(id).get();
		final items = await IrohaOrder.fromJson(
			id,
			rawItems.value as Map<dynamic, dynamic>
		);

		items.markAs(status, time);
		await ref.child("orders").child(id).set(items.toJson());
	}

	Future<void> keepWatching() async {
		final ref = FirebaseDatabase.instance.reference();
		final stream = ref.child("orders").onValue;
		await for (final event in stream) {
			final items = event.snapshot.value as Map<dynamic, dynamic>;
			state = await _toList(items);
		}
	}

	Future<List<IrohaOrder>> _downloadData() async {
		final ref = FirebaseDatabase.instance.reference();
		final rawItems = await ref.child("orders").get();
		final items = rawItems.value as Map<dynamic, dynamic>;

		return await _toList(items);
	}

	Future<List<IrohaOrder>> _toList(Map<dynamic, dynamic> items) async {
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
