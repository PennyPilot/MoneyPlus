import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_typography.dart';

Widget personalInfoCard({
  required String? image,
  required String name,
  required String email,
}) {
  return Container(
    decoration: BoxDecoration(
      color: MoneyColors.light.surfaceLow,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: EdgeInsets.all(8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        updateUserAvatar(image, name),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: MoneyTypography.typography.title.small.copyWith(
                color: MoneyColors.light.title,
              ),
            ),
            Text(
              email,
              style: MoneyTypography.typography.label.small.copyWith(
                color: MoneyColors.light.body,
              ),
            ),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            // Handle click
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: MoneyColors.light.stroke),
            ),
            padding: EdgeInsets.all(8),
            child: SvgPicture.asset(AppAssets.icEdit, width: 16, height: 16),
          ),
        ),
      ],
    ),
  );
}

Widget updateUserAvatar(String? imageUrl, String fullName) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return Image.asset(imageUrl, height: 52, width: 52);
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
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: MoneyColors.light.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 11),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: MoneyTypography.typography.title.large.copyWith(
          color: MoneyColors.light.title,
        ),
      ),
    );
  }
}
