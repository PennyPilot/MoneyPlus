import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:moneyplus/di/injection.dart';
import 'package:moneyplus/money_app.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
  });
  initDI();

  runApp(const MoneyApp());
}
