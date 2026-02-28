import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
part 'salary_settings_state.dart';

class SalarySettingsCubit extends Cubit<SalarySettingsState> {
  SalarySettingsCubit({required this.userMoneyRepository}) : super(EditSalaryLoading());

  UserMoneyRepository userMoneyRepository;

  void getData() async {
    try{
      final salary = await userMoneyRepository.getSalary();
      final salaryDay = await userMoneyRepository.getSalaryDay();
      emit(
        EditSalaryLoaded(
          salary: salary.toString(),
          salaryDay: salaryDay.toString(),
          isButtonEnabled: false,
        ),
      );
    }catch(e){
        emit(EditSalaryError("Failed to get data"));
    }
    _setButtonVisibility();
  }

  void updateSalary(String salary) {
    if (state is EditSalaryLoaded) {
      var currentState = state as EditSalaryLoaded;
      emit(currentState.copyWith(salary: salary));
      _setButtonVisibility();
    }
  }

  void updateSalaryDay(String salaryDay) {
    if (state is EditSalaryLoaded) {
      var currentState = state as EditSalaryLoaded;
      emit(currentState.copyWith(salaryDay: salaryDay));
      _setButtonVisibility();
    }
  }

  Future<bool> saveChanges() async {
    try{
      if (state is EditSalaryLoaded) {
        var currentState = state as EditSalaryLoaded;
        await userMoneyRepository.updateSalary(double.parse(currentState.salary));
        await userMoneyRepository.updateSalaryDay(int.parse(currentState.salaryDay));
      }
      return true;
    }catch(e){
      return false;
    }

  }



  void _setButtonVisibility() {
    bool checkIfButtonShouldBeEnabled(EditSalaryLoaded state) {
      final salary = double.tryParse(state.salary);
      if (salary == null) return false;
      final salaryDay = int.tryParse(state.salaryDay);
      if (salaryDay == null) return false;
      if(salaryDay < 1 || salaryDay > 31) return false;
      if(salary < 0) return false;
      return true;
    }

    if (state is EditSalaryLoaded) {
      var currentState = state as EditSalaryLoaded;
      final shouldBeEnabled = checkIfButtonShouldBeEnabled(currentState);
      emit(currentState.copyWith(isButtonEnabled: shouldBeEnabled));
    }
  }
}
