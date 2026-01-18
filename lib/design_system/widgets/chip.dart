import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class MChip extends StatelessWidget {
  final String? label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  const MChip({
    super.key,
    this.label,
    this.selected = false,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final horizontalPadding = selected ? 16.0 : 12.0;
    final contentColor = selected ? colors.onPrimary : colors.title;

    final hasLabel = label != null && label!.isNotEmpty;
    final hasTrailing = trailing != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.primaryVariant.withValues(alpha: 0.50),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.16),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasLabel)
              Text(
                label!,
                style: typography.label.medium.copyWith(color: contentColor),
              ),
            if (hasLabel && hasTrailing) const SizedBox(width: 8),
            if (hasTrailing) trailing!,
          ],
        ),
      ),
    );
  }
}
