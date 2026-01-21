import 'dart:ui';

import 'package:flutter/material.dart';
extension BottomSheetExtension on BuildContext {
  Future<T?> showBlurBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: child,
      ),
    );
  }
}