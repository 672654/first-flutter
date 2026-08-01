

import 'package:flutter_supabase_pack/data/model/gear_dto.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGearRepositoryImpl implements GearRepository{

  final SupabaseService _supabaseService = SupabaseService();

  @override
  Future<List<Gear>> getAllGear() async {
    try{
      
      final gearList = await _supabaseService.getAllGear();
      return gearList.map((gearData) => Gear.fromJson(gearData)).toList();

    } on PostgrestException catch (e) {
      throw Exception('Failed to load gear from db: $e');
    } on Exception catch (a) {
      throw Exception('Unexpected error occurred while loading gear: $a');
    }
  }

  @override
  Future<Gear> getGearById(String id) async {
    // TODO: implementer getGearById - hent enkelt gear-rad fra Supabase og map til Gear.
    throw UnimplementedError('not implemented yet');
  }

  @override
  Future<void> addGear(Gear gear) async {
    throw UnimplementedError('not implemented yet');
  }

  @override
  Future<void> updateGear(Gear gear) async {
    throw UnimplementedError('not implemented yet');
  }

  @override
  Future<void> deleteGear(String id) async {
    throw UnimplementedError('not implemented yet');
  }

}