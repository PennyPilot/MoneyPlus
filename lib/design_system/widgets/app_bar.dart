import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../utils/Assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  const CustomAppBar({super.key, this.title, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    final typo = context.typography;
    final colors = context.colors;
    final contentColor = colors.title;

    return AppBar(
      titleSpacing: 8,
      leadingWidth: leading != null ? 240 : 56,
      automaticallyImplyLeading: false,

      title: title != null
          ? Text(title!, style: typo.title.small.copyWith(color: contentColor))
          : null,

      leading: leading != null
          ? Padding(padding: const EdgeInsets.only(left: 16.0), child: leading!)
          : null,

      actions: [
        if (trailing != null)
          Padding(padding: const EdgeInsets.only(right: 16), child: trailing!),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarCircleButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const AppBarCircleButton({super.key, required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.colors.surfaceHigh,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(assetPath, width: 20, height: 20),
      ),
    );
  }
}

class AppBarCalendar extends StatelessWidget {
  final VoidCallback onTap;
  final String date;

  const AppBarCalendar({super.key, required this.onTap, required this.date});

  @override
  Widget build(BuildContext context) {
    final typo = context.typography;
    final colors = context.colors;
    final contentColor = colors.title;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(date, style: typo.label.small.copyWith(color: contentColor)),
            const SizedBox(width: 4),
            SvgPicture.asset(
              Assets.icArrowDown,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
