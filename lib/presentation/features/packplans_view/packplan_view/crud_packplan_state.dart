import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';

enum PackplanStatus {
  initial,
  loading,
  loaded,
  success,
  error
}

class PackPlanState extends Equatable {
  final PackplanStatus status;
  final String? errorMessage;
  final int? id;
  final String? name;
  final String? description;
  final List<PackplanItem> gearList;
  final double totalWeight;
  final bool isEditing;

  const PackPlanState({
    this.status = PackplanStatus.initial,
    this.errorMessage = "",
    this.id,
    this.name = "",
    this.description = "",
    this.gearList = const [],
    this.totalWeight = 0.0,
    this.isEditing = false,
  });

  PackPlanState copyWith({
    PackplanStatus? status,
    String? errorMessage,
    int? id,
    String? name,
    String? description,
  List<PackplanItem>? gearList,
    double? totalWeight,
    bool? isEditing,
  }) {
    return PackPlanState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      gearList: gearList ?? this.gearList,
      totalWeight: totalWeight ?? this.totalWeight,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, id, name, description, gearList, totalWeight, isEditing];
}