

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/utils/extensions/string_extensions.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state_2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GearCubit2 extends Cubit<GearStateSingle> with WidgetsBindingObserver {

  final GearRepositoryInterface _repo;
  StreamSubscription<List<Gear>>? _gearStreamSubscription;

  GearCubit2(this._repo) : super(const GearStateSingle()) {
    WidgetsBinding.instance.addObserver(this);
  }

void startListeningToGearStream() {
    // Bevarer eksisterende utstyr i UI under lasting ved å bruke copyWith
    emit(state.copyWith(
      status: GearStatus.loading
      ));

    _gearStreamSubscription?.cancel();

    _gearStreamSubscription = _repo.streamAllGear().listen((gearList) {
      final Map<String, List<Gear>> gearByType = {
        for (final type in GearType.values) type.name.capitalize(): []
      };
      
      for (final gear in gearList) {
        final type = gear.type ?? GearType.other;
        final upperCaseFirstLetter = type.name.capitalize();
        gearByType[upperCaseFirstLetter]?.add(gear);
      }
      
      emit(state.copyWith(
        status: GearStatus.loaded,
        gearByType: gearByType,
        errorMessage: null, // Nullstiller feilmelding ved suksess
      ));
    }, onError: (error) {
      final errorString = error.toString().toLowerCase();
      if (error is RealtimeSubscribeException ||
          errorString.contains('websocket') ||
          errorString.contains('channel')) {
        //Gjør ingen ting
        return;
      }
      emit(state.copyWith(
          status: GearStatus.error,
          errorMessage: error.toString(),
        ));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _gearStreamSubscription?.cancel();
      _gearStreamSubscription = null;
    } else if (state == AppLifecycleState.resumed) {
      if (!isClosed) {
        startListeningToGearStream();
      }
    }
  }

  Future<void> loadAllGear() async {
    emit(state.copyWith(status: GearStatus.loading));
    try {
      final gearList = await _repo.getAllGear();
      final Map<String, List<Gear>> gearByType = {};

      for (final gear in gearList) {
        final upperCaseFirstLetter = gear.type.name[0].toUpperCase() + gear.type.name.substring(1);
        gearByType.putIfAbsent(upperCaseFirstLetter, () => []).add(gear);
      }

      emit(state.copyWith(
        status: GearStatus.loaded,
        gearByType: gearByType,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GearStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addGear(Gear gearData) async {
    emit(state.copyWith(status: GearStatus.adding));
    try {
      await _repo.addGear(gearData);
      emit(state.copyWith(status: GearStatus.added));
    } catch (e) {
      emit(state.copyWith(
        status: GearStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateGear(Gear gearData) async {
    emit(state.copyWith(status: GearStatus.adding));
    try {
      await _repo.updateGear(gearData);
      emit(state.copyWith(status: GearStatus.added));
    } catch (e) {
      emit(state.copyWith(
        status: GearStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteGear(int gearId) async {
    emit(state.copyWith(status: GearStatus.deleting));
    try {
      await _repo.deleteGear(gearId);
      emit(state.copyWith(status: GearStatus.deleted));
    } catch (e) {
      emit(state.copyWith(
        status: GearStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _gearStreamSubscription?.cancel();
    return super.close();
  }

}