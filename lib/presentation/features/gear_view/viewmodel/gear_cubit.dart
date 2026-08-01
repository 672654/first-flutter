
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state.dart';

class GearCubit extends Cubit<GearState> {
  final GearRepository _repo;

  GearCubit(this._repo) : super(const GearInitial());


  Future<void> loadAllGear() async {
    emit(const GearLoading());
    try {
      final gearList = await _repo.getAllGear();
      emit(GearLoaded(gearList));
    } catch (e) {
      emit(GearError(e.toString()));
    }
  }



}