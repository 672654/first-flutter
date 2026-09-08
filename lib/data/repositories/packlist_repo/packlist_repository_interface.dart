

import 'package:flutter_supabase_pack/domain/models/packplan.dart';

abstract class PacklistRepositoryInterface {
  Future<List<Packplan>> getAllPackplans();
  Stream<List<Packplan>> streamAllPackplans();
  Future<Packplan?> getPackplanById(int id);
  Future<Packplan?> createPackplan(Packplan packplan);
  Future<void> updatePackplan(Packplan packplan);
  Future<void> deletePackplan(int id);
}