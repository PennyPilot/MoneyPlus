import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moneyplus/data/service/supabase_service.dart';
import 'package:moneyplus/domain/entity/user.dart' as user_entity;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_constants.dart';
import '../../domain/repository/authentication_repository.dart';
import '../service/app_secrets_provider.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SupabaseService supabaseService;
  final AppSecretsProvider appSecrets;

  AuthenticationRepositoryImpl({
    required this.supabaseService,
    required this.appSecrets,
  });

  @override
  Future<void> register(user_entity.User user, String password) async {
    final client = await supabaseService.getClient();
    await client.auth.signUp(
      email: user.email,
      password: password,
      data: {"name": user.username, "is_complete": false},
    );
  }

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

  @override
  Stream<AuthState> get onAuthStateChange {
    final supabaseClientFuture = supabaseService.getClient();
    return Stream.fromFuture(supabaseClientFuture).asyncExpand((supabase) {
      return supabase.auth.onAuthStateChange;
    });
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    final client = await supabaseService.getClient();
    await client.auth.resetPasswordForEmail(
      email,
      redirectTo: AppConstants.resetPasswordRedirect,
    );
  }

  @override
  Future<void> updatePassword(String password) async {
    final client = await supabaseService.getClient();
    await client.auth.updateUser(UserAttributes(password: password));
  }
}
