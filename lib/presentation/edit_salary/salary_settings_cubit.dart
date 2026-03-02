import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
part 'salary_settings_state.dart';

class SalarySettingsCubit extends Cubit<SalarySettingsState> {
  SalarySettingsCubit({required this.userMoneyRepository}) : super(SalarySettingsLoading());

  UserMoneyRepository userMoneyRepository;

  void getData() async {
    try{
      final salary = await userMoneyRepository.getSalary();
      final salaryDay = await userMoneyRepository.getSalaryDay();
      emit(
        SalarySettingsLoaded(
          salary: salary.toString(),
          salaryDay: salaryDay.toString(),
          isSaveButtonEnabled: false,
        ),
      );
    }catch(e){
        emit(SalarySettingsError(failure: SalarySettingsFailure.loadFailed));
    }
    _setButtonVisibility();
  }

  void updateSalary(String salary) {
    if (state is SalarySettingsLoaded) {
      var currentState = state as SalarySettingsLoaded;
      emit(currentState.copyWith(salary: salary));
      _setButtonVisibility();
    }
  }

  void updateSalaryDay(String salaryDay) {
    if (state is SalarySettingsLoaded) {
      var currentState = state as SalarySettingsLoaded;
      emit(currentState.copyWith(salaryDay: salaryDay));
      _setButtonVisibility();
    }
  }

  Future<bool> saveChanges() async {
    try{
      if (state is SalarySettingsLoaded) {
        var currentState = state as SalarySettingsLoaded;
        await userMoneyRepository.updateSalarySettings(
          salary: double.parse(currentState.salary),
          salaryDay: int.parse(currentState.salaryDay),
        );
      }
      return true;
    }catch(e){
      return false;
    }

  }



  void _setButtonVisibility() {
    bool checkIfButtonShouldBeEnabled(SalarySettingsLoaded state) {
      final salary = double.tryParse(state.salary);
      if (salary == null) return false;
      final salaryDay = int.tryParse(state.salaryDay);
      if (salaryDay == null) return false;
      if(salaryDay < 1 || salaryDay > 31) return false;
      if(salary < 0) return false;
      return true;
    }

    if (state is SalarySettingsLoaded) {
      var currentState = state as SalarySettingsLoaded;
      final shouldBeEnabled = checkIfButtonShouldBeEnabled(currentState);
      emit(currentState.copyWith(isButtonEnabled: shouldBeEnabled));
    }
  }
}

enum SalarySettingsFailure {
  loadFailed,
}
