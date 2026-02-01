import 'dart:ui';

import 'package:flutter/material.dart' hide BottomSheet;
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:svg_flutter/svg.dart';

import '../../../design_system/widgets/bottom_sheet.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  State<AddCategoryBottomSheet> createState() =>
      _AddCustomCategoryBottomSheetState();
}

class _AddCustomCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get _content {
    return MTextField(
      hint: 'Category name',
      value: _controller.text,
      onChanged: (value) => _controller.text = value,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8, top: 14, bottom: 14),
        child: SvgPicture.asset(
          AppAssets.icCategory,
          width: 24,
          height: 24,
          color: MoneyColors.light.body,
        ),
      ),
    );
  }

  Widget get _addButton {
    return DefaultButton(
      text: 'Add',
      onPressed: () {
        if (_isButtonEnabled) {
          String categoryName = _controller.text.trim();
          Navigator.pop(context, categoryName);
        }
      },
      isEnabled: _isButtonEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MBottomSheet(
      title: 'Add custom category',
      content: _content,
      actionButtons: [_addButton],
    );
  }
}

void showAddCategoryBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: const AddCategoryBottomSheet(),
    ),
  );
}