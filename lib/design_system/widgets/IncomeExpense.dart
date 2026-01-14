import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MoneyColors>();
    if (colors == null) {
      return const SizedBox();
    }

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.greenVariant,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: SvgPicture.asset(
              'assets/icons/ic_arrow_down.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(colors.green, BlendMode.srcIn),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'income',
                style: TextStyle(
                  color: colors.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      color: colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '1,500,000 IQD ',
                    style: TextStyle(
                      color: colors.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
