import 'package:flutter/material.dart';

import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';

import '../../../design_system/theme/money_extension_context.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppLoadingIndicator(),
        SizedBox(height: 16,),
      ],
    );
  }

}