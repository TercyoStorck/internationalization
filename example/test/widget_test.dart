import 'package:flutter_test/flutter_test.dart';
import 'package:internationalization_example/main.dart';

void main() {
  testWidgets('ShowcaseApp renders without crashing', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    // App requires asset loading; just verify it inflates without throwing.
    expect(find.byType(ShowcaseApp), findsOneWidget);
  });
}
