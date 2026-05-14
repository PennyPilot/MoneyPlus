import 'package:moneyplus/core/errors/result.dart';
import 'package:moneyplus/domain/entity/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/service/supabase_service.dart';
import '../../domain/repository/category_repository.dart';
import '../../domain/service/category_service.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryService service;
  final SupabaseService supabaseService;

  CategoryRepositoryImpl({
    required this.service,
    required this.supabaseService,
  });

  @override
  Future<void> addCategory(Category category) async {
    try {
      final (_, userId) = await _getAuthenticatedUser();

      final data = category.toJson();
      if (data['id'] == 0 || data['id'] == null) {
        data.remove('id');
      }

      data['user_id'] = userId;

      await service.addCategory(data);
    } on PostgrestException catch (e) {
      _handlePostgrestException(e, 'add');
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    try {
      final (_, userId) = await _getAuthenticatedUser();
      final data = category.toJson();
      data['user_id'] = userId;
      
      await service.updateCategory(data, category.id, userId);
    } on PostgrestException catch (e) {
      _handlePostgrestException(e, 'update');
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final client = await supabaseService.getClient();
      final user = client.auth.currentUser;

      if (user == null) return Result.success([]);

      final response = await service.getCategories(user.id);

      final categories = (response)
          .map((json) => Category.fromJson(json))
          .toList();
      return Result.success(categories);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<(SupabaseClient, String)> _getAuthenticatedUser() async {
    final client = await supabaseService.getClient();
    final user = client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return (client, user.id);
  }

  void _handlePostgrestException(PostgrestException e, String action) {
    if (e.code == '23505') throw Exception('Category already exists');
    throw Exception('Failed to $action category: ${e.message}');
  }
}
