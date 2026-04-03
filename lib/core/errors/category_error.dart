import 'package:flutter/material.dart';
import 'package:moneyplus/core/constants/app_constants.dart';
import 'package:moneyplus/core/errors/error_model.dart';

import '../l10n/app_localizations.dart';

class CategoryAlreadyExistsError extends ErrorModel {
  CategoryAlreadyExistsError() : super(AppConstants.categoryExistsMessage);

  @override
  String localize(BuildContext context) {
    return AppLocalizations.of(context)!.category_already_exists;
  }
}
