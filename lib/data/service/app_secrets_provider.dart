import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/constants/app_constants.dart';


class AppSecretsProvider {
  DotEnv? _dotenv;

  Future<DotEnv> getEnvVariables() async {
    if (_dotenv != null) return _dotenv!;
    _dotenv = DotEnv();
    await _dotenv!.load(fileName: AppConstants.secretsEnvFile);
    return _dotenv!;
  }
}
