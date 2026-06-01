import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';
import 'package:moneyplus/design_system/widgets/buttons/money_button.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widget/forget_password_button.dart';
import '../widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  final bool showResumeHint;
  const LoginScreen({super.key, this.showResumeHint = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().checkAccountSetupHint(widget.showResumeHint);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.surface,
          body: BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) =>
                _handleStateChanges(context, state, localizations),
            child: CustomScrollView(
              slivers: [
                _sliverAppBar(),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _LoginHeader(),
                          const SizedBox(height: 16),
                          const _LoginFields(),
                          const ForgetPasswordButton(),
                          const Spacer(),
                          const _LoginSubmitButton(),
                          const SizedBox(height: 8),
                          _buildOrWidget(colors, typography, localizations),
                          const SizedBox(height: 8),
                          const _SocialMediaButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.showAccountSetupHint != current.showAccountSetupHint,
          builder: (context, state) {
            if (!state.showAccountSetupHint) return const SizedBox.shrink();
            return _buildResumeHint(context, localizations);
          },
        ),
      ],
    );
  }

  Widget _buildResumeHint(
      BuildContext context, AppLocalizations localizations) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      child: Stack(
        children: [
          Positioned(
            bottom: 120,
            right: 16,
            left: 16,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.lightbulb_outline,
                              color: colors.primary, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            localizations.resume_setup_title,
                            style: typography.label.medium.copyWith(
                              color: colors.title,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<LoginCubit>().hideAccountSetupHint();
                          },
                          icon: Icon(Icons.close, color: colors.body, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.resume_setup_subtitle,
                      style: typography.body.small.copyWith(color: colors.body),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: MoneyButton(
                        onPressed: () {
                          context.read<LoginCubit>().hideAccountSetupHint();
                          const AccountSetupRoute().push(context);
                        },
                        text: localizations.resume_setup_button,
                        backgroundColor: colors.primary,
                        disabledBackgroundColor: colors.disabled,
                        textColor: colors.onPrimary,
                        disabledTextColor: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 245,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.background, fit: BoxFit.cover),
            Image.asset(AppAssets.logo, width: 99, height: 54),
          ],
        ),
      ),
    );
  }

  Widget _buildOrWidget(
    MoneyColors colors,
    MoneyTypography typography,
    AppLocalizations localizations,
  ) {
    final Expanded line = Expanded(
      child: Container(height: 1, color: colors.stroke.withValues(alpha: 0.1)),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            localizations.login_or_separator,
            style: typography.label.small.copyWith(color: colors.body),
          ),
        ),
        line,
      ],
    );
  }

  void _handleStateChanges(
    BuildContext context,
    LoginState state,
    AppLocalizations localizations,
  ) {
    if (state.status == LoginStatus.failure) {
      MSnackBar.error(
        message: state.error?.localize(context) ?? "Error",
        title: localizations.error,
      ).showSnackBar(context: context);
    } else if (state.status == LoginStatus.success) {
      MSnackBar.success(
        message: localizations.login_successfully,
        title: localizations.success,
      ).showSnackBar(context: context);

      const AccountSetupRoute().go(context);
    }
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.login_welcome_title,
          style: typography.headline.medium.copyWith(
            color: colors.title,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          localizations.login_welcome_subtitle,
          style: typography.body.small.copyWith(
            color: colors.body,
          ),
        ),
      ],
    );
  }
}

class _LoginFields extends StatelessWidget {
  const _LoginFields();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        return LoginForm(
          initialEmailValue: state.email,
          initialPasswordValue: state.password,
          onEmailChanged: (val) => cubit.onEmailChanged(val),
          onPasswordChanged: (val) => cubit.onPasswordChanged(val),
        );
      },
    );
  }
}

class _LoginSubmitButton extends StatelessWidget {
  const _LoginSubmitButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;
        return MoneyButton(
          onPressed: () => context.read<LoginCubit>().login(),
          isEnabled: state.isEnabled && !isLoading,
          innerShadow: const BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Color(0xDC143C29),
          ),
          outerShadow: const BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Color(0xFDECF080),
          ),
          backgroundColor: colors.primary,
          disabledBackgroundColor: colors.disabled,
          textColor: colors.onPrimary,
          disabledTextColor: colors.onPrimary,
          text: isLoading ? localizations.loading : localizations.login_button,
        );
      },
    );
  }
}

class _SocialMediaButtons extends StatelessWidget {
  const _SocialMediaButtons();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        MoneyButton(
          onPressed: () {
            context.read<LoginCubit>().signInWithGoogle();
          },
          backgroundColor: colors.surfaceLow,
          disabledBackgroundColor: Colors.red,
          borderWidth: 0.5,
          borderColor: colors.stroke.withValues(alpha: 0.1),
          textColor: colors.title,
          disabledTextColor: Colors.grey,
          text: localizations.login_google_button,
          iconPath: AppAssets.google,
        ),
        const SizedBox(height: 8),
        MoneyButton(
          onPressed: () {
            const CreateAccountRoute().push(context);
          },
          backgroundColor: colors.surfaceLow,
          disabledBackgroundColor: Colors.red,
          borderWidth: 0.5,
          borderColor: colors.stroke.withValues(alpha: 0.1),
          textColor: colors.title,
          disabledTextColor: Colors.grey,
          text: localizations.login_create_account,
        ),
      ],
    );
  }
}
