import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";

class IrohaNumberOfFoods {
	final String id;
	final int count;

	IrohaNumberOfFoods({required this.id, required this.count});
}

class IrohaOrder {
	final String id;
	final int tableNumber;
	DateTime? posted;
	DateTime? cooked;
	DateTime? served;
	DateTime? paid;
	final List<IrohaNumberOfFoods> foods;

	IrohaOrder({required this.id, required this.tableNumber, required this.foods});

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
}

class IrohaOrderList extends StateNotifier<List<IrohaOrder>> {
	IrohaOrderList([List<IrohaOrder>? initial]) : super(initial ?? []);

	void add(int tableNumber, List<IrohaNumberOfFoods> foods) {
		var uuid = Uuid().v4();
		state = [
			...state,
			IrohaOrder(id: uuid, tableNumber: tableNumber, foods: foods)
		];
	}
}
