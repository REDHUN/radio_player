import 'package:flutter_test/flutter_test.dart';
import 'package:malayalam_radio/main.dart';

void main() {
  testWidgets('MalayalamRadioApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MalayalamRadioApp());
    expect(find.text('NOW PLAYING'), findsOneWidget);
    expect(find.text('Popular stations'), findsOneWidget);
  });
}
