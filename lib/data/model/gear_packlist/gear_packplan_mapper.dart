

import 'package:flutter_supabase_pack/data/model/gear/gear_mapper.dart';
import 'package:flutter_supabase_pack/data/model/gear_packlist/gear_packplan_dto.dart';
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';

extension GearDtoToPackplanMapper on GearPackplanDto {
  PackplanItem toDomain() {
    return PackplanItem(
      quantity: quantity,
      gear: gearDto.toDomain(),
    );
  }
}

extension GearPackplanToDtoMapper on PackplanItem {
  GearPackplanDto toDto() {
    return GearPackplanDto(
      quantity: quantity,
      gearDto: gear.toDto(),
    );
  }
}
