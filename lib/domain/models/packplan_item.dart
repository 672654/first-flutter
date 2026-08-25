

import 'package:flutter_supabase_pack/domain/models/gear.dart';

class PackplanItem {
  final int quantity;
  final Gear gear;

  PackplanItem({
    required this.quantity,
    required this.gear,
  });
}