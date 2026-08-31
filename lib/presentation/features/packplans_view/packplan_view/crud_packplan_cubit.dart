

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_state.dart';

class PackPlanCubit extends Cubit<PackPlanState> {

  final PacklistRepositoryInterface _packlistRepository;
  final GearRepositoryInterface _gearRepository;

  PackPlanCubit(this._packlistRepository, this._gearRepository) : super(const PackPlanState());

  
  void loadPackPlanById(int id){
    _packlistRepository.getPackplanById(id).then((loadedPackPlan) {
      if (loadedPackPlan != null) {
        emit(state.copyWith(packPlan: loadedPackPlan));
      }
    });
  }
}