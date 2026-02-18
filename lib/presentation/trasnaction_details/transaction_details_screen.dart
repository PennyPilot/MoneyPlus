import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/presentation/trasnaction_details/transactionDetailsComponent.dart';
import 'package:moneyplus/presentation/trasnaction_details/pdf_service/share_pdf.dart';
import 'package:moneyplus/presentation/trasnaction_details/trasnaction_details_cubit.dart';
import 'package:svg_flutter/svg.dart';
import '../../core/di/injection.dart';
import '../../design_system/widgets/buttons/error/default_error_button.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<TransactionDetailsCubit>()
            ..getTransactionDetails(transactionId),
      child: BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
        builder: (context, state) {
          return switch (state) {
            TransactionDetailsLoading() => _loadingContent(),
            TransactionDetailsLoaded() => _loadedContent(context, state),
            TransactionDetailsError() => _errorContent(state.errorMsg),
          };
        },
      ),
    );
  }
}

Widget _loadingContent() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(color: MoneyColors.light.primary),
    ),
  );
}

Widget _errorContent(String errorMsg) {
  return Scaffold(body: Center(child: Text(errorMsg)));
}

Widget _loadedContent(BuildContext context, TransactionDetailsLoaded state) {
  final colors = context.colors;
  final cubit = context.read<TransactionDetailsCubit>();
  final localizations = context.localizations;
  return Scaffold(
    appBar: CustomAppBar(
      backgroundColor: colors.surfaceLow,
      leading: _circleIcon(
        iconPath: AppAssets.icArrowLeft,
        context: context,
        onClick: () {
          GoRouter.of(context).pop();
        },
      ),
      title: localizations.transaction_details,
      trailing: _circleIcon(
        iconPath: AppAssets.icShare,
        context: context,
        onClick: ()  {
          cubit.onClickShareButton(context);
        },
      ),
    ),
    body: Container(
      height: double.infinity,
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Center(
            child: TransactionDetailsComponent(
              transaction: state.transactionDetails,
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: _bottomBar(
      context: context,
      onClickDelete: () {
        cubit.deleteTransaction().then((success) {
          if (success) {
            MSnackBar.success(
              message: context.localizations.transaction_delete_success,
              title: "Success",
            ).showSnackBar(context: context);
          } else {
            MSnackBar.error(
              message: context.localizations.transaction_delete_fail,
              title: "Error",
            ).showSnackBar(context: context);
          }
        });
      },
    ),
  );
}

Widget _circleIcon({
  required String iconPath,
  required BuildContext context,
  Function? onClick,
}) {
  return GestureDetector(
    onTap: () {
      onClick?.call();
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MoneyColors.light.surface,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconPath,
        width: 20,
        height: 20,
        matchTextDirection: true,
      ),
    ),
  );
}

Widget _bottomBar({
  required BuildContext context,
  required Function onClickDelete,
}) {
  final localizations = context.localizations;
  return Container(
    width: double.infinity,
    color: MoneyColors.light.surface,
    child: SafeArea(
      top: false,
      right: false,
      left: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            DefaultButton(text: localizations.edit),
            DefaultErrorButton(
              text: localizations.delete,
              onPressed: () {
                onClickDelete();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
