import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


enum SupabaseAuthErrorCode {
  invalidCredentials('invalid_credentials'),
  badJwt('bad_jwt'),
  userNotFound('user_not_found'),
  userAlreadyExists('user_already_exists'),
  emailExists('email_exists'),
  phoneExists('phone_exists'),
  emailNotConfirmed('email_not_confirmed'),
  phoneNotConfirmed('phone_not_confirmed'),
  emailAddressInvalid('email_address_invalid'),
  emailAddressNotAuthorized('email_address_not_authorized'),
  weakPassword('weak_password'),
  emailProviderDisabled('email_provider_disabled'),
  phoneProviderDisabled('phone_provider_disabled'),
  signupDisabled('signup_disabled'),
  sessionExpired('session_expired'),
  reauthenticationNeeded('reauthentication_needed'),
  overRequestRateLimit('over_request_rate_limit'),
  overEmailSendRateLimit('over_email_send_rate_limit'),
  overSmsSendRateLimit('over_sms_send_rate_limit'),
  rateLimitCode('429'),
  captchaFailed('captcha_failed'),
  userBanned('user_banned'),
  unexpectedFailure('unexpected_failure');

  const SupabaseAuthErrorCode(this.code);

  final String code;

  static SupabaseAuthErrorCode? fromString(String code) {
    return SupabaseAuthErrorCode.values
        .where((e) => e.code == code)
        .firstOrNull;
  }
}

enum SupabaseHttpStatusCode {
  forbidden(403),
  unprocessableEntity(422),
  tooManyRequests(429),
  internalServerError(500),
  notImplemented(501);

  const SupabaseHttpStatusCode(this.code);

  final int code;

  static SupabaseHttpStatusCode? fromInt(int code) {
    return SupabaseHttpStatusCode.values
        .where((e) => e.code == code)
        .firstOrNull;
  }
}

extension AuthErrorTranslation on SupabaseAuthErrorCode {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case SupabaseAuthErrorCode.invalidCredentials:
      case SupabaseAuthErrorCode.badJwt:
        return localizations.auth_error_invalid_credentials;

      case SupabaseAuthErrorCode.userNotFound:
        return localizations.auth_error_user_not_found;

      case SupabaseAuthErrorCode.userAlreadyExists:
      case SupabaseAuthErrorCode.emailExists:
      case SupabaseAuthErrorCode.phoneExists:
        return localizations.auth_error_user_already_exists;

      case SupabaseAuthErrorCode.emailNotConfirmed:
      case SupabaseAuthErrorCode.phoneNotConfirmed:
        return localizations.auth_error_not_confirmed;

      case SupabaseAuthErrorCode.emailAddressInvalid:
        return localizations.auth_error_invalid_email;

      case SupabaseAuthErrorCode.emailAddressNotAuthorized:
        return localizations.auth_error_email_not_authorized;

      case SupabaseAuthErrorCode.emailProviderDisabled:
      case SupabaseAuthErrorCode.phoneProviderDisabled:
      case SupabaseAuthErrorCode.signupDisabled:
        return localizations.auth_error_signup_disabled;

      case SupabaseAuthErrorCode.weakPassword:
        return localizations.auth_error_weak_password;

      case SupabaseAuthErrorCode.captchaFailed:
        return localizations.auth_error_captcha_failed;

      case SupabaseAuthErrorCode.sessionExpired:
      case SupabaseAuthErrorCode.reauthenticationNeeded:
        return localizations.auth_error_session_expired;

      case SupabaseAuthErrorCode.overRequestRateLimit:
      case SupabaseAuthErrorCode.overEmailSendRateLimit:
      case SupabaseAuthErrorCode.overSmsSendRateLimit:
      case SupabaseAuthErrorCode.rateLimitCode:
        return localizations.auth_error_rate_limit;

      case SupabaseAuthErrorCode.userBanned:
        return localizations.auth_error_user_banned;

      case SupabaseAuthErrorCode.unexpectedFailure:
        return localizations.auth_error_unexpected;

      default:
        return localizations.auth_error_default;
    }
  }
}

extension HttpStatusCodeTranslation on SupabaseHttpStatusCode {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case SupabaseHttpStatusCode.forbidden:
        return localizations.auth_error_forbidden;

      case SupabaseHttpStatusCode.unprocessableEntity:
        return localizations.auth_error_unprocessable;

      case SupabaseHttpStatusCode.tooManyRequests:
        return localizations.auth_error_too_many_requests;

      case SupabaseHttpStatusCode.internalServerError:
        return localizations.auth_error_server_error;

      case SupabaseHttpStatusCode.notImplemented:
        return localizations.auth_error_not_implemented;

      default:
        return localizations.auth_error_default;
    }
  }
}
