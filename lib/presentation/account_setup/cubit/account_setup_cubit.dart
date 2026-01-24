import '../../../domain/repository/account_setup_repository.dart';
import 'account_setup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSetupCubit extends Cubit<AccountSetupState> {
  final AccountSetupRepository _accountSetupRepository;

  AccountSetupCubit(this._accountSetupRepository) : super(AccountSetupState());

  Future<void> fetchCurrencies() async {
    try{
      final currencies = await _accountSetupRepository.getCurrency();
      emit(state.copyWith(currencies : currencies,isLoading: false));
    }catch(e){
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }


}