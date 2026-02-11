import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:svg_flutter/svg.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.add_custom_category, style: typography.title.small),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(AppAssets.iconCancel),
              ),
            ],
          ),
          Divider(color: colors.stroke, thickness: 1),
          const SizedBox(height: 12),

          MTextField(
            leading: Padding(
              padding: const EdgeInsetsGeometry.only(left: 16, right: 8),
              child: SvgPicture.asset(AppAssets.icCategory),
            ),
            hint: localizations.category_name,
            value: '',
            onChanged: (String value) {
              setState(() {
                _isButtonEnabled = value.trim().isNotEmpty;
              });
            },
          ),

          const SizedBox(height: 24),

          DefaultButton(
            text:localizations.add,
            isEnabled: _isButtonEnabled,
            onPressed: _isButtonEnabled
                ? () {
                    Navigator.pop(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
