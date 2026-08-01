
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';

class GearDto {
  final int id;
  final DateTime createdAt;
  final String brand;
  final String name;
  final String description;
  final int grams;
  final GearType type;

  GearDto({
    required this.id,
    required this.createdAt,
    required this.brand,
    required this.name,
    required this.description,
    required this.grams,
    required this.type,
  });

  factory GearDto.fromJson(Map<String, dynamic> json) {
    return GearDto(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      brand: json['brand'],
      name: json['name'],
      description: json['description'],
      grams: json['grams'],
      type: GearType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GearType.other,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'brand': brand,
      'name': name,
      'description': description,
      'grams': grams,
      'type': type.toString().split('.').last,
    };
  }
}
