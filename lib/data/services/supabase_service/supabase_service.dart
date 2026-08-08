import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // _client = private
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseService();

  Future<List<Map<String, dynamic>>> getAllGear() async {
    final response = await _client.from('gear').select();

    return response;
  }

  Stream<List<Map<String, dynamic>>> getAllGearStream(){
    return _client
      .from('gear')
      .stream(primaryKey: ['id']);
  }

  Future<void> addGear(Map<String, dynamic> gearData) async {
    final response = await _client.from('gear').insert(gearData);

    return response;
  }
}
