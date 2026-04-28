import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/income_expense.dart';
import 'package:moneyplus/design_system/widgets/top_spending_card.dart';
import 'package:moneyplus/presentation/home/cubit/home_cubit.dart';
import 'package:moneyplus/presentation/home/cubit/home_state.dart';
import 'package:moneyplus/presentation/home/widget/current_balance.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import '../../../core/di/injection.dart';
import '../../../design_system/widgets/buttons/button/varient_button.dart';
import '../../../design_system/widgets/buttons/secondary/sm_secondary_button.dart';
import '../utils/StringFormattingHelpers.dart';
import '../widget/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAppBarOnly = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      if (offset > 1 && !showAppBarOnly) {
        setState(() => showAppBarOnly = true);
      } else if (offset <= 1 && showAppBarOnly) {
        setState(() => showAppBarOnly = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentDate = DateTime.now();
    return BlocProvider(
      create: (context) =>
          getIt<HomeCubit>()..getData(month: currentDate.month, year: currentDate.year),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          var content = switch (state) {
            HomeLoading() => Scaffold(
              backgroundColor: colors.surface,
              body: Center(
                child: CircularProgressIndicator(
                  color: colors.primary,
                ),
              ),
            ),
            HomeLoaded() => _loadedContent(
              context: context,
              state: state,
              scrollController: _scrollController,
              showAppBarOnly: showAppBarOnly,
              setSelectedDate: (date) {
                cubit.setSelectedDate(
                  date.month,
                  date.year,
                );
              },
              reloadScreen: (){
                cubit.onRefreshHomeScreen();
              }
            ),
            HomeError() => Scaffold(
              body: Center(child: Text(state.errorMessage)),
            ),
          };
          return content;
        },
      ),
    );
  }
}

Widget _loadedContent({
  required BuildContext context,
  required HomeLoaded state,
  required ScrollController scrollController,
  required bool showAppBarOnly,
  required Function(DateTime) setSelectedDate,
  required Function reloadScreen,
}) {
  final colors = context.colors;
  final topSpendingCategories = state.topSpendingCategories;
  final typography = context.typography;
  final localizations = AppLocalizations.of(context)!;
  return Scaffold(
    body: Container(
      color: colors.surface,
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _topSection(
                showAppBarOnly: showAppBarOnly,
                state: state,
                onDatePick: setSelectedDate,
                context: context,
                reloadScreen: reloadScreen
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: IncomeExpense(
                                    type: IncomeExpenseType.income,
                                    currency: state.currency,
                                    amount: formatWithCommas(
                                      state.totalMonthIncome,
                                    ).toString(),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: IncomeExpense(
                                    type: IncomeExpenseType.expense,
                                    currency: state.currency,
                                    amount: formatWithCommas(
                                      state.totalMonthExpense,
                                    ).toString(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Text(
                              localizations.top_spending_category,
                              style: typography.title.small.copyWith(
                                color: colors.title,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    if (topSpendingCategories.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            localizations.no_spending_categories,
                            style: typography.body.medium.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ),
                      )
                    else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: topSpendingCategories.length,
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                              left: 16,
                              right: 16,
                            ),
                            child: TopSpendingCard(
                              expenseCategory:
                                  topSpendingCategories[index].category.name,
                              amount:
                                  "${formatWithCommas(topSpendingCategories[index].total)} ${topSpendingCategories[index].currency}",
                              transactionCount:
                                  topSpendingCategories[index].numberOfTransactions,
                              percentage:
                                  topSpendingCategories[index].percentage,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _topSection({
  required bool showAppBarOnly,
  required HomeLoaded state,
  required Function(DateTime) onDatePick,
  required BuildContext context,
  required Function reloadScreen,
}) {
  final colors = context.colors;
  final localizations = AppLocalizations.of(context)!;
  if (showAppBarOnly) {
    return Container(
      color: colors.surfaceLow,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          color: colors.surfaceLow,
          child: homeAppBar(
            month: state.selectedMonth,
            year: state.selectedYear,
            onDatePick: onDatePick,
            context: context
          ),
        ),
      ),
    );
  } else {
    return Container(
      padding: EdgeInsets.only(left: 16),
      width: double.infinity,
      height: 232,
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 79,
            top: 0,
            child: Image.asset(
              AppAssets.flowerShape1,
              height: 165,
              width: 72,
              color: colors.surface,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              AppAssets.flowerShape2,
              height: 232,
              width: 72,
              color: colors.surface,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 52,
            child: CurrentBalanceCard(
              balance: '${formatWithCommas(state.currentBalance)} ${state.currency}',
              percentage: state.currentSavingSpendingPercentage,
            ),
          ),
          Positioned(
            left: 0,
            right: 16,
            bottom: 12,
            child: Row(
              children: [
                Expanded(
                  child: VarientButton(
                    text: localizations.add,
                    iconPath: AppAssets.addMoney,
                    onPressed: () async {
                      await AddIncomeRoute().push(context);
                      reloadScreen();
                    },
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: SMSecondaryButton(
                    text: localizations.spend,
                    iconPath: AppAssets.spendMoney,
                    onPressed: () async {
                      await AddExpenseRoute().push(context);
                      reloadScreen();
                    },
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 19),
              child: homeAppBar(
                month: state.selectedMonth,
                year: state.selectedYear,
                onDatePick: onDatePick,
                context: context
              ),
            ),
          ),
        ],
      ),
    );
  }
}
