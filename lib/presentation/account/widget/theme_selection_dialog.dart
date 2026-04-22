import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/app_prefernces_cubit.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../../design_system/assets/app_assets.dart';
import '../../../domain/repository/app_preferences_repository.dart';

class ThemeSelectionDialog extends StatefulWidget {
  final AppTheme currentTheme;

  const ThemeSelectionDialog({super.key, required this.currentTheme});

  @override
  State<ThemeSelectionDialog> createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  late AppTheme _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.localizations;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.icSun,
                width: 32,
                height: 32,
                matchTextDirection: true,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.appTheme,
              style: typography.label.large.copyWith(
                color: colors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildThemeOption(
              context,
              title: l10n.light,
              theme: AppTheme.light,
              icon: Icons.light_mode_outlined,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              context,
              title: l10n.dark,
              theme: AppTheme.dark,
              icon: Icons.dark_mode_outlined,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              context,
              title: l10n.system,
              theme: AppTheme.system,
              icon: Icons.settings_brightness_outlined,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: colors.stroke),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: typography.label.large.copyWith(
                        color: colors.title,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<AppPreferencesCubit>().setTheme(_selectedTheme);
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.select,
                      style: typography.label.large.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required AppTheme theme,
    required IconData icon,
  }) {
    final colors = context.colors;
    final typography = context.typography;
    final isSelected = _selectedTheme == theme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.stroke,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primary : colors.title,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: typography.label.large.copyWith(
                  color: isSelected ? colors.primary : colors.title,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? colors.primary : colors.stroke,
            ),
          ],
        ),
      ),
    );
  }
}
