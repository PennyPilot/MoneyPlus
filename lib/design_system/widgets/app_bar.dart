  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:moneyplus/design_system/assets/app_assets.dart';
  import 'package:moneyplus/design_system/theme/money_extension_context.dart';

  class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
    final String? title;
    final Widget? leading;
    final Widget? trailing;
    final double? leadingWidth;
    final Color? backgroundColor;

    const CustomAppBar({
      super.key,
      this.title,
      this.leading,
      this.trailing,
      this.leadingWidth,
      this.backgroundColor,
    });

    @override
    Widget build(BuildContext context) {
      final typo = context.typography;
      final colors = context.colors;
      final contentColor = colors.title;

    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 8,
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: false,

        title: title != null
            ? Text(title!, style: typo.title.small.copyWith(color: contentColor))
            : null,

        leading: leading != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: leading!,
              )
            : null,

        actions: [
          if (trailing != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: trailing!,
            ),
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
      return GestureDetector(
        onTap: onTap,
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

      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text(date, style: typo.label.small.copyWith(color: contentColor)),
              SvgPicture.asset(AppAssets.icNormalArrowDown, width: 20, height: 20),
            ],
          ),
        ),
      );
    }
  }
