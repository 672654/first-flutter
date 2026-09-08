
import 'package:flutter_supabase_pack/data/model/packplan/packplan_dto.dart';
import 'package:flutter_supabase_pack/data/model/packplan/packplan_mapper.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service_packplan.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';

class SupabasePacklistRepositoryImpl implements PacklistRepositoryInterface {

  final SupabaseServicePackplan _supabaseService;

  SupabasePacklistRepositoryImpl(this._supabaseService);

  @override
  Future<List<Packplan>> getAllPackplans() async {
    try {
      final response = await _supabaseService.getAllPackplans();
      
      final dtos = response.map((data) => PackplanDto.fromJson(data)).toList();
      return dtos.map((dto) => dto.toDomain()).toList();
      
    } catch (e) {
      // Handle error
      return [];
    }
  }

  @override
  Stream<List<Packplan>> streamAllPackplans() {
    return _supabaseService.getAllPackplanStream().map((data) {
      final dtos = data.map((item) => PackplanDto.fromJson(item)).toList();
      return dtos.map((dto) => dto.toDomain()).toList();
    }).handleError((error) {
      // Handle error
      final errorString = error.toString().toLowerCase();
      throw Exception('Error occurred while streaming packplans: $errorString');
    });
  }

  @override
  Future<Packplan?> getPackplanById(int id) async {
    final data = await _supabaseService.getPackPlanById(id);
    if (data == null) return null;
    return PackplanDto.fromJson(data).toDomain();
  }

  @override
  Future<Packplan?> createPackplan(Packplan packplan) async {
    final dto = packplan.toDto();
    final inserted = await _supabaseService.addPackplan(dto.toJson());
    final packplanId = inserted['id'] as int;

    final rows = dto.gearList?.map((g) => g.toJoinTableJson(packplanId)).toList() ?? [];
    await _supabaseService.addGearPackplanRows(rows);

    final full = await _supabaseService.getPackPlanById(packplanId);
    return full == null ? null : PackplanDto.fromJson(full).toDomain();
  }

  @override
  Future<void> updatePackplan(Packplan packplan) async {
    final dto = packplan.toDto();
    final id = packplan.id!;
    await _supabaseService.updatePackplan(id, dto.toJson());

    // Replace gear_packplan rows for this packplan.
    await _supabaseService.deleteGearPackplanRows(id);
    final rows = dto.gearList?.map((g) => g.toJoinTableJson(id)).toList() ?? [];
    await _supabaseService.addGearPackplanRows(rows);
  }

  @override
  Future<void> deletePackplan(int id) {
  return _supabaseService.deletePackplan(id);
  }
}