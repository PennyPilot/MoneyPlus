import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../../design_system/assets/app_assets.dart';

Widget personalInfoCard(
  BuildContext context, {
  required String? image,
  required String name,
  required String email,
}) {
  final colors = context.colors;
  final typography = context.typography;

  return Container(
    decoration: BoxDecoration(
      color: colors.surfaceLow,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        updateUserAvatar(context, image, name),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: typography.title.small.copyWith(
                  color: colors.title,
                ),
              ),
              Text(
                email,
                style: typography.label.small.copyWith(
                  color: colors.body,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle click
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.stroke),
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              AppAssets.icEdit,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget updateUserAvatar(BuildContext context, String? imageUrl, String fullName) {
  final colors = context.colors;
  final typography = context.typography;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(imageUrl, height: 52, width: 52, fit: BoxFit.cover),
    );
  } else {
    String initials = '';
    if (fullName.isNotEmpty) {
      final nameParts = fullName.trim().split(' ');
      if (nameParts.length >= 2) {
        initials = (nameParts[0][0] + nameParts[1][0]).toUpperCase();
      } else {
        initials = fullName[0].toUpperCase();
      }
    }
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: typography.title.large.copyWith(
          color: colors.title,
        ),
      ),
    );
  }
}
