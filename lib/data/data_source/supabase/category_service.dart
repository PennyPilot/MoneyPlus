import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/service/supabase_service.dart';
import '../../../domain/service/category_service.dart';

class SupabaseCategoryService implements CategoryService {
  final SupabaseService service;

  SupabaseCategoryService({required this.service});

  @override
  Future<void> addCategory(Map<String, dynamic> data) async {
    final client = await service.getClient();
    await client.from('categories').insert(data);
  }

  @override
  Future<List<dynamic>> getCategories(String userId) async {
    final client = await service.getClient();
    final response = await client
        .from('categories')
        .select()
        .eq('user_id', userId)
        .order('id', ascending: true);
    return response as List;
  }

  @override
  Future<void> updateCategory(
      Map<String, dynamic> data, int id, String userId) async {
    final client = await service.getClient();
    await client.from('categories').update(data).match({
      'id': id,
      'user_id': userId,
    });
  }
}
