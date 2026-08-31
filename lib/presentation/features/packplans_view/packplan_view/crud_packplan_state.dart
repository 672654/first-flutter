import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';

enum PackplanStatus {
  initial,
  loading,
  success,
  error
}

class PackPlanState extends Equatable {
  final PackplanStatus status;
  final String? errorMessage;
  final Packplan? packPlan;
  final double totalWeight;
  final double totalWeightByType;

  const PackPlanState({
    this.status = PackplanStatus.initial,
    this.errorMessage = "",
    this.packPlan,
    this.totalWeight = 0.0,
    this.totalWeightByType = 0.0,
  });

  PackPlanState copyWith({
    PackplanStatus? status,
    String? errorMessage,
    Packplan? packPlan,
    double? totalWeight,
    double? totalWeightByType,
  }) {
    return PackPlanState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      packPlan: packPlan ?? this.packPlan,
      totalWeight: totalWeight ?? this.totalWeight,
      totalWeightByType: totalWeightByType ?? this.totalWeightByType,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, packPlan, totalWeight, totalWeightByType];
}