import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../assets/app_assets.dart';
import '../theme/money_extension_context.dart';

class SectionHeader extends StatelessWidget {
  final String? title;
  final Widget? leadingContent;
  final Widget? trailingContent;
  final VoidCallback? onClickTrailingContent;

  const SectionHeader({
    super.key,
    this.title,
    this.leadingContent,
    this.trailingContent,
    this.onClickTrailingContent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingContent ??
            Text(
              title ?? "",
              style: typography.title.small.copyWith(color: colors.title),
            ),
        GestureDetector(
          onTap: onClickTrailingContent,
          child:
              trailingContent ??
              SvgPicture.asset(AppAssets.icArrowRight, height: 20, width: 20),
        ),
      ],
    );
  }
}
