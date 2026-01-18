import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const AppLogo({
    super.key,
    required this.assetPath,
    this.width = 65,
    this.height = 26,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(assetPath, fit: BoxFit.contain),
    );
  }
}
