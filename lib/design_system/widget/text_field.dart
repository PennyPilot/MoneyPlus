import 'package:flutter/material.dart';

import '../theme/money_extension_context.dart';

class MoneyTextField extends StatefulWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final IconData? leadingIcon;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  const MoneyTextField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.leadingIcon,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
  });

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() => setState(() {}));
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final bool showBorder = _focusNode.hasFocus || _hasError;

    final Color borderColor = _hasError
        ? colors.red
        : showBorder
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.leadingIcon != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: 14,
                    right: 8,
                  ),
                  child: Icon(
                    widget.leadingIcon,
                    color: showBorder ? borderColor : colors.body,
                    size: 24,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  cursorColor: borderColor,
                  cursorWidth: 1,
                  style: typography.body.medium.copyWith(color: colors.title),
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: _focusNode.hasFocus ? null : widget.hint,
                    hintStyle: typography.label.medium.copyWith(
                      color: colors.body,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error text below the border
        if (_hasError) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
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
