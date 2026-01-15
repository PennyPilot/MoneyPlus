import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

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

  // factory MButton.defult({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.primary,
  //     disabledBackgroundColor: MoneyColors.light.disabled,
  //     textColor: MoneyColors.light.onPrimary,
  //     disabledTextColor: MoneyColors.light.onPrimary.withOpacity(0.6),
  //     hasShadow: true,
  //     innerShadow: BoxShadow(
  //       color: const Color(0xFFFDECF0).withOpacity(0.5),
  //       offset: const Offset(0, 4),
  //       blurRadius: 12,
  //       spreadRadius: 0,
  //     ),
  //   );
  // }

  // factory MButton.variant({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.primary,
  //     disabledBackgroundColor: MoneyColors.light.disabled,
  //     textColor: MoneyColors.light.onPrimary,
  //     disabledTextColor: MoneyColors.light.onPrimary.withOpacity(0.6),
  //     cornerRadius: 100,
  //     height: 36,
  //     hasShadow: false,
  //   );
  // }

  // factory MButton.defultSecondary({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.surfaceLow,
  //     disabledBackgroundColor: MoneyColors.light.surfaceLow,
  //     textColor: MoneyColors.light.title,
  //     disabledTextColor: MoneyColors.light.title.withOpacity(0.4),
  //     borderColor: MoneyColors.light.stroke,
  //     borderWidth: 0.5,
  //     hasShadow: false,
  //   );
  // }

  // factory MButton.variantSecondary({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.surfaceLow,
  //     disabledBackgroundColor: MoneyColors.light.disabled,
  //     textColor: MoneyColors.light.title,
  //     disabledTextColor: MoneyColors.light.onPrimary.withOpacity(0.6),
  //     cornerRadius: 100,
  //     borderColor: MoneyColors.light.stroke,
  //     borderWidth: 0.5,
  //     height: 36,
  //     hasShadow: false,
  //   );
  // }

  // factory MButton.defultError({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.redVariant,
  //     disabledBackgroundColor: MoneyColors.light.disabled,
  //     textColor: MoneyColors.light.red,
  //     disabledTextColor: MoneyColors.light.onPrimary.withOpacity(0.6),
  //     borderColor: MoneyColors.light.stroke,
  //     borderWidth: 0.5,
  //     hasShadow: true,
  //     outerShadow: BoxShadow(
  //       color: const Color(0xFFDC143C).withOpacity(0.16),
  //       offset: const Offset(0, 4),
  //       blurRadius: 8,
  //       spreadRadius: 0,
  //     ),
  //   );
  // }

  // factory MButton.variantError({
  //   required String text,
  //   VoidCallback? onPressed,
  //   String? iconPath,
  //   bool isLoading = false,
  //   bool isEnabled = true,
  // }) {
  //   return MButton(
  //     text: text,
  //     onPressed: onPressed,
  //     iconPath: iconPath,
  //     isLoading: isLoading,
  //     isEnabled: isEnabled,
  //     backgroundColor: MoneyColors.light.redVariant,
  //     disabledBackgroundColor: MoneyColors.light.disabled,
  //     textColor: MoneyColors.light.red,
  //     disabledTextColor: MoneyColors.light.onPrimary.withOpacity(0.6),
  //     cornerRadius: 100,
  //     borderColor: MoneyColors.light.stroke,
  //     borderWidth: 0.5,
  //     height: 36,
  //     hasShadow: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = isEnabled && !isLoading;

    final Color finalBackgroundColor =
        isEnabled ? backgroundColor : disabledBackgroundColor;

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
            if (iconPath != null) ...[
              const SizedBox(width: 8),
              isLoading
                  ? SizedBox(
                      width: iconWidth,
                      height: iconHeight,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          finalIconColor,
                        ),
                      ),
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