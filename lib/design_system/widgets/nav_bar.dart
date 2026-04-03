import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

enum NavBarTab {
  home(
    AppAssets.icHomePrimary,
    AppAssets.icHomeGray,
  ),
  transaction(
    AppAssets.icTransactionPrimary,
    AppAssets.icTransactionGray,
  ),
  statistics(
    AppAssets.icStatisticsPrimary,
    AppAssets.icStatisticsGray,
  ),
  account(
    AppAssets.icAccountPrimary,
    AppAssets.icAccountGray,
  );

  final String assetSelected;
  final String assetUnselected;

  const NavBarTab(this.assetSelected, this.assetUnselected);

  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case NavBarTab.home:
        return l10n.home;
      case NavBarTab.transaction:
        return l10n.transactions;
      case NavBarTab.statistics:
        return l10n.statistics;
      case NavBarTab.account:
        return l10n.account;
    }
  }
}

class NavBar extends StatelessWidget {
  final NavBarTab selectedTab;
  final void Function(NavBarTab) onTabSelected;

  const NavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.localizations;

    return Container(
      padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
      decoration: BoxDecoration(color: colors.surfaceLow),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        verticalDirection: VerticalDirection.up,
        children: NavBarTab.values.map((tab) {
          final isSelected = tab == selectedTab;

          return GestureDetector(
            onTap: () {
              onTabSelected(tab);
            },
            child: SizedBox(
              width: 82,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    isSelected ? tab.assetSelected : tab.assetUnselected,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        isSelected ? colors.primary : colors.body,
                        BlendMode.srcIn),
                  ),
                  if (isSelected) ...[
                    Text(
                      tab.getTitle(l10n),
                      style: typography.label.small.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 4,
                      margin: EdgeInsetsGeometry.directional(top: 11),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.2),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: Offset.fromDirection(0, -4),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        color: colors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
