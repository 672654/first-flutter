
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';

enum GearStatus { initial, loading, loaded, adding, added, error }

class GearStateSingle extends Equatable {
  final GearStatus status;
  final Map<String, List<Gear>> gearByType;
  final String? errorMessage;

  const GearStateSingle({
    this.status = GearStatus.initial,
    this.gearByType = const {},
    this.errorMessage = "",
  });

  GearStateSingle copyWith({
    GearStatus? status,
    Map<String, List<Gear>>? gearByType,
    String? errorMessage,
  }) {
    return GearStateSingle(
      status: status ?? this.status,
      gearByType: gearByType ?? this.gearByType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, gearByType, errorMessage];
}