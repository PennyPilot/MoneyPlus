import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final String? leadingSvg;
  final VoidCallback? onLeadingPressed;

  final VoidCallback? onCalendarTap;
  final String? calendarDate;

  final String? trailingSvg;
  final VoidCallback? onTrailingPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingSvg,
    this.onLeadingPressed,
    this.onCalendarTap,
    this.calendarDate,
    this.trailingSvg,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leadingWidth: leadingSvg != null ? 56 : 172,
      automaticallyImplyLeading: false,

      title: title != null
          ? Text(
        title!,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )
          : null,

      leading: leadingSvg != null
          ? Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _CircleSvgIcon(
          assetPath: leadingSvg!,
          onTap: onLeadingPressed,
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _CalendarWidget(
          onTap: onCalendarTap ?? () {},
          date: calendarDate ?? "",
        ),
      ),

      actions: [
        if (trailingSvg != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: onTrailingPressed != null
                ? _CircleSvgIcon(
              assetPath: trailingSvg!,
              onTap: onTrailingPressed,
            )
                : SizedBox(
              width: 65,
              height: 26,
              child: SvgPicture.asset(
                trailingSvg!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CircleSvgIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const _CircleSvgIcon({required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.colors.surfaceHigh,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(assetPath, width: 20, height: 20),
        ),
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String date;

  const _CalendarWidget({required this.onTap, required this.date});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              "assets/svgs/arrow-down.svg",
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
