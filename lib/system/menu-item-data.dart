import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuData extends StateNotifier<List<String>> {
	MenuData([List<String>? initial]) : super(initial ?? []);

	void add(String id) {
		state = [ ...state, id ];
	}
}
