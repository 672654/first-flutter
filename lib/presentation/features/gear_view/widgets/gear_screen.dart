
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/service_locator.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_cubit.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state.dart';

class GearScreen extends StatelessWidget {
  const GearScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GearCubit(sl<GearRepository>())..loadAllGear(),
      child: const _GearView(),
    );
  }
}

class _GearView extends StatelessWidget {
  const _GearView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Gear'),
      ),
      body: BlocBuilder<GearCubit, GearState>(
        builder: (context, state) {
          if (state is GearLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GearLoaded) {
            return ListView.builder(
              itemCount: state.gearList.length,
              itemBuilder: (context, index) {
                final gear = state.gearList[index];
                return ExpansionTile(
                  title: Text(
                    gear.name, 
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(gear.brand),
                  trailing: Text('${gear.grams} g'),
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 32, right: 16, top: 4, bottom: 4),
                      title: Text('Type: ${gear.description}'),
                      subtitle: Text(gear.type.name),
                    ),
                  ],
                );
              },
            );
          } else if (state is GearError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}