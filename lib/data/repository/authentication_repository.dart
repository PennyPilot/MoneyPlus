
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/authentication_repository.dart';
import '../service/app_secrets_provider.dart';
import '../service/supabase_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SupabaseService supabaseService;
  final AppSecretsProvider appSecrets;

  AuthenticationRepositoryImpl({
    required this.supabaseService,
    required this.appSecrets,
  });

  @override
  void signInWithGoogle() async {
    try {
      final env = await appSecrets.getEnvVariables();
      final GoogleSignIn signIn = GoogleSignIn.instance;
      (
        signIn.initialize(
          serverClientId: env.env[_googleWebClientId] ?? "",
          clientId: env.env[_googleIosClientId] ?? "",
        ),
      );

      final googleAccount = await signIn.authenticate();
      final googleAuthorization = await googleAccount.authorizationClient
          .authorizationForScopes(_googleScopes);
      final googleAuthentication = googleAccount.authentication;
      final idToken = googleAuthentication.idToken;
      final accessToken = googleAuthorization?.accessToken;

      if (idToken == null) {
        throw 'No ID Token found.';
      }
      final client = await supabaseService.getClient();
      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      if (kDebugMode) {
        print('Caught error during Google Sign-In: $error');
      }
      rethrow;
    }
  }

  static const String _googleWebClientId = "GOOGLE_WEB_CLIENT_ID";
  static const String _googleIosClientId = "GOOGLE_IOS_CLIENT_ID";
  static const List<String> _googleScopes = ['email', 'profile', 'openid'];
}