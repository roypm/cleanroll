import 'package:flutter/material.dart';

import 'app/app.dart';
import 'controllers/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsController();
  await settings.load();
  runApp(CleanRollApp(settings: settings));
}
