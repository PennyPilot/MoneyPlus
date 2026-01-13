import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/utils/Assets.dart';

enum NavBarTab {
  home(Assets.icHomePrimary, Assets.icHomeGray, 'Home'),
  transaction(Assets.icTransactionPrimary, Assets.icTransactionGray, 'Transaction'),
  statistics(Assets.icStatisticsPrimary, Assets.icStatisticsGray, 'Statistics'),
  account(Assets.icAccountPrimary, Assets.icAccountGray, 'Account');

  final String assetSelected;
  final String assetNotSelected;
  final String title;

  const NavBarTab(this.assetSelected, this.assetNotSelected, this.title);
}

class NavBar extends StatelessWidget {
  final NavBarTab selectedTab;
  final void Function(NavBarTab) onTabSelected;

  const NavBar({super.key, required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      padding: EdgeInsetsGeometry.directional(start: 16, end: 16, top: 8),
      decoration: BoxDecoration(color: colors.surfaceLow),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        verticalDirection: VerticalDirection.up,
        children: NavBarTab.values.map((tab) {
          final isSelected = tab == selectedTab;

          return GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isSelected? tab.assetSelected : tab.assetNotSelected,
                  width: 24,
                  height: 24,
                ),
                if(!isSelected) SizedBox(height: 8,),
                if (isSelected) ...[
                  Text(tab.title, style: typography.label.small.copyWith(color: colors.primary)),
                  Container(
                    width: 32,
                    height: 4,
                    padding: EdgeInsetsGeometry.directional(top: 11),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 6
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
          );
        }).toList(),
      ),
    );
  }
}
