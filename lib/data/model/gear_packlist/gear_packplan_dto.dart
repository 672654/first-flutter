

import 'package:flutter_supabase_pack/data/model/gear/gear_dto.dart';

class GearPackplanDto {

  final int quantity;
  final GearDto gearDto;

  GearPackplanDto({
    required this.quantity,
    required this.gearDto,
  });

  factory GearPackplanDto.fromJson(Map<String, dynamic> json) {
    return GearPackplanDto(
      quantity: json['quantity'] as int? ?? 1,
      gearDto: GearDto.fromJson(json['gear'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      // Nest gear by id so Supabase can link to existing gear row when inserting nested records
      'gear': {
        'id': gearDto.id,
      },
    };
  }

  /// Flat JSON shape used to insert a row directly into the `gear_packplan`
  /// join table, which has columns `packplan_id`, `gear_id` and `quantity`.
  Map<String, dynamic> toJoinTableJson(int packplanId) {
    return {
      'packplan_id': packplanId,
      'gear_id': gearDto.id,
      'quantity': quantity,
    };
  }

}