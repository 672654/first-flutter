


import 'package:flutter_supabase_pack/data/model/gear/gear_mapper.dart';
import 'package:flutter_supabase_pack/data/model/packplan/packlist_dto.dart';
import 'package:flutter_supabase_pack/domain/models/packlist.dart';

extension PacklistMapper on PacklistDto {
  Packlist toDomain() {
    return Packlist(
      id: id,
      createdAt: createdAt,
      description: description,
      name: name,
      gearList: gearList?.map((geardto) => geardto.toDomain()).toList(),
    );
  }
}

extension PacklistDomainMapper on Packlist {
  PacklistDto toDto() {
    return PacklistDto(
      id: id,
      createdAt: createdAt,
      description: description,
      name: name,
      gearList: gearList?.map((gear) => gear.toDto()).toList(),
    );
  }
}
