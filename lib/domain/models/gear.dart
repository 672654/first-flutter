import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';

/// Ren forretningsmodell for utstyr - ingen fromJson/toJson, ingen
/// kjennskap til Supabase eller databasekolonner. Dette er typen
/// ViewModel/Cubit og UI skal forholde seg til, ikke GearDto.
class Gear {
  final int id;
  final DateTime createdAt;
  final String brand;
  final String name;
  final String description;
  final int grams;
  final GearType type;

  const Gear({
    required this.id,
    required this.createdAt,
    required this.brand,
    required this.name,
    required this.description,
    required this.grams,
    required this.type,
  });
}
