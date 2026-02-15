import 'package:flutter/material.dart';

import '../../../design_system/theme/money_extension_context.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: context.colors.primary,
            ),
          ),
        )
      ],
    );
  }

}