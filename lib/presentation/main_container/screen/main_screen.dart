import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/core/di/injection.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/nav_bar.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/presentation/account/screen/account_screen.dart';
import 'package:moneyplus/presentation/currency/cubit/currency_rates_cubit.dart';
import 'package:moneyplus/presentation/currency/cubit/currency_rates_state.dart';
import 'package:moneyplus/presentation/currency/widget/currency_rates_view.dart';
import 'package:moneyplus/presentation/home/screen/home_screen.dart';
import 'package:moneyplus/presentation/main_container/cubit/main_cubit.dart';
import 'package:moneyplus/presentation/main_container/cubit/main_state.dart';
import 'package:moneyplus/presentation/statistics/statistics_screen.dart';
import 'package:moneyplus/presentation/transactions/screen/transactions_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final isHome = state.selectedTab == NavBarTab.home;
          
          return PopScope(
            canPop: state.selectedTab == NavBarTab.home,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              context.read<MainCubit>().onTabSelected(NavBarTab.home);
            },
            child: Stack(
              children: [
                Scaffold(
                  extendBody: true,
                  backgroundColor: context.colors.surface,
                  body: _getScreenForTab(state.selectedTab, state.transactionCategoryFilters),
                  bottomNavigationBar: NavBar(
                    selectedTab: state.selectedTab,
                    onTabSelected: (tab) {
                      context.read<MainCubit>().onTabSelected(tab);
                    },
                  ),
                ),
                if (isHome)
                  Positioned(
                    bottom: 90,
                    left: 0,
                    right: 0,
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.05).animate(
                        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                      ),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _showCurrencyConversionSheet(context),
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    context.colors.primary,
                                    context.colors.primary.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colors.primary.withValues(alpha:0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.icCurrencyExchange,
                                  width: 34,
                                  height: 34,
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getScreenForTab(NavBarTab tab, List<int>? filters) {
    switch (tab) {
      case NavBarTab.home:
        return const HomeScreen();
      case NavBarTab.transaction:
        return TransactionsScreen(initialCategoryIds: filters);
      case NavBarTab.statistics:
        return const StatisticsScreen();
      case NavBarTab.account:
        return const AccountScreen();
    }
  }

  void _showCurrencyConversionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (context) => getIt<CurrencyRatesCubit>()..init(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: context.colors.stroke.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.icCurrencyExchange,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(context.colors.primary, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      context.localizations.currencyRates,
                      style: context.typography.title.small.copyWith(
                        color: context.colors.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<CurrencyRatesCubit, CurrencyRatesState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(Icons.calendar_month_rounded, color: context.colors.primary),
                          onPressed: () async {
                            final colors = context.colors;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: state.date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: colors.primary,
                                      onPrimary: colors.onPrimary,
                                      onSurface: colors.title,
                                      surface: colors.surfaceLow,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && context.mounted) {
                              context.read<CurrencyRatesCubit>().onDateChanged(picked);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Expanded(
                child: CurrencyRatesView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
