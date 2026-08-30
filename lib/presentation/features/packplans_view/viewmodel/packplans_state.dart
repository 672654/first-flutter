
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';

enum PackplansStatus {
  initial,
  loading,
  loaded,
  error,
  adding,
  added,
}

class PackplansState extends Equatable {
  final PackplansStatus status;
  final String? errorMessage;
  final List<Packplan> packplans;
  final int? selectedPackplanId;

  const PackplansState({
    this.status = PackplansStatus.initial,
    this.errorMessage = "",
    this.packplans = const [],
    this.selectedPackplanId,
  });

  PackplansState copyWith({
    PackplansStatus? status,
    String? errorMessage,
    List<Packplan>? packplans,
    int? Function()? selectedPackplanId,
  }) {
    return PackplansState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      packplans: packplans ?? this.packplans,
      selectedPackplanId: selectedPackplanId != null ? selectedPackplanId() : this.selectedPackplanId,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, packplans, selectedPackplanId];
}


