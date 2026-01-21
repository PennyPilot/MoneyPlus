import 'package:flutter/material.dart';

class CurrencyList extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  const CurrencyList({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.contentPadding,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Row(
            children: [
              leading ?? Container(),
              Expanded(
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(title, style: titleTextStyle),
                      Text(subtitle, style: subtitleTextStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
          PositionedDirectional(
            end: 0,
            top: 0,
            child: Padding(
              padding: contentPadding,
              child: trailing,
            ),
          ),
        ],
      ),
    );
  }
}
