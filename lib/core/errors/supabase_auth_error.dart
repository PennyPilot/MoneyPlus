import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/core/errors/supabase_auth_error_code.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/app_localizations.dart';

class SupabaseAuthError extends ErrorModel {
  final SupabaseAuthErrorCode? authCode;
  final SupabaseHttpStatusCode? httpCode;

  SupabaseAuthError(super.message, {this.authCode, this.httpCode});

  factory SupabaseAuthError.fromAuthException(AuthException exception) {
    final String? code = exception.code;
    final int statusCode = int.parse(exception.statusCode ?? '0');

    if (code != null) {
      final authCode = SupabaseAuthErrorCode.fromString(code);
      if (authCode != null) {
        return SupabaseAuthError(exception.message, authCode: authCode);
      }
    }

    final httpCode = SupabaseHttpStatusCode.fromInt(statusCode);
    return SupabaseAuthError(exception.message, httpCode: httpCode);
  }

  @override
  String localize(BuildContext context) {
    if (authCode != null) {
      return authCode!.toLocalizedString(context);
    } else if (httpCode != null) {
      return httpCode!.toLocalizedString(context);
    }
    return AppLocalizations.of(context)!.auth_error_default;
  }
}
