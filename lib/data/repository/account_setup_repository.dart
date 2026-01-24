import 'package:moneyplus/domain/entity/currency.dart';

import '../../domain/repository/account_setup_repository.dart';
import '../service/supabase_service.dart';

class AccountSetupRepositoryImpl extends AccountSetupRepository {
  final SupabaseService supabaseService;

  AccountSetupRepositoryImpl({required this.supabaseService});

  @override
  Future<List<Currency>> getCurrencies() async{
    try{
      final client = await supabaseService.getClient();
      final response = await client.from('currencies').select();
      return response.map((e) => Currency.fromJson(e)).toList();
    }catch(e){
      throw Exception('Failed to fetch currencies');
    }

  }

}