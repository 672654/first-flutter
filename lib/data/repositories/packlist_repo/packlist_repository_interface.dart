

import 'package:flutter_supabase_pack/domain/models/packlist.dart';

abstract class PacklistRepositoryInterface {
  Future<List<Packlist>> getAllPacklists();
  Future<Packlist?> getPacklistById(int id);
  Future<void> createPacklist(Packlist packlist);
  Future<void> updatePacklist(Packlist packlist);
  Future<void> deletePacklist(int id);
}