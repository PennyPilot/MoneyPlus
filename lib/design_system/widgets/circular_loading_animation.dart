import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class CircularLoadingAnimation extends StatefulWidget {
  final String iconPath;
  final double width;
  final double height;
  final Color color;

  const CircularLoadingAnimation({
    super.key,
    required this.iconPath,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  _CircularLoadingAnimationState createState() => _CircularLoadingAnimationState();
}

class _CircularLoadingAnimationState extends State<CircularLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RotationTransition(
        turns: _controller,
        child: SvgPicture.asset(
          widget.iconPath,
          width: widget.width,
          height: widget.height,
          colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
