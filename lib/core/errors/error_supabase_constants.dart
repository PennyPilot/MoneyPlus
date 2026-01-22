// class ErrorSupabaseConstants {
//   ErrorSupabaseConstants._();
//
//   static const String defultSupabaseFailure = 'Errororrr';
//
//   static const Set<String> allSupabaseErrorCode = {
//     'unexpected_failure',
//     'validation_failed',
//     'invalid_credentials',
//     'bad_json',
//     'email_exists',
//     'phone_exists',
//     'bad_jwt',
//     'not_admin',
//     'no_authorization',
//     'user_not_found',
//     'session_not_found',
//     'flow_state_not_found',
//     'flow_state_expired',
//     'signup_disabled',
//     'user_banned',
//     'provider_email_needs_verification',
//     'invite_not_found',
//     'bad_oauth_state',
//     'bad_oauth_callback',
//     'oauth_provider_not_supported',
//     'unexpected_audience',
//     'single_identity_not_deletable',
//     'email_conflict_identity_not_deletable',
//     'identity_already_exists',
//     'email_provider_disabled',
//     'phone_provider_disabled',
//     'too_many_enrolled_mfa_factors',
//     'mfa_factor_name_conflict',
//     'mfa_factor_not_found',
//     'mfa_ip_address_mismatch',
//     'mfa_challenge_expired',
//     'mfa_verification_failed',
//     'mfa_verification_rejected',
//     'insufficient_aal',
//     'captcha_failed',
//     'saml_provider_disabled',
//     'manual_linking_disabled',
//     'sms_send_failed',
//     'email_not_confirmed',
//     'phone_not_confirmed',
//     'reauth_nonce_missing',
//     'saml_relay_state_not_found',
//     'saml_relay_state_expired',
//     'saml_idp_not_found',
//     'saml_assertion_no_user_id',
//     'saml_assertion_no_email',
//     'user_already_exists',
//     'sso_provider_not_found',
//     'saml_metadata_fetch_failed',
//     'saml_idp_already_exists',
//     'sso_domain_already_exists',
//     'saml_entity_id_mismatch',
//     'conflict',
//     'provider_disabled',
//     'user_sso_managed',
//     'reauthentication_needed',
//     'same_password',
//     'reauthentication_not_valid',
//     'otp_expired',
//     'otp_disabled',
//     'identity_not_found',
//     'weak_password',
//     'over_request_rate_limit',
//     'over_email_send_rate_limit',
//     'over_sms_send_rate_limit',
//     'bad_code_verifier',
//     'anonymous_provider_disabled',
//     'hook_timeout',
//     'hook_timeout_after_retry',
//     'hook_payload_over_size_limit',
//     'hook_payload_unknown_size',
//     'request_timeout',
//     'mfa_phone_enroll_not_enabled',
//     'mfa_phone_verify_not_enabled',
//     'mfa_totp_enroll_not_enabled',
//     'mfa_totp_verify_not_enabled',
//   };
//
//   static bool isContainsErrorCode(String? code) {
//     return code != null && allSupabaseErrorCode.contains(code);
//   }
// }
//
//
// /* class ErrorSupabaseConstants {
//   static const String unexpectedFailure = 'unexpected_failure';
//   static const String validationFailed = 'validation_failed';
//   static const String badJson = 'bad_json';
//   static const String emailExists = 'email_exists';
//   static const String phoneExists = 'phone_exists';
//   static const String badJwt = 'bad_jwt';
//   static const String notAdmin = 'not_admin';
//   static const String noAuthorization = 'no_authorization';
//   static const String userNotFound = 'user_not_found';
//   static const String sessionNotFound = 'session_not_found';
//   static const String flowStateNotFound = 'flow_state_not_found';
//   static const String flowStateExpired = 'flow_state_expired';
//   static const String signupDisabled = 'signup_disabled';
//   static const String userBanned = 'user_banned';
//   static const String providerEmailNeedsVerification =
//       'provider_email_needs_verification';
//   static const String inviteNotFound = 'invite_not_found';
//   static const String badOauthState = 'bad_oauth_state';
//   static const String badOauthCallback = 'bad_oauth_callback';
//   static const String oauthProviderNotSupported =
//       'oauth_provider_not_supported';
//   static const String unexpectedAudience = 'unexpected_audience';
//   static const String singleIdentityNotDeletable =
//       'single_identity_not_deletable';
//   static const String emailConflictIdentityNotDeletable =
//       'email_conflict_identity_not_deletable';
//   static const String identityAlreadyExists = 'identity_already_exists';
//   static const String emailProviderDisabled = 'email_provider_disabled';
//   static const String phoneProviderDisabled = 'phone_provider_disabled';
//   static const String tooManyEnrolledMfaFactors =
//       'too_many_enrolled_mfa_factors';
//   static const String mfaFactorNameConflict = 'mfa_factor_name_conflict';
//   static const String mfaFactorNotFound = 'mfa_factor_not_found';
//   static const String mfaIpAddressMismatch = 'mfa_ip_address_mismatch';
//   static const String mfaChallengeExpired = 'mfa_challenge_expired';
//   static const String mfaVerificationFailed = 'mfa_verification_failed';
//   static const String mfaVerificationRejected = 'mfa_verification_rejected';
//   static const String insufficientAal = 'insufficient_aal';
//   static const String captchaFailed = 'captcha_failed';
//   static const String samlProviderDisabled = 'saml_provider_disabled';
//   static const String manualLinkingDisabled = 'manual_linking_disabled';
//   static const String smsSendFailed = 'sms_send_failed';
//   static const String emailNotConfirmed = 'email_not_confirmed';
//   static const String phoneNotConfirmed = 'phone_not_confirmed';
//   static const String reauthNonceMissing = 'reauth_nonce_missing';
//   static const String samlRelayStateNotFound = 'saml_relay_state_not_found';
//   static const String samlRelayStateExpired = 'saml_relay_state_expired';
//   static const String samlIdpNotFound = 'saml_idp_not_found';
//   static const String samlAssertionNoUserId = 'saml_assertion_no_user_id';
//   static const String samlAssertionNoEmail = 'saml_assertion_no_email';
//   static const String userAlreadyExists = 'user_already_exists';
//   static const String ssoProviderNotFound = 'sso_provider_not_found';
//   static const String samlMetadataFetchFailed = 'saml_metadata_fetch_failed';
//   static const String samlIdpAlreadyExists = 'saml_idp_already_exists';
//   static const String ssoDomainAlreadyExists = 'sso_domain_already_exists';
//   static const String samlEntityIdMismatch = 'saml_entity_id_mismatch';
//   static const String conflict = 'conflict';
//   static const String providerDisabled = 'provider_disabled';
//   static const String userSsoManaged = 'user_sso_managed';
//   static const String reauthenticationNeeded = 'reauthentication_needed';
//   static const String samePassword = 'same_password';
//   static const String reauthenticationNotValid = 'reauthentication_not_valid';
//   static const String otpExpired = 'otp_expired';
//   static const String otpDisabled = 'otp_disabled';
//   static const String identityNotFound = 'identity_not_found';
//   static const String weakPassword = 'weak_password';
//   static const String overRequestRateLimit = 'over_request_rate_limit';
//   static const String overEmailSendRateLimit = 'over_email_send_rate_limit';
//   static const String overSmsSendRateLimit = 'over_sms_send_rate_limit';
//   static const String badCodeVerifier = 'bad_code_verifier';
//   static const String anonymousProviderDisabled = 'anonymous_provider_disabled';
//   static const String hookTimeout = 'hook_timeout';
//   static const String hookTimeoutAfterRetry = 'hook_timeout_after_retry';
//   static const String hookPayloadOverSizeLimit = 'hook_payload_over_size_limit';
//   static const String hookPayloadUnknownSize = 'hook_payload_unknown_size';
//   static const String requestTimeout = 'request_timeout';
//   static const String mfaPhoneEnrollDisabled = 'mfa_phone_enroll_not_enabled';
//   static const String mfaPhoneVerifyDisabled = 'mfa_phone_verify_not_enabled';
//   static const String mfaTotpEnrollDisabled = 'mfa_totp_enroll_not_enabled';
//   static const String mfaTotpVerifyDisabled = 'mfa_totp_verify_not_enabled';
// } */
//
