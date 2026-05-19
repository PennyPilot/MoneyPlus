import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CategoryAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onBackPressed,
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.icArrowLeft,
                matchTextDirection: true,
                colorFilter: ColorFilter.mode(colors.title, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
      title: Text(title, style: typography.title.small),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
