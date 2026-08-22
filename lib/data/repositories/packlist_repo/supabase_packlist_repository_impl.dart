
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service_packplan.dart';
import 'package:flutter_supabase_pack/domain/models/packlist.dart';

class SupabasePacklistRepositoryImpl implements PacklistRepositoryInterface {

  final SupabaseServicePackplan _supabaseService;

  SupabasePacklistRepositoryImpl(this._supabaseService);

  static const _packlistSelect = '*, pakningsplan_utstyr(*, gear(*))';


  @override
  Future<List<Packlist>> getAllPacklists() {
    // TODO: implement getAllPacklists
    throw UnimplementedError();
  }

  @override
  Future<Packlist?> getPacklistById(int id) {
    // TODO: implement getPacklistById
    throw UnimplementedError();
  }

  @override
  Future<Packlist> createPacklist(Packlist packlist) {
    // TODO: implement createPacklist
    throw UnimplementedError();


  }

  @override
  Future<void> updatePacklist(Packlist packlist) {
    // TODO: implement updatePacklist
    throw UnimplementedError();
  }

  @override
  Future<void> deletePacklist(int id) {
    // TODO: implement deletePacklist
    throw UnimplementedError();
  }
}