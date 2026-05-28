// Smoke test — checks the app boots and renders the home AppBar title.
import 'package:flutter_test/flutter_test.dart';

import 'package:checkin_app/main.dart';

void main() {
  testWidgets('App boots and shows the title', (tester) async {
    await tester.pumpWidget(const CheckinApp());
    // First frame — the title is in the AppBar; the venues list is loading.
    expect(find.text('Checkin Georgia'), findsOneWidget);
  });
}
