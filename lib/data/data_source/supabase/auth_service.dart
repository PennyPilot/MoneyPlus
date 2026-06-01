import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_model.dart';
import '../../../core/errors/result.dart';
import '../../../core/errors/supabase_auth_error.dart';
import '../../../core/security/app_secrets.dart';
import '../../../core/service/supabase_service.dart';
import '../../../domain/entity/auth_status.dart';
import '../../../domain/entity/user.dart';
import '../../../domain/service/auth_service.dart';

class SupabaseAuthService implements AuthService {
  final SupabaseService supabaseService;
  final AppSecrets appSecrets;
  final _statusController = StreamController<AuthStatus>.broadcast();
  StreamSubscription<AuthState>? _authSubscription;

  SupabaseAuthService({
    required this.supabaseService,
    required this.appSecrets,
  }) {
    _init();
  }

  void _init() async {
    final client = await supabaseService.getClient();
    _authSubscription = client.auth.onAuthStateChange.listen((data) async {
      final status = await _mapAuthStateToStatus(client, data);
      _statusController.add(status);
    });
  }

  Future<AuthStatus> _mapAuthStateToStatus(
      SupabaseClient client, AuthState data) async {
    final session = data.session;
    final event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      return AuthStatus.passwordRecovery;
    }

    if (session == null) {
      return AuthStatus.unauthenticated;
    }

    try {
      final userId = session.user.id;
      final response = await client
          .from('users')
          .select('is_complete')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response['is_complete'] == true) {
        return AuthStatus.authenticated;
      } else {
        return AuthStatus.accountSetupIncomplete;
      }
    } catch (e) {
      return AuthStatus.accountSetupIncomplete;
    }
  }

  @override
  Future<void> refreshAuthStatus() async {
    final client = await supabaseService.getClient();
    final session = client.auth.currentSession;
    final status = await _mapAuthStateToStatus(
      client,
      AuthState(AuthChangeEvent.signedIn, session),
    );
    _statusController.add(status);
  }

  @override
  Future<Result<User>> register(User user, String password) async {
    try {
      final client = await supabaseService.getClient();
      final response = await client.auth.signUp(
        email: user.email,
        password: password,
        data: {"name": user.name, "is_complete": false},
      );

      if (response.user != null) {
        final registeredUser = User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          name: response.user!.userMetadata?['name'] ?? '',
        );
        return Result.success(registeredUser);
      } else {
        return Result.error(ErrorModel('User data is null'));
      }
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      return Result.error(ErrorModel(error.toString()));
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
      return Result.error(ErrorModel(error.toString()));
    }
  }

  @override
  Stream<AuthStatus> get onAuthStatusChange async* {
    final client = await supabaseService.getClient();
    final status = await _mapAuthStateToStatus(
      client,
      AuthState(AuthChangeEvent.initialSession, client.auth.currentSession),
    );
    yield status;
    yield* _statusController.stream;
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
      return Result.error(ErrorModel(error.toString()));
    }
  }

  @override
  Future<Result<bool>> updateUserInfo(User user) async {
    try {
      final client = await supabaseService.getClient();
      await client.auth.updateUser(
          UserAttributes(email: user.email, data: {"name": user.name}));
      return Result.success(true);
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
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
      return Result.error(ErrorModel(error.toString()));
    }
  }

  static const List<String> _googleScopes = ['email', 'profile', 'openid'];

  @override
  Future<String?> get userEmail async {
    final client = await supabaseService.getClient();
    return client.auth.currentUser?.email;
  }

  @override
  Future<void> signOut() async {
    final client = await supabaseService.getClient();
    await client.auth.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
    _statusController.close();
  }
}
