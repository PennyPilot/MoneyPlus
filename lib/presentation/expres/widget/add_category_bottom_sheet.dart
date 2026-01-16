import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/component/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:svg_flutter/svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          top: 24,
          bottom: 24,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add custom category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: MoneyColors.light.body,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: MoneyColors.light.body,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Divider(thickness: 1, color: MoneyColors.light.stroke),
            const SizedBox(height: 12),

            MTextField(
              hint: 'Category name',
              value: _controller.text,
              onChanged: (value) => _controller.text = value,
              leading: Padding(
                padding: EdgeInsetsGeometry.only(
                  right: 8,
                  top: 14,
                  bottom: 14,
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_menu-square.svg',
                  width: 24,
                  height: 24,
                  color: MoneyColors.light.body,
                ),
              ),
            ),
            const SizedBox(height: 24),

            DefaultButton(
              text: 'Add',
              onPressed: () {
                if (_isButtonEnabled) {
                  String categoryName = _controller.text.trim();
                  Navigator.pop(context, categoryName);
                }
              },
              isEnabled: _isButtonEnabled,
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
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
