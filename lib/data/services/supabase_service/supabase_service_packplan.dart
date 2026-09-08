

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

  Stream<List<Map<String, dynamic>>> getAllPackplanStream() {
    // `.stream()` gives us a real Supabase Realtime subscription on the
    // `packplan` table (fires on insert/update/delete), but it can only
    // return columns from that single table (no embedded relations).
    // So on every change event we re-fetch the fully joined data
    // (including gear_packplan + gear) and emit that instead.
    return _client
        .from('packplan')
        .stream(primaryKey: ['id'])
        .asyncMap((_) => getAllPackplans());
  }

  Future<Map<String, dynamic>?> getPackPlanById(int id) async {
    final response = await _client
      .from('packplan')
      .select('*, gear_packplan(quantity, gear(*))')
      .eq('id', id)
      .single();

    return response;
  }

  Future<Map<String, dynamic>> addPackplan(Map<String, dynamic> packplanData) async {
    final response = await _client.from('packplan').insert(packplanData).select().single();
    return Map<String, dynamic>.from(response);
  }

  Future<dynamic> updatePackplan(int id, Map<String, dynamic> packplanData) async {
    final response = await _client.from('packplan').update(packplanData).eq('id', id).select().single();
    return response;
  }

  Future<dynamic> deletePackplan(int id) async {
    final response = await _client.from('packplan').delete().eq('id', id);
    return response;
  }

  /// Removes all existing gear_packplan rows for a packplan.
  Future<void> deleteGearPackplanRows(int packplanId) async {
    await _client.from('gear_packplan').delete().eq('packplan_id', packplanId);
  }

  /// Inserts multiple rows into the gear_packplan join table.
  Future<void> addGearPackplanRows(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await _client.from('gear_packplan').insert(rows);
  }

}