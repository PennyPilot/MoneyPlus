import 'package:flutter/material.dart';

@immutable
class MoneyColors extends ThemeExtension<MoneyColors> {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color title;
  final Color body;
  final Color hint;
  final Color stroke;
  final Color surface;
  final Color surfaceLow;
  final Color surfaceHigh;
  final Color onPrimary;
  final Color onPrimaryBody;
  final Color onPrimaryStroke;
  final Color disabled;
  final Color red;
  final Color redVariant;
  final Color yellow;
  final Color yellowVariant;
  final Color green;
  final Color greenVariant;
  final Color defaultButtonShadow;

  const MoneyColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.title,
    required this.body,
    required this.hint,
    required this.stroke,
    required this.surface,
    required this.surfaceLow,
    required this.surfaceHigh,
    required this.onPrimary,
    required this.onPrimaryBody,
    required this.onPrimaryStroke,
    required this.disabled,
    required this.red,
    required this.redVariant,
    required this.yellow,
    required this.yellowVariant,
    required this.green,
    required this.greenVariant,
    required this.defaultButtonShadow,
  });

  static const MoneyColors light = MoneyColors(
    primary: Color(0xFFDC143C),
    primaryVariant: Color(0xFFFEF1F4),
    secondary: Color(0xFF0496AD),
    secondaryVariant: Color(0xFFEAF3F4),
    title: Color(0xDE1F1F1F),
    body: Color(0xA81F1F1F),
    hint: Color(0x661F1F1F),
    stroke: Color(0x1A1F1F1F),
    surface: Color(0xFFF8F8F8),
    surfaceLow: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFF2F2F2),
    onPrimary: Color(0xDEFFFFFF),
    onPrimaryBody: Color(0xA8FFFFFF),
    onPrimaryStroke: Color(0x29FFFFFF),
    disabled: Color(0xFFDDE1E4),
    red: Color(0xFFE54F40),
    redVariant: Color(0xFFFEEDEC),
    yellow: Color(0xFFF5A623),
    yellowVariant: Color(0xFFFEF3E1),
    green: Color(0xFF51AC46),
    greenVariant: Color(0xFFF1F9F1),
    defaultButtonShadow: Color(0x29DC143C),
  );
  static const MoneyColors dark = MoneyColors(
    primary: Color(0xFFFF4D6D),
    primaryVariant: Color(0xFF33030D),
    secondary: Color(0xFF00B4D8),
    secondaryVariant: Color(0xFF023E8A),
    title: Color(0xDEFFFFFF),
    body: Color(0xA8FFFFFF),
    hint: Color(0x66FFFFFF),
    stroke: Color(0x1AFFFFFF),
    surface: Color(0xFF1E1E1E),
    surfaceLow: Color(0xFF121212),
    surfaceHigh: Color(0xFF2C2C2C),
    onPrimary: Color(0xDE121212),
    onPrimaryBody: Color(0xA8121212),
    onPrimaryStroke: Color(0xA8121212),
    disabled: Color(0xFFDDE1E4),
    red: Color(0xFFFF6B6B),
    redVariant: Color(0xFF3D1212),
    yellow: Color(0xFFFFC107),
    yellowVariant: Color(0xFF3D2B00),
    green: Color(0xFF81C784),
    greenVariant: Color(0xFF0F2D11),
    defaultButtonShadow: Color(0x29DC143C),
  );


  @override
  ThemeExtension<MoneyColors> copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? title,
    Color? body,
    Color? hint,
    Color? stroke,
    Color? surface,
    Color? surfaceLow,
    Color? surfaceHigh,
    Color? onPrimary,
    Color? onPrimaryBody,
    Color? onPrimaryStroke,
    Color? disabled,
    Color? red,
    Color? redVariant,
    Color? yellow,
    Color? yellowVariant,
    Color? green,
    Color? greenVariant,
    Color? defaultButtonShadow,
  }) {
    return MoneyColors(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      title: title ?? this.title,
      body: body ?? this.body,
      hint: hint ?? this.hint,
      stroke: stroke ?? this.stroke,
      surface: surface ?? this.surface,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      onPrimary: onPrimary ?? this.onPrimary,
      onPrimaryBody: onPrimaryBody ?? this.onPrimaryBody,
      onPrimaryStroke: onPrimaryStroke ?? this.onPrimaryStroke,
      disabled: disabled ?? this.disabled,
      red: red ?? this.red,
      redVariant: redVariant ?? this.redVariant,
      yellow: yellow ?? this.yellow,
      yellowVariant: yellowVariant ?? this.yellowVariant,
      green: green ?? this.green,
      greenVariant: greenVariant ?? this.greenVariant,
      defaultButtonShadow: defaultButtonShadow ?? this.defaultButtonShadow,
    );
  }

  @override
  ThemeExtension<MoneyColors> lerp(
    covariant ThemeExtension<MoneyColors>? other,
    double t,
  ) {
    if (other is! MoneyColors) return this;
    return MoneyColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant: Color.lerp(
        secondaryVariant,
        other.secondaryVariant,
        t,
      )!,
      title: Color.lerp(title, other.title, t)!,
      body: Color.lerp(body, other.body, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onPrimaryBody: Color.lerp(onPrimaryBody, other.onPrimaryBody, t)!,
      onPrimaryStroke: Color.lerp(onPrimaryStroke, other.onPrimaryStroke, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      red: Color.lerp(red, other.red, t)!,
      redVariant: Color.lerp(redVariant, other.redVariant, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      yellowVariant: Color.lerp(yellowVariant, other.yellowVariant, t)!,
      green: Color.lerp(green, other.green, t)!,
      greenVariant: Color.lerp(greenVariant, other.greenVariant, t)!,
      defaultButtonShadow: Color.lerp(defaultButtonShadow, other.defaultButtonShadow, t)!,
    );
  }
}
