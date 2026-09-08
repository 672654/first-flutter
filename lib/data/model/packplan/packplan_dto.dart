
import 'package:flutter_supabase_pack/data/model/gear_packlist/gear_packplan_dto.dart';

class PackplanDto {

  final int? id;
  final DateTime? createdAt;
  final String? description;
  final String? name;
  final List<GearPackplanDto>? gearList;

  PackplanDto({
    this.id,
    this.createdAt,
    this.description,
    this.name,
    this.gearList,
  });

  factory PackplanDto.fromJson(Map<String, dynamic> json) {
    final list = json['gear_packplan'] as List<dynamic>?;
    return PackplanDto(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at']),
      description: json['description'],
      name: json['name'],
      gearList: list?.map((item) => GearPackplanDto.fromJson(item)).toList(),
    );
  }

  /// JSON for inserting/updating the `packplan` row itself.
  /// Supabase/Postgrest does not support nested inserts into relation
  /// tables via this shape, so `gear_packplan` is intentionally excluded.
  /// Gear items are persisted separately via the `gear_packplan` table.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'created_at': createdAt?.toIso8601String(),
      'description': description,
      'name': name,
    };
    if (id != null) json['id'] = id;
    return json;
  }

}