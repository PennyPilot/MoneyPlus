import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_empty_view.dart';
import 'package:moneyplus/design_system/widgets/app_error_view.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';

import '../../core/di/injection.dart';
import 'cubit/statistics_cubit.dart';
import 'cubit/statistics_state.dart';
import 'widgets/monthly_overview/monthly_overview_section.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _onAddTransaction() {
    // Navigate to add transaction
  }

  void _onRetry() {
    context.read<StatisticsCubit>().loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatisticsCubit>()..loadStatistics(),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            body: SafeArea(
              child: switch (state) {
                StatisticsIdle() => const SizedBox.shrink(),
                StatisticsLoading() => const AppLoadingIndicator(),
                StatisticsSuccess() => _buildSuccess(context, state),
                StatisticsFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: _onRetry,
                ),
              },
            ),
          );
        },
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
          if (state.monthlyOverview != null)
            MonthlyOverviewSection(overview: state.monthlyOverview!),
          // TODO: Add other sections here
        ],
      ),
    );
  }
}
