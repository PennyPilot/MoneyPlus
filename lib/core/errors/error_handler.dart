import 'dart:developer';

import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/core/errors/error_supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class ErrorHandler {
//   static ErrorModel handleError(dynamic error) {
//     if (error is AuthException) {
//       log("errorrr in AuthException $error");
//       return _handleSupabaseException(error);
//     } else if (error is Exception) {
//       log("errorrr in Exception $error");
//       return ErrorModel(error.toString());
//     }
//     return defultException;
//   }
//
//   static ErrorModel _handleSupabaseException(AuthException error) {
//     final String message =
//     ErrorSupabaseConstants.isContainsErrorCode(error.code)
//         ? error.code!
//         : ErrorSupabaseConstants.defultSupabaseFailure;
//
//     return ErrorModel(
//       message,
//       statusCode: error.statusCode,
//       code: error.code,
//     );
//   }
//
//   static ErrorModel get defultSupabaseException => ErrorModel(
//     'Something went wrong in supabase. Please try again later.',
//     statusCode: '101',
//     code: 'Error in supabase',
//   );
//
//   static ErrorModel get defultException => ErrorModel(
//     'Something went wrong. Please try again later.',
//     statusCode: '102',
//     code: 'Error',
//   );
// }
