import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_constants.dart';
import 'app_secrets_provider.dart';

class SupabaseService {
  SupabaseClient? _supabaseClient;
  final AppSecretsProvider appSecretsProvider;

  SupabaseService({required this.appSecretsProvider});

  Future<SupabaseClient> getClient() async {
    if (_supabaseClient != null) return _supabaseClient!;

    final dotEnvInstance = await appSecretsProvider.getEnvVariables();

    final supabase = await Supabase.initialize(
      url: dotEnvInstance.env[AppConstants.supabaseUrl] ?? "",
      anonKey: dotEnvInstance.env[AppConstants.supabaseApiKey] ?? "",
      debug: kDebugMode,
    );

    _supabaseClient = supabase.client;


    return _supabaseClient!;
  }
}
