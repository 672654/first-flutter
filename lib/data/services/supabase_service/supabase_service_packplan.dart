

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServicePackplan {

  final SupabaseClient _client = Supabase.instance.client;

  SupabaseServicePackplan();

  Future<List<Map<String, dynamic>>> getAllPackplans() async {
    final response = await _client
      .from('packplan')
      .select('*, gear_packplan(quantity, gear(*))');

    return response;
  }

  Stream<List<Map<String, dynamic>>> getAllPackplanStream(){
    return _client
      .from('packplan')
      .select('*, gear_packplan(quantity, gear(*))')
      .asStream();
  }

  Future<void> addPackplan(Map<String, dynamic> packplanData) async {
    final response = await _client.from('packList').insert(packplanData);

    return response;
  }

  Future<void> updatePackplan(int id, Map<String, dynamic> packplanData) async {
    final response = await _client.from('packplan').update(packplanData).eq('id', id);

    return response;
  }

  Future<void> deletePackplan(int id) async {
    final response = await _client.from('packplan').delete().eq('id', id);
    return response;
  }

}