import 'package:moneyplus/domain/entity/currency.dart';

import '../../domain/repository/account_repository.dart';
import '../../core/service/supabase_service.dart';

class AccountRepositoryImpl extends AccountRepository {
  final SupabaseService supabaseService;

  AccountRepositoryImpl({required this.supabaseService});

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