

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_state.dart';

class PackPlanCubit extends Cubit<PackPlanState> {
  final PacklistRepositoryInterface _packlistRepository;

  PackPlanCubit(this._packlistRepository) : super(const PackPlanState());

  void loadPackPlanById(int id) async {
    emit(state.copyWith(status: PackplanStatus.loading));
    final loadedPackPlan = await _packlistRepository.getPackplanById(id);
    if (loadedPackPlan != null) {
      emit(state.copyWith(
        id: loadedPackPlan.id,
        name: loadedPackPlan.name,
        description: loadedPackPlan.description,
        gearList: loadedPackPlan.gearList ?? [],
        totalWeight: _calculateTotalWeight(loadedPackPlan.gearList ?? []),
        isEditing: true,
        status: PackplanStatus.loaded,
      ));
    } else {
      emit(state.copyWith(status: PackplanStatus.error, errorMessage: "Fant ikke packplan"));
    }
  }

  // Navn og beskrivelse holdes lokalt i UI (TextEditingController) og
  // sendes kun til Cubit ved lagring. Å emitte ny state for hvert
  // tastetrykk tvinger frem en full rebuild av skjemaet, noe som
  // forstyrrer tastaturets IME/komponering (spesielt med æøå og
  // autofullføring) og gir "bokstavene kommer baklengs"-oppførsel.

  void addGear(PackplanItem item) {
    final updated = List<PackplanItem>.from(state.gearList)..add(item);
    emit(state.copyWith(
      gearList: updated,
      totalWeight: _calculateTotalWeight(updated),
    ));
  }

  void addMultiple(List<PackplanItem> items) {
    final updated = List<PackplanItem>.from(state.gearList)..addAll(items);
    emit(state.copyWith(
      gearList: updated,
      totalWeight: _calculateTotalWeight(updated),
    ));
  }

  void removeGear(PackplanItem item) {
    final updated = List<PackplanItem>.from(state.gearList)..remove(item);
    emit(state.copyWith(
      gearList: updated,
      totalWeight: _calculateTotalWeight(updated),
    ));
  }

  void incrementQuantity(PackplanItem item) {
    final updated = state.gearList.map((e) {
      if (e == item) {
        return PackplanItem(gear: e.gear, quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    emit(state.copyWith(
      gearList: updated,
      totalWeight: _calculateTotalWeight(updated),
    ));
  }

  void decrementQuantity(PackplanItem item) {
    final updated = state.gearList.map((e) {
      if (e == item && e.quantity > 1) {
        return PackplanItem(gear: e.gear, quantity: e.quantity - 1);
      }
      return e;
    }).toList();
    emit(state.copyWith(
      gearList: updated,
      totalWeight: _calculateTotalWeight(updated),
    ));
  }

  Future<void> savePackPlan({required String name, required String description}) async {
    emit(state.copyWith(status: PackplanStatus.loading));
    final packplan = Packplan(
      id: state.id,
      createdAt: DateTime.now(),
      description: description,
      name: name,
      gearList: state.gearList,
    );
    try {
      if (state.isEditing && state.id != null) {
        await _packlistRepository.updatePackplan(packplan);
      } else {
        await _packlistRepository.createPackplan(packplan);
      }
      emit(state.copyWith(status: PackplanStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PackplanStatus.error, errorMessage: e.toString()));
    }
  }

  double _calculateTotalWeight(List<PackplanItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.gear.grams * item.quantity));
  }

  // UI dialogs should live in the presentation layer (widgets) not in Cubit.
}