import '../../core/errors/result.dart';
import '../entity/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories();
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
}
