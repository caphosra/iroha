import "package:flutter_test/flutter_test.dart";

import "package:iroha/main.dart";

void main() {
	testWidgets("Iroha execution test", (WidgetTester tester) async {
		await tester.pumpWidget(IrohaApp());

		expect(find.text("Irohaへようこそ"), findsOneWidget);
		expect(find.text("Flutter最強!"), findsNothing);
	});
}
