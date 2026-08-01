import 'package:flutter_supabase_pack/data/model/gear/gear_dto.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';

/// Konverterer data-laget sin DTO til domenelagets rene modell.
/// Dette er den ENESTE plassen i appen som skal vite at GearDto
/// finnes - resten av appen (Cubit, UI) bruker kun Gear.
extension GearDtoMapper on GearDto {
  Gear toDomain() {
    return Gear(
      id: id,
      createdAt: createdAt,
      brand: brand,
      name: name,
      description: description,
      grams: grams,
      type: type,
    );
  }
}

/// Motsatt vei: brukes av repository når data skal SKRIVES til
/// Supabase (addGear/updateGear tar imot Gear fra Cubit, men
/// SupabaseService/toJson() trenger en GearDto).
extension GearDomainMapper on Gear {
  GearDto toDto() {
    return GearDto(
      id: id,
      createdAt: createdAt,
      brand: brand,
      name: name,
      description: description,
      grams: grams,
      type: type,
    );
  }
}
