import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/widgets/text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.initialEmailValue,
    required this.initialPasswordValue,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  final String initialEmailValue;
  final String initialPasswordValue;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        MTextField(
          hint: localizations.login_email_hint,
          leading: Padding(
            padding: const EdgeInsetsGeometry.directional(end: 8),
            child: SvgPicture.asset(AppAssets.icEmail),
          ),
          onChanged: widget.onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          value: widget.initialEmailValue,
        ),
        const SizedBox(height: 12),
        MTextField(
          hint: localizations.login_password_hint,
          maxLines: 1,
          obscureText: !_isPasswordVisible,
          leading: Padding(
            padding: const EdgeInsetsGeometry.directional(end: 8),
            child: SvgPicture.asset(AppAssets.lock),
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: SvgPicture.asset(
                _isPasswordVisible ? AppAssets.eyeOpen : AppAssets.eyeClose,
              ),
            ),
          ),
          onChanged: widget.onPasswordChanged,
          value: widget.initialPasswordValue,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
