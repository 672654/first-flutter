
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state.dart';

class GearCubit extends Cubit<GearState> {
  final GearRepository _repo;

  GearCubit(this._repo) : super(const GearInitial());


  Future<void> loadAllGear() async {
    emit(const GearLoading());
    try {
      //Hent alle gear i en liste
      final gearList = await _repo.getAllGear();

      //opprett en map for å gruppere gear etter type
      final Map<String, List<Gear>> gearByType = {};

      //Gruppere gear etter type
      for(final gear in gearList) {
        final upperCaseFirstLetter = gear.type.name[0].toUpperCase() + gear.type.name.substring(1);
        gearByType.putIfAbsent(upperCaseFirstLetter, () => []).add(gear);
      }

      emit(GearLoaded(gearByType));

    } catch (e) {
      emit(GearError(e.toString()));
    }
  }



}