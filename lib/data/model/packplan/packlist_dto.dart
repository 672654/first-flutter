
import 'package:flutter_supabase_pack/data/model/gear/gear_dto.dart';

class PacklistDto {

  final int? id;
  final DateTime? createdAt;
  final String? description;
  final String? name;
  final List<GearDto>? gearList;

  PacklistDto({
    this.id,
    this.createdAt,
    this.description,
    this.name,
    this.gearList,
  });

  factory PacklistDto.fromJson(Map<String, dynamic> json) {
    return PacklistDto(
      id: json['id'],
      createdAt: DateTime.tryParse(json['created_at']),
      description: json['description'],
      name: json['name'],
      gearList: (json['gearList'] as List<dynamic>?)
          ?.map((item) => GearDto.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'description': description,
      'name': name,
      'gearList': gearList?.map((item) => item.toJson()).toList(),
    };
  }

}