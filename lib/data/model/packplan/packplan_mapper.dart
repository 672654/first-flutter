


import 'package:flutter_supabase_pack/data/model/gear_packlist/gear_packplan_mapper.dart';
import 'package:flutter_supabase_pack/data/model/packplan/packplan_dto.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';

extension PackplanDtoToDomainMapper on PackplanDto {
  Packplan toDomain() {
    return Packplan(
      id: id,
      createdAt: createdAt,
      description: description,
      name: name,
      gearList: gearList?.map((geardto) => geardto.toDomain()).toList(),
    );
  }
}

extension PackplanDomainToDtoMapper on Packplan {
  PackplanDto toDto() {
    return PackplanDto(
      id: id,
      createdAt: createdAt,
      description: description,
      name: name,
      gearList: gearList?.map((gear) => gear.toDto()).toList(),
    );
  }
}
