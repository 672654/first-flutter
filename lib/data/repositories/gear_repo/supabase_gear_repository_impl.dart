

import 'package:flutter_supabase_pack/data/model/gear/gear_dto.dart';
import 'package:flutter_supabase_pack/data/model/gear/gear_mapper.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service_gear.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGearRepositoryImpl implements GearRepositoryInterface{

  final SupabaseServiceGear _supabaseService;

  SupabaseGearRepositoryImpl(this._supabaseService);

  @override
  Future<List<Gear>> getAllGear() async {
    try{

      final gearList = await _supabaseService.getAllGear();
      return gearList
          .map((gearData) => GearDto.fromJson(gearData).toDomain())
          .toList();

    } on PostgrestException catch (e) {
      throw Exception('Failed to load gear from db: $e');
    } on RealtimeSubscribeException catch (b){
      throw b;
    } on Exception catch (a) {
      throw Exception('Unexpected error occurred while loading gear: $a');
    } 
  }

  @override
  Stream<List<Gear>> streamAllGear() {
    return _supabaseService.getAllGearStream().map((gearList) {
      return gearList
          .map((gearData) => GearDto.fromJson(gearData).toDomain())
          .toList();
    }).handleError((error, stackTrace) {
      final errorString = error.toString().toLowerCase();
      if (error is RealtimeSubscribeException ||
          errorString.contains('websocket') ||
          errorString.contains('channel')) {
        throw error;
      }
      throw Exception('Error occurred while streaming gear: $error');
    });
  }

  @override
  Future<Gear?> getGearById(int id) async {
    // TODO: implementer getGearById - hent enkelt gear-rad fra Supabase og map til Gear.
    throw UnimplementedError('not implemented yet');
  }

  @override
  Future<void> addGear(Gear gear) async {
    
    try{
      final gearDto = gear.toDto();
      await _supabaseService.addGear(gearDto.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Failed to add gear to db: $e');
    } on Exception catch (a) {
      throw Exception('Unexpected error occurred while adding gear: $a');
    }

  }

  @override
  Future<void> updateGear(Gear gear) async {
    try{
      final gearDto = gear.toDto();
      await _supabaseService.updateGear(gearDto.id!, gearDto.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Failed to update gear in db: $e');
    } on Exception catch (a) {
      throw Exception('Unexpected error occurred while updating gear: $a');
    }
  }

  @override
  Future<void> deleteGear(int id) async {
    try{
      await _supabaseService.deleteGear(id);
    } catch (e) {
      throw Exception('Failed to delete gear from db: $e');
    }
  }

}