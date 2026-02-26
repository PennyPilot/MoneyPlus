import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:moneyplus/money_app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
  });
  initDI();
 await getIt.allReady();

  runApp(const MoneyApp());
}
