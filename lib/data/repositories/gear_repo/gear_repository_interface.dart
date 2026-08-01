import 'package:flutter_supabase_pack/domain/models/gear.dart';

/// Kontrakten Cubit/ViewModel avhenger av. Merk: eksponerer KUN
/// domain-modellen Gear, aldri GearDto - resten av appen skal ikke
/// vite at Supabase/DTO-representasjonen finnes i det hele tatt.
abstract class GearRepository {
  Future<List<Gear>> getAllGear();
  Future<Gear?> getGearById(int id);
  Future<void> addGear(Gear gear);
  Future<void> updateGear(Gear gear);
  Future<void> deleteGear(int id);
}
