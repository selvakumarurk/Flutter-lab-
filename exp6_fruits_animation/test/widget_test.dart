import 'package:flutter_test/flutter_test.dart';
import 'package:exp6_fruits_animation/main.dart';

void main() {
  testWidgets('Fruits list renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Orange'), findsOneWidget);
    expect(find.text('Mango'), findsOneWidget);
  });
}
