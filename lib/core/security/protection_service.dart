
import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freerasp/freerasp.dart';

import '../../data/repository/secure_storage.dart';
import '../constants/app_constants.dart';

class ProtectionService {
  SecureStorage secureStorage;

  ProtectionService({required this.secureStorage});

  Future<void> init() {
    final completer = Completer<void>();
    const securityWindow = Duration(seconds: 2);

    Future<void> handleThreat(String threatType) async {
      if (kDebugMode) {
        print("CRITICAL: Security threat detected! Type: $threatType. Terminating application.");
      }
      await FirebaseCrashlytics.instance.recordError(
        Exception('Security Threat: $threatType'),
        StackTrace.current,
        reason: 'A security threat ($threatType) was detected by freerasp.',
        fatal: true,
      );

      if (!kDebugMode) {
        exit(0);
      }
    }

    final signingHash = dotenv.env[AppConstants.hashedSignature];
    final watcherMail = dotenv.env[AppConstants.watcherMail];
    final supportedStoresValue = dotenv.env[AppConstants.talsecSupportedStores];
    final supportedStores = supportedStoresValue?.split(',') ?? [];

    final androidPackageName =
        dotenv.env[AppConstants.talsecAndroidPackageName] ?? "";
    final iosBundleId = dotenv.env[AppConstants.talsecIosBundleId] ?? "";
    final iosTeamId = dotenv.env[AppConstants.talsecIosTeamId] ?? "";

    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: androidPackageName,
        signingCertHashes: [signingHash ?? ""],
        supportedStores: supportedStores,
      ),
      iosConfig: IOSConfig(
        bundleIds: [iosBundleId],
        teamId: iosTeamId,
      ),
      watcherMail: watcherMail ?? "",
      isProd: true,
    );

    final callback = ThreatCallback(
      onAppIntegrity: () => handleThreat('AppIntegrity'),
      onObfuscationIssues: () => handleThreat('ObfuscationIssues'),
      onDebug: () => handleThreat('Debug'),
      onDeviceBinding: () => handleThreat('DeviceBinding'),
      onHooks: () => handleThreat('Hooks'),
      onPrivilegedAccess: () => handleThreat('PrivilegedAccess'),
      onSimulator: () => handleThreat('Simulator'),
      //onUnofficialStore: handleThreat, //
      onMultiInstance: () => handleThreat('MultiInstance'),
    );

    Talsec.instance.attachListener(callback);

    Talsec.instance.start(config);
    Timer(securityWindow, () {
      if (!completer.isCompleted) {
        if (kDebugMode) {
          debugPrint("Security window passed without threats.");
        }
        completer.complete();
      }
    });

    return completer.future;
  }
}