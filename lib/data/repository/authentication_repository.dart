import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moneyplus/core/security/app_secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/constants/app_constants.dart';
import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../core/errors/supabase_auth_error.dart';
import '../../core/service/supabase_service.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SupabaseService supabaseService;
  final AppSecrets appSecrets;

  AuthenticationRepositoryImpl({
    required this.supabaseService,
    required this.appSecrets,
  });

  @override
  Future<Result<void>> register(User user, String password) async {
    try {
      final client = await supabaseService.getClient();
      final response = await client.auth.signUp(
        email: user.email,
        password: password,
        data: {"name": user.name, "is_complete": false},
      );

      if (response.user != null) {
        return Result.success(null);
      } else {
        return Result.error(ErrorModel('User data is null'));
      }
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      if (kDebugMode) {
        print('Caught error during register: $error');
      }
      rethrow;
    }
  }

  @override
  Future<Result<bool>> signInWithGoogle() async {
    try {
      final serverClientId = appSecrets.getRemoteConfigGoogeWebClientId();
      final clientId = appSecrets.getRemoteConfigGoogeIosClientId();
      final GoogleSignIn signIn = GoogleSignIn.instance;
      (signIn.initialize(serverClientId: serverClientId, clientId: clientId),);

      final googleAccount = await signIn.authenticate();
      final googleAuthorization = await googleAccount.authorizationClient
          .authorizationForScopes(_googleScopes);
      final googleAuthentication = googleAccount.authentication;
      final idToken = googleAuthentication.idToken;
      final accessToken = googleAuthorization?.accessToken;

      if (idToken == null) {
        return Result.error(ErrorModel('No ID Token found from Google.'));
      }
      final client = await supabaseService.getClient();
      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      return Result.success(true);
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }

  @override
  Stream<AuthState> get onAuthStateChange {
    final supabaseClientFuture = supabaseService.getClient();
    return Stream.fromFuture(supabaseClientFuture).asyncExpand((supabase) {
      return supabase.auth.onAuthStateChange;
    });
  }

  @override
  Future<Result<bool>> resetPasswordForEmail(String email) async {
    try {
      final client = await supabaseService.getClient();
      await client.auth.resetPasswordForEmail(
        email,
        redirectTo: AppConstants.resetPasswordRedirect,
      );
      return Result.success(true);
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }

  @override
  Future<Result<bool>> updatePassword(String password) async {
    try {
      final client = await supabaseService.getClient();
      await client.auth.updateUser(UserAttributes(password: password));
      return Result.success(true);
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }

  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await supabaseService.getClient();
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final user = User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          name: response.user!.userMetadata?['name'] ?? 'Unknown',
        );
        return Result.success(user);
      }
      return Result.error(ErrorModel('User data is null'));
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }

  static const List<String> _googleScopes = ['email', 'profile', 'openid'];

  @override
  Future<String?> get userEmail async {
    final supabaseClientFuture = await supabaseService.getClient();
    return supabaseClientFuture.auth.currentUser?.email;
  }
}
