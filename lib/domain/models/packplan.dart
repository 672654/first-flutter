
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';

class Packplan {
  final int? id;
  final DateTime? createdAt;
  final String? description;
  final String? name;
  final List<PackplanItem>? gearList;

  Packplan({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.name,
    required this.gearList,
  });
}