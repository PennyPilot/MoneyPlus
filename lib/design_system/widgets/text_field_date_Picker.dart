import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:svg_flutter/svg.dart';

class TextFieldDatePicker extends StatefulWidget {
  final String? errorText;
  final String hint;
  final VoidCallback onError;
  final void Function(DateTime) onDateChange;

  const TextFieldDatePicker({
    super.key,
    this.errorText,
    required this.hint,
    required this.onError,
    required this.onDateChange,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<TextFieldDatePicker> {
  TextEditingController dateInput = TextEditingController();
  late FocusNode _focusNode;

  bool get _hasError => widget.errorText?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    dateInput.text = "";
    _focusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    dateInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final bool showBorder = _focusNode.hasFocus || _hasError;

    final Color borderColor = _hasError
        ? colors.red
        : _focusNode.hasFocus
        ? colors.primary
        : Colors.transparent;

    final double borderWidth = _hasError ? 0.5 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: showBorder ? borderWidth : 0,
            ),
            color: colors.surfaceLow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.icCalender, width: 24, height: 24),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: dateInput,
                  focusNode: _focusNode,
                  readOnly: true,
                  style: typography.body.medium.copyWith(color: colors.title),
                  decoration: InputDecoration(
                    hintText: dateInput.text != ""
                        ? dateInput.text
                        : widget.hint,
                    hintStyle: typography.label.medium.copyWith(
                      color: colors.body,
                    ),
                    border: InputBorder.none,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2200),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colors.primary,
                              onPrimary: colors.onPrimary,
                              onSurface: colors.title,
                              surface: colors.surfaceLow,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'dd/MM/yyyy',
                      ).format(pickedDate);

                      setState(() {
                        dateInput.text = formattedDate;
                      });
                      widget.onDateChange(pickedDate);
                    } else {
                      widget.onError();
                    }
                  },
                ),
              ),
              SvgPicture.asset(
                AppAssets.icArrowDownRound,
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),

        if (_hasError) ...[
          Padding(
            padding: const EdgeInsetsGeometry.directional(top: 4, start: 16),
            child: Text(
              widget.errorText!,
              style: typography.label.small.copyWith(color: colors.red),
            ),
          ),
        ],
      ],
    );
  }
}
