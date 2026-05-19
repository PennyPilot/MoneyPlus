import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/domain/entity/category.dart';
import 'package:moneyplus/presentation/categories/cubit/categories_cubit.dart';
import 'package:moneyplus/presentation/categories/cubit/categories_state.dart';
import 'package:moneyplus/presentation/categories/widget/add_category_bottom_sheet.dart';
import 'package:moneyplus/presentation/categories/widget/category_app_bar.dart';
import 'package:moneyplus/presentation/categories/widget/category_bottom_bar.dart';
import 'package:moneyplus/presentation/categories/widget/category_grid.dart';
import 'package:moneyplus/presentation/transactions/widget/loading_view.dart';

class ManageCategoriesScreenContent extends StatelessWidget {
  const ManageCategoriesScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: localizations.manage_categories,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => context.pop(),
        ),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CategoriesStatus.failure) {
            MSnackBar.error(
              message: state.error?.localize(context) ?? localizations.error,
              title: localizations.error,
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          if (state.status == CategoriesStatus.loading) {
            return const LoadingView();
          }

          if (state.categories.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  localizations.no_categories_found,
                  style: typography.label.medium.copyWith(color: colors.primary),
                ),
              )
            );
          }

          return CategoryGrid(
            categories: state.categories,
            isArabic: isArabic,
            onEditCategory: (category) =>
                _openBottomSheet(context, category: category),
          );
        },
      ),
      bottomNavigationBar: CategoryBottomBar(
        buttonText: localizations.add_new_category,
        onPressed: () => _openBottomSheet(context),
      ),
    );
  }

  void _openBottomSheet(BuildContext context, {Category? category}) {
    final cubit = context.read<CategoriesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddCategorySheet(category: category),
      ),
    );
  }
}
