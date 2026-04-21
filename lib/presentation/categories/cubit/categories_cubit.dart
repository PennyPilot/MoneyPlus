import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/constants/app_constants.dart';
import 'package:moneyplus/core/errors/category_error.dart';
import 'package:moneyplus/domain/entity/category.dart';
import 'package:moneyplus/domain/repository/category_repository.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository repository;

  CategoriesCubit(this.repository) : super(CategoriesState.initial());

  Future<void> fetchCategories() async {
    emit(
      state.copyWith(
        status: CategoriesStatus.loading,
        categories: state.categories,
      ),
    );
    final result = await repository.getCategories();
    result.when(
      onSuccess: (categories) => emit(
        state.copyWith(
          status: CategoriesStatus.success,
          categories: categories,
        ),
      ),
      onError: (error) => _emitError(error, state.categories),
    );
  }

  Future<void> addCategory(String name, {bool isIncome = false}) async {
    if (_isCategoryExists(name)) {
      _emitError(AppConstants.categoryExistsMessage, state.categories);
      return;
    }
    emit(state.copyWith(status: CategoriesStatus.loading));

    try {
      final category = Category(name: name, isIncome: isIncome);
      await repository.addCategory(category);
      await fetchCategories();
    } catch (error) {
      _emitError(error, state.categories);
    }
  }

  Future<void> updateCategory(Category category) async {
    if (_isCategoryExists(category.name, excludeId: category.id) ||
        (category.nameAr.isNotEmpty &&
            _isCategoryExists(category.nameAr, excludeId: category.id))) {
      _emitError(CategoryAlreadyExistsError().message, state.categories);
      return;
    }

    emit(state.copyWith(status: CategoriesStatus.loading));

    try {
      await repository.updateCategory(category);
      await fetchCategories();
    } catch (error) {
      _emitError(error, state.categories);
    }
  }

  bool _isCategoryExists(String name, {int? excludeId}) {
    if (name.trim().isEmpty) return false;
    final searchName = name.trim().toLowerCase();
    return state.categories.any((category) {
      if (excludeId != null && category.id == excludeId) return false;
      return category.name.trim().toLowerCase() == searchName ||
          category.nameAr.trim().toLowerCase() == searchName;
    });
  }

  void _emitError(dynamic error, List<Category> categories) {
    final errorMessage = error.toString();
    final errorModel = errorMessage.contains(AppConstants.categoryExistsMessage)
        ? CategoryAlreadyExistsError()
        : ErrorModel(errorMessage);

    emit(
      state.copyWith(
        status: CategoriesStatus.failure,
        categories: categories,
        error: errorModel,
      ),
    );
  }
}
