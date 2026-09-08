

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_state.dart';

class PackplansCubit extends Cubit<PackplansState> {

  final PacklistRepositoryInterface _repo;

  PackplansCubit(this._repo) : super(const PackplansState());

  void startListeningToPackplansStream() {
    emit(state.copyWith(status: PackplansStatus.loading));

    _repo.streamAllPackplans().listen((packplanList) {
      emit(state.copyWith(
        status: PackplansStatus.loaded,
        packplans: packplanList,
        errorMessage: null, // Nullstiller feilmelding ved suksess
      ));
    }, onError: (error) {
      emit(state.copyWith(
        status: PackplansStatus.error,
        errorMessage: error.toString(),
      ));
    });
  }

  void selectPackplan(int? id) {
    emit(state.copyWith(selectedPackplanId: () => id));
  }

  Future<void> deletePackplan(int id) async {
    try {
      await _repo.deletePackplan(id);
      // The realtime stream will emit an updated list automatically,
      // but we also optimistically remove it locally for instant feedback.
      final updated = state.packplans.where((p) => p.id != id).toList();
      emit(state.copyWith(packplans: updated, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: PackplansStatus.error, errorMessage: e.toString()));
    }
  }

}