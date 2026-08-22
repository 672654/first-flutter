import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/service_locator.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/core/widgets/crud_button.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_cubit_2.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state_2.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/add_gear_2.dart';

class GearScreen2 extends StatelessWidget {
  const GearScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Sørg for at Cubit-navnet matcher det du landet på (GearCubit eller GearCubit2)
      create: (context) =>
          GearCubit2(sl<GearRepository>())..startListeningToGearStream(),
      child: const _GearView(),
    );
  }
}

class _GearView extends StatelessWidget {
  const _GearView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SelectableText('My Gear')),
      // Vi bruker BlocConsumer for å både lytte etter engangshendelser (feil/suksess) og bygge UI
      body: BlocConsumer<GearCubit2, GearStateSingle>(
        listener: (context, state) {
          if (state.status == GearStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Feil: ${state.errorMessage}')),
            );
          }
          if (state.status == GearStatus.added) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Utstyr lagt til!')));
            Navigator.of(
              context,
            ).pop(); // Lukker bunnmenyen automatisk når det er lagt til
          }
        },
        builder: (context, state) {
          // Sjekker om vi laster og ikke har noe data fra før
          if (state.status == GearStatus.loading && state.gearByType.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hvis vi har en feil og ingen data i listen
          if (state.status == GearStatus.error && state.gearByType.isEmpty) {
            return Center(
              child: Text('Kunne ikke laste utstyr: ${state.errorMessage}'),
            );
          }

          // Hvis listen er tom (uavhengig av status)
          if (state.gearByType.isEmpty) {
            return const Center(
              child: Text('Ingen utstyr funnet. Legg til noe!'),
            );
          }

          final categories = state.gearByType.keys.toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, catIndex) {
              final currentType = categories[catIndex];
              final currentGearList = state.gearByType[currentType] ?? [];

              // Nivå 1: Hovedkategori
              return ExpansionTile(
                title: Text(
                  currentType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                childrenPadding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 4,
                  bottom: 4,
                ),
                children: currentGearList.map((gear) {
                  // Nivå 2: Gear
                  return ExpansionTile(
                    title: Text(gear.name),
                    subtitle: Text(gear.brand),
                    trailing: Text('${gear.grams} g'),
                    children: [
                      // Nivå 3: Detaljer
                      ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 32,
                          right: 16,
                          top: 4,
                          bottom: 4,
                        ),
                        title: Text(
                          gear.description.isNotEmpty
                              ? gear.description[0].toUpperCase() +
                                    gear.description.substring(1)
                              : '',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CrudButton(
                              type: CrudType.update,
                              action: () {
                                final gearCubit = context.read<GearCubit2>();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (modalContext) {
                                    return BlocProvider.value(
                                      value: gearCubit,
                                      child: AddGearModal2(
                                        gearToEdit: gear,
                                      ), // Sørg for at denne har const hvis mulig
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            
                            CrudButton(
                              type: CrudType.delete,
                              action: () {
                                final gearCubit = context.read<GearCubit2>();
                                gearCubit.deleteGear(gear.id ?? -1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final gearCubit = context.read<GearCubit2>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (modalContext) {
              return BlocProvider.value(
                value: gearCubit,
                child:
                    const AddGearModal2(), // Sørg for at denne har const hvis mulig
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
