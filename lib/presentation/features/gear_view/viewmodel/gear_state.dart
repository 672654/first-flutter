

import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';

sealed class GearState extends Equatable {
  const GearState();

  @override
  List<Object?> get props => [];
}

class GearInitial extends GearState {
  const GearInitial();
}
class GearLoading extends GearState {
  const GearLoading();
}
class GearLoaded extends GearState {
  final List<Gear> gearList;
  const GearLoaded(this.gearList);

  @override
  List<Object?> get props => [gearList];
}

class GearError extends GearState {
  final String message;
  const GearError(this.message);

  @override
  List<Object?> get props => [message];
}