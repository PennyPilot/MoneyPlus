import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/di/injection.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/app_empty_view.dart';
import 'package:moneyplus/design_system/widgets/app_error_view.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/presentation/statistics/widgets/CategoryBreakdown.dart';

import '../widgets/drop_down_date_dialog.dart';
import 'cubit/statistics_cubit.dart';
import 'cubit/statistics_state.dart';
import 'widgets/monthly_overview/monthly_overview_section.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StatisticsCubit>()..loadStatistics(),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  void _onAddTransaction() {
    // Navigate to add transaction
  }

  void _onRetry() {
    context.read<StatisticsCubit>().loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            return switch (state) {
              StatisticsIdle() => const SizedBox.shrink(),
              StatisticsLoading() => const AppLoadingIndicator(),
              StatisticsSuccess() => _buildSuccess(context, state),
              StatisticsFailure(:final message) => AppErrorView(
                message: message,
                onRetry: _onRetry,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, StatisticsSuccess state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.hasNoData) {
      return AppEmptyView(
        title: l10n.no_statistics_title,
        subtitle: l10n.no_statistics_subtitle,
        buttonText: l10n.add_transaction,
        onButtonPressed: _onAddTransaction,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomAppBar(
            title: l10n.statistics,
            trailing: DropDownDateDialog(
              onDatePick: (date) => {
                context.read<StatisticsCubit>().changeMonth(date),
              },
              year: state.selectedMonth.year,
              month: state.selectedMonth.month,
            ),
          ),
            MonthlyOverviewSection(overview: state.monthlyOverview),
            CategoryBreakdownWidget(
              categoriesBreakdown: state.categoriesBreakdown,
            ),
        ],
      ),
    );
  }
}
