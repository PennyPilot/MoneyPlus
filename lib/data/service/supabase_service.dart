import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'app_secrets_provider.dart';

class SupabaseService {
  Supabase? _supabase;
  final AppSecretsProvider appSecretsProvider;

  SupabaseService({required this.appSecretsProvider});

  Future<Supabase> getClient() async {
    if (_supabase != null) return _supabase!;

    final dotEnvInstance = await appSecretsProvider.getEnvVariables();

    _supabase = await Supabase.initialize(
      url: dotEnvInstance.env[AppConstants.supabaseUrl] ?? "",
      anonKey: dotEnvInstance.env[AppConstants.supabaseApiKey] ?? "",
      debug: kDebugMode,
    );

    return _supabase!;
  }
}
