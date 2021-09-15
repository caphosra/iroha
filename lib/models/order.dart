import "package:flutter_riverpod/flutter_riverpod.dart";
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
}

class IrohaOrderList extends StateNotifier<List<IrohaOrder>> {
	IrohaOrderList([List<IrohaOrder>? initial]) : super(initial ?? []);

	void add(int tableNumber, Map<IrohaMenuID, int> foods) {
		var uuid = Uuid().v4();
		state = [
			...state,
			IrohaOrder(id: uuid, posted: DateTime.now(), tableNumber: tableNumber, foods: foods)
		];
	}

	void delete(String id) {
		state.removeWhere((order) => order.id == id);
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
}
