import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import 'package:moneyplus/presentation/trasnaction_details/transactionDetailsComponent.dart';
import 'package:moneyplus/presentation/trasnaction_details/trasnaction_details_cubit.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/design_system/widgets/bottom_sheet.dart';
import 'package:moneyplus/design_system/widgets/buttons/secondary/defult_secondary_button.dart';
import '../../core/di/injection.dart';
import '../../design_system/widgets/buttons/error/default_error_button.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = context.localizations;

    return BlocProvider(
      create: (context) =>
          getIt<TransactionDetailsCubit>()
            ..getTransactionDetails(transactionId),
      child: Scaffold(
        extendBody: true,
        backgroundColor: colors.surface,
        appBar: CustomAppBar(
          backgroundColor: colors.surfaceLow,
          leading: AppBarCircleButton(
            assetPath: AppAssets.icArrowLeft,
            onTap: () {
              context.pop();
            },
          ),
          title: localizations.transaction_details,
          trailing: BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
            builder: (context, state) {
              if (state is TransactionDetailsLoaded) {
                return AppBarCircleButton(
                  assetPath: AppAssets.icShare,
                  onTap: () => context.read<TransactionDetailsCubit>().onClickShareButton(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
          builder: (context, state) {
            if (state is TransactionDetailsLoading) {
              return const AppLoadingIndicator();
            }
            if (state is TransactionDetailsError) {
              return Center(child: Text(state.errorMsg));
            }
            if (state is TransactionDetailsLoaded) {
              return SingleChildScrollView(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: TransactionDetailsComponent(
                          transaction: state.transactionDetails,
                        ),
                      ),
                      const SizedBox(height: 250),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
          builder: (context, state) {
            if (state is TransactionDetailsLoaded) {
              return SafeArea(
                top: false,
                child: _bottomBar(
                  context: context,
                  state: state,
                  onClickDelete: () {
                    _showDeleteConfirmation(context);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

Widget _bottomBar({
  required BuildContext context,
  required Function onClickDelete,
  required TransactionDetailsLoaded state,
}) {
  final localizations = context.localizations;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        DefaultButton(
          text: localizations.edit,
          onPressed: () async {
            await EditTransactionRoute(transactionId: state.transactionId).push(context);
            if (context.mounted) {
              context.read<TransactionDetailsCubit>().getTransactionDetails(state.transactionId);
            }
          },
        ),
        DefaultErrorButton(
          text: localizations.delete,
          onPressed: () {
            onClickDelete();
          },
        ),
      ],
    ),
  );
}

void _showDeleteConfirmation(BuildContext context) {
  final l10n = context.localizations;
  final cubit = context.read<TransactionDetailsCubit>();

  showCustomBottomSheet(
    context: context,
    title: l10n.delete_transaction,
    content: Text(
      l10n.delete_transaction_confirmation,
      style: context.typography.body.medium.copyWith(color: context.colors.body),
    ),
    actionButtons: [
      DefaultSecondaryButton(
        text: l10n.cancel,
        onPressed: () => Navigator.pop(context),
      ),
      DefaultErrorButton(
        text: l10n.delete,
        onPressed: () {
          Navigator.pop(context);
          cubit.deleteTransaction().then((success) {
            if (context.mounted) {
              if (success) {
                MSnackBar.success(
                  message: context.localizations.transaction_delete_success,
                  title: context.localizations.success,
                ).showSnackBar(context: context);
                context.pop(true);
              } else {
                MSnackBar.error(
                  message: context.localizations.transaction_delete_fail,
                  title: context.localizations.error,
                ).showSnackBar(context: context);
              }
            }
          });
        },
      ),
    ],
  );
}
