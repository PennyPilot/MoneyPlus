import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../assets/app_assets.dart';
import '../circular_loading_animation.dart';

class MoneyButton extends StatelessWidget {
  final double cornerRadius;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color disabledTextColor;
  final String text;
  final double fontSize;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final double borderWidth;
  final String? iconPath;
  final double height;
  final bool isLoading;
  final bool isEnabled;
  final Color? iconColor;
  final double iconWidth;
  final double iconHeight;
  final bool hasShadow;
  final BoxShadow? outerShadow;
  final BoxShadow? innerShadow;

  const MoneyButton({
    super.key,
    this.cornerRadius = 16,
    required this.backgroundColor,
    required this.disabledBackgroundColor,
    required this.textColor,
    required this.disabledTextColor,
    required this.text,
    this.fontSize = 16,
    this.onPressed,
    this.borderColor,
    this.borderWidth = 0.5,
    this.iconPath,
    this.height = 52,
    this.isLoading = false,
    this.isEnabled = true,
    this.iconColor,
    this.iconWidth = 20,
    this.iconHeight = 20,
    this.hasShadow = false,
    this.outerShadow,
    this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = isEnabled && !isLoading;

    final Color finalBackgroundColor = isEnabled
        ? backgroundColor
        : disabledBackgroundColor;

    final Color finalTextColor = isEnabled ? textColor : disabledTextColor;

    final Color finalIconColor = iconColor ?? finalTextColor;

    List<BoxShadow>? shadows;
    if (hasShadow && isEnabled) {
      shadows = [];
      if (outerShadow != null) shadows.add(outerShadow!);
      if (innerShadow != null) shadows.add(innerShadow!);
    }

    return GestureDetector(
      onTap: isInteractive ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: finalBackgroundColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          border: borderColor != null && borderColor != Colors.transparent
              ? Border.all(
                  color: isEnabled ? borderColor! : Colors.transparent,
                  width: borderWidth,
                )
              : null,
          boxShadow: shadows,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: finalTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (iconPath != null || isLoading) ...[
              const SizedBox(width: 8),
              isLoading
                  ? CircularLoadingAnimation(
                      iconPath: AppAssets.icLoading,
                      width: iconWidth,
                      height: iconHeight,
                      color: finalIconColor,
                    )
                  : SvgPicture.asset(
                      iconPath!,
                      width: iconWidth,
                      height: iconHeight,
                      colorFilter: ColorFilter.mode(
                        finalIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}
