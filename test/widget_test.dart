import 'package:cleanroll/app/app.dart';
import 'package:cleanroll/controllers/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home screen shows CleanRoll branding', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsController();
    await settings.load();

    await tester.pumpWidget(CleanRollApp(settings: settings));
    await tester.pump();

    expect(find.text('CleanRoll'), findsOneWidget);
    expect(find.textContaining('one photo at a time'), findsOneWidget);
  });
}
