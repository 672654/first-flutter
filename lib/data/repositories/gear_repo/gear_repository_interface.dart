import 'package:flutter_supabase_pack/data/model/gear_dto.dart';

abstract class GearRepository {
  Future<List<Gear>> getAllGear();
  Future<Gear?> getGearById(String id);
  Future<void> addGear(Gear gear);
  Future<void> updateGear(Gear gear);
  Future<void> deleteGear(String id);
}
