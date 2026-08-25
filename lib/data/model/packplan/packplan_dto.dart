
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