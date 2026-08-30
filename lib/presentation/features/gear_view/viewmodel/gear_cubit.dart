
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GearCubit extends Cubit<GearState> with WidgetsBindingObserver {
  final GearRepositoryInterface _repo;

  StreamSubscription<List<Gear>>? _gearStreamSubscription;

  GearCubit(this._repo) : super(const GearInitial()){
    WidgetsBinding.instance.addObserver(this);
  }

  void startListeningToGearStream() {
    //show loadingscreen
    emit(const GearLoading());

    //Kanseller gammel subscription før ny
    _gearStreamSubscription?.cancel();

    _gearStreamSubscription = _repo.streamAllGear().listen((gearList) {
      // Håndterer oppdateringer fra streamen
      final Map<String, List<Gear>> gearByType = {};
      for (final gear in gearList) {
        final upperCaseFirstLetter = gear.type.name[0].toUpperCase() + gear.type.name.substring(1);
        gearByType.putIfAbsent(upperCaseFirstLetter, () => []).add(gear);
      }
      emit(GearLoaded(gearByType));
    }, onError: (error) {
      // Håndterer feil som oppstår i streamen, start den på nytt. mulig kjent feil fra supabase.
      if (error is! RealtimeSubscribeException) {
        emit(GearError(error.toString()));
      }
      
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      // Appen går i bakgrunnen, kanseller streamen
      _gearStreamSubscription?.cancel();
      _gearStreamSubscription = null;
    } else if (state == AppLifecycleState.resumed) {
      // Appen kommer tilbake til forgrunnen, start streamen på nytt
      if (!isClosed) {
        startListeningToGearStream();
      }
    }
  }

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

  Future<void> addGear(Gear gearData) async {
    try {
      await _repo.addGear(gearData);
    } catch (e) {
      emit(GearError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _gearStreamSubscription?.cancel();
    return super.close();
  }

}