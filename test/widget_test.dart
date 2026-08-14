import 'package:flutter_test/flutter_test.dart';
import 'package:fensi_app/main.dart';

void main() {
  testWidgets('FENSI App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FensiApp());
    expect(find.text('FENSI'), findsOneWidget);
  });
}
