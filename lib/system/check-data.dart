import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CheckFoodData {
	CheckFoodData({required this.id, required this.count});

	final String id;
	final int count;
}

class CheckData {
	CheckData({required this.id, required this.tableNumber, required this.foods});

	final String id;
	final int tableNumber;
	DateTime? posted;
	DateTime? cooked;
	DateTime? served;
	DateTime? paid;
	final List<CheckFoodData> foods;

	void markAsPosted(DateTime time) {
 		this.posted = time;
	}

	void markAsCooked(DateTime time) {
 		this.cooked = time;
	}

	void markAsServed(DateTime time) {
 		this.served = time;
	}

	void markAsPaid(DateTime time) {
 		this.paid = time;
	}
}

class CheckDataList extends StateNotifier<List<CheckData>> {
	CheckDataList([List<CheckData>? initial]) : super(initial ?? []);

	void add(int tableNumber, List<CheckFoodData> foods) {
		var uuid = Uuid().v4();
		state = [
			...state,
			CheckData(id: uuid, tableNumber: tableNumber, foods: foods)
		];
	}
}
