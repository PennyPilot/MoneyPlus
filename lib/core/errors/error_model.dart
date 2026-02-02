import 'package:flutter/material.dart';

class ErrorModel {
  final String message;
  final String? statusCode;
  final String? code;

  const ErrorModel(this.message, {this.statusCode, this.code});

  String localize(BuildContext context) => message;
}
