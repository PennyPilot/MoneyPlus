import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../security/app_secrets.dart';

class SupabaseService {
  SupabaseClient? _supabaseClient;
  AppSecrets appSecrets;

  SupabaseService({required this.appSecrets});

  Future<SupabaseClient> getClient() async {
    if (_supabaseClient != null) return _supabaseClient!;

    final url = appSecrets.getRemoteConfigSupaBaseUrl();
    final anonKey = appSecrets.getRemoteConfigSupaBaseApiKey();

    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: kDebugMode,
    );

    _supabaseClient = supabase.client;
    return _supabaseClient!;
  }
}
