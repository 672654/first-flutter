
import 'package:flutter_supabase_pack/data/model/packplan/packplan_dto.dart';
import 'package:flutter_supabase_pack/data/model/packplan/packplan_mapper.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service_packplan.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';

class SupabasePacklistRepositoryImpl implements PacklistRepositoryInterface {

  final SupabaseServicePackplan _supabaseService;

  SupabasePacklistRepositoryImpl(this._supabaseService);

  static const _packlistSelect = '*, pakningsplan_utstyr(*, gear(*))';


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
  Future<Packplan?> getPackplanById(int id) {
    // TODO: implement getPackplanById
    throw UnimplementedError();
  }

  @override
  Future<Packplan?> createPackplan(Packplan packplan) {
    // TODO: implement createPackplan
    throw UnimplementedError();


  }

  @override
  Future<void> updatePackplan(Packplan packplan) {
    // TODO: implement updatePackplan
    throw UnimplementedError();
  }

  @override
  Future<void> deletePackplan(int id) {
    // TODO: implement deletePackplan
    throw UnimplementedError();
  }
}