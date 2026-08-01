
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
  }
