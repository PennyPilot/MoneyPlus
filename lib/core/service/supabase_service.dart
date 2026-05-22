import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneyplus/data/repository/secure_storage.dart';
import 'package:moneyplus/domain/repository/app_preferences_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../security/app_secrets.dart';

class SupabaseService {
  SupabaseClient? _supabaseClient;
  final AppSecrets appSecrets;
  final AppPreferencesRepository appPreferencesRepository;

  SupabaseService({
    required this.appSecrets,
    required this.appPreferencesRepository,
  });

  Future<SupabaseClient> getClient() async {
    if (_supabaseClient != null) {
      await _updateLanguageHeader(_supabaseClient!);
      return _supabaseClient!;
    }

    final url = appSecrets.getRemoteConfigSupaBaseUrl();
    final anonKey = appSecrets.getRemoteConfigSupaBaseApiKey();

    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: kDebugMode,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureStorage(storage: FlutterSecureStorage()),
      ),
    );

    _supabaseClient = supabase.client;

    await _updateLanguageHeader(_supabaseClient!);

    return _supabaseClient!;
  }

  Future<void> _updateLanguageHeader(SupabaseClient client) async {
    final language = await appPreferencesRepository.getAppLanguage();
    final langCode = language == AppLanguage.ar ? 'ar' : 'en';

    client.rest.headers['accept-language'] = langCode;
    client.functions.headers['accept-language'] = langCode;
  }
}
