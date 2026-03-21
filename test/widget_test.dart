import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const GoFullApp());
    await tester.pump();
  });
}
