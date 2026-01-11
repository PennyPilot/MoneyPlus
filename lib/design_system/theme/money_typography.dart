import 'package:flutter/material.dart';

@immutable
class MoneyTypography extends ThemeExtension<MoneyTypography> {
  final SizedTextStyle headline;
  final SizedTextStyle title;
  final SizedTextStyle body;
  final SizedTextStyle label;

  const MoneyTypography({
    required this.headline,
    required this.title,
    required this.body,
    required this.label,
  });

  static const MoneyTypography typography = MoneyTypography(
    headline: SizedTextStyle(
      large: TextStyle(
        fontSize: 28,
        height: 42 / 28,
        fontWeight: FontWeight.w600,
      ),
      medium: TextStyle(
        fontSize: 24,
        height: 36 / 24,
        fontWeight: FontWeight.w600,
      ),
      small: TextStyle(
        fontSize: 20,
        height: 30 / 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    title: SizedTextStyle(
      large: TextStyle(
        fontSize: 20,
        height: 30 / 20,
        fontWeight: FontWeight.w500,
      ),
      medium: TextStyle(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w500,
      ),
      small: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
    ),

    body: SizedTextStyle(
      large: TextStyle(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
      ),
      medium: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      ),
      small: TextStyle(
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    label: SizedTextStyle(
      large: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
      medium: TextStyle(
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w500,
      ),
      small: TextStyle(
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w500,
      ),
      xSmall: TextStyle(
        fontSize: 10,
        height: 14 / 10,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  @override
  ThemeExtension<MoneyTypography> copyWith({
    SizedTextStyle? headline,
    SizedTextStyle? title,
    SizedTextStyle? body,
    SizedTextStyle? label,
  }) {
    return MoneyTypography(
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
    );
  }

  @override
  ThemeExtension<MoneyTypography> lerp(
    covariant ThemeExtension<MoneyTypography>? other,
    double t,
  ) {
    if (other is! MoneyTypography) {
      return this;
    }
    return MoneyTypography(
      headline: SizedTextStyle.lerp(headline, other.headline, t)!,
      title: SizedTextStyle.lerp(title, other.title, t)!,
      body: SizedTextStyle.lerp(body, other.body, t)!,
      label: SizedTextStyle.lerp(label, other.label, t)!,
    );
  }
}

@immutable
class SizedTextStyle {
  final TextStyle large;
  final TextStyle medium;
  final TextStyle small;
  final TextStyle? xSmall;

  const SizedTextStyle({
    required this.large,
    required this.medium,
    required this.small,
    this.xSmall,
  });

  static SizedTextStyle? lerp(SizedTextStyle? a, SizedTextStyle? b, double t) {
    if (a == null && b == null) return null;
    return SizedTextStyle(
      large: TextStyle.lerp(a?.large, b?.large, t)!,
      medium: TextStyle.lerp(a?.medium, b?.medium, t)!,
      small: TextStyle.lerp(a?.small, b?.small, t)!,
      xSmall: TextStyle.lerp(a?.xSmall, b?.xSmall, t),
    );
  }
}
