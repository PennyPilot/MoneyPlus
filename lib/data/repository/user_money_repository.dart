import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/model/balance_status.dart';
import 'package:moneyplus/domain/repository/model/currency_breakdown.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/domain/service/user_money_service.dart';

class UserRepositoryImpl implements UserMoneyRepository {
  final UserMoneyService service;

  UserRepositoryImpl({required this.service});

  @override
  Future<BalanceStatus> getBalanceStatus({
    required int month,
    required int year,
  }) async {
    _validateMonth(month);
    final response = await service.getBalanceStatusResponse(
      month: month,
      year: year,
    );

    final Map<String, dynamic> data;
    if (response is List) {
      data = response.isNotEmpty ? response.first as Map<String, dynamic> : {};
    } else {
      data = response as Map<String, dynamic>? ?? {};
    }

    return BalanceStatus.fromJson(data);
  }

  @override
  Future<List<CurrencyBreakdown>> getCurrencyBreakdown({
    required int month,
    required int year,
  }) async {
    _validateMonth(month);
    final response = await service.getCurrencyBreakdownResponse(
      month: month,
      year: year,
    );
    
    if (response is! List) return List.empty();

    return response.map((row) => CurrencyBreakdown.fromJson(row as Map<String, dynamic>)).toList();
  }

  @override
  Future<Currency> getCurrency() {
    return service.getCurrency();
  }

  @override
  Future<double> getSalary() {
    return service.getSalary();
  }

  @override
  Future<int> getSalaryDay() {
    return service.getSalaryDay();
  }

  @override
  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  }) {
    return service.updateSalarySettings(salary: salary, salaryDay: salaryDay);
  }

  void _validateMonth(int month){
    if(month < 1 || month > 12){
      throw Exception('Month value: "$month" is not valid, Month must be between 1 and 12');
    }
  }
}
