
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  // _client = private
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseService();

  Future<List<Map<String, dynamic>>> getAllGear() async {
    final response = await _client
        .from('gear')
        .select();
    
    return response;
    }

  Future<void> createGear(Map<String, dynamic> newGear) async {
    final response = await _client
        .from('gear')
        .insert(newGear);

    return response;
  }

  Future<void> updateGear(String id, Map<String, dynamic> updatedGear) async {
    final response = await _client
        .from('gear')
        .update(updatedGear)
        .eq('id', id);

    return response;
  }

  Future<void> deleteGear(String id) async {
    final response = await _client
        .from('gear')
        .delete()
        .eq('id', id);

    return response;
  }

}
