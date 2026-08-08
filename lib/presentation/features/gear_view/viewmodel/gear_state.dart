

import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
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

  final Map<String, List<Gear>> gearByType;

  const GearLoaded(this.gearByType);

  @override
  List<Object?> get props => [gearByType];
}

class GearTypesLoaded extends GearState {
  final List<GearType> gearTypes;
  const GearTypesLoaded(this.gearTypes);

  @override
  List<Object?> get props => [gearTypes];
}

class GearError extends GearState {
  final String message;
  const GearError(this.message);

  @override
  List<Object?> get props => [message];
}
class GearAdding extends GearState {
  const GearAdding();
}
class GearAdded extends GearState {
  const GearAdded();
}

