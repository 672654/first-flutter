
import 'package:flutter_supabase_pack/domain/models/gear.dart';

class Packlist {
  final int? id;
  final DateTime? createdAt;
  final String? description;
  final String? name;
  final List<Gear>? gearList;

  Packlist({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.name,
    required this.gearList,
  });
}