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
      highlightColor: Theme.of(context).primaryColor.withAlpha(20),
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
                    children: [
                      Text(title, style: titleTextStyle),
                      SizedBox(height: 2),
                      Text(subtitle, style: subtitleTextStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
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
