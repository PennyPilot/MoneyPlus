import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../core/l10n/app_localizations.dart';
import '../assets/app_assets.dart';

class MSnackBar {
  final String message;
  final String title;
  final String leadingIcon;
  final Color shadowColor;

  MSnackBar._({
    required this.message,
    required this.title,
    required this.leadingIcon,
    required this.shadowColor,
  });

  factory MSnackBar.success({
    required String message,
    required String title,
  }) {
    return MSnackBar._(
      message: message,
      title: title,
      shadowColor: const Color(0xFF51AC46),
      leadingIcon: AppAssets.iconSuccess,
    );
  }

  factory MSnackBar.error({
    required String message,
    required String title,
  }) {
    return MSnackBar._(
      message: message,
      title: title,
      shadowColor: const Color(0xFFE54F40),
      leadingIcon: AppAssets.iconError,
    );
  }

  void showSnackBar({required BuildContext context}) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          elevation: 8,
          shadowColor: shadowColor.withValues(alpha: 0.08),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.surfaceLow,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  spreadRadius: 0,
                  color: shadowColor.withValues(alpha: 0.08),
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(leadingIcon, height: 32, width: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: context.typography.title.small.copyWith(
                                color: context.colors.title,
                              ),
                            ),
                            Text(
                              message,
                              style: context.typography.body.small.copyWith(
                                color: context.colors.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () => overlayEntry.remove(),
                          child: SvgPicture.asset(
                            AppAssets.iconCancel,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
