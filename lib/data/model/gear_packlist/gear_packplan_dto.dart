

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
      'gearDto': gearDto.toJson(),
    };
  }

}