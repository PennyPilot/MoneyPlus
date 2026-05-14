import '../../core/errors/result.dart';

abstract class CategoryService {
  Future<List<dynamic>> getCategories(String userId);
  Future<void> addCategory(Map<String, dynamic> data);
  Future<void> updateCategory(Map<String, dynamic> data, int id, String userId);
}
