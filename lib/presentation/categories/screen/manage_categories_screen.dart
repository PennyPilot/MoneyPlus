import 'package:flutter/material.dart';
import 'package:moneyplus/presentation/categories/widget/manage_categories_screen_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../cubit/categories_cubit.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoriesCubit>()..fetchCategories(),
      child: const ManageCategoriesScreenContent(),
    );
  }
}
