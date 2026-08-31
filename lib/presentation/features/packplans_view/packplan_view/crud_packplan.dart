
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/service_locator.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_cubit.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_state.dart';

class CrudPackplan extends StatelessWidget {

  final int? packplanId;


  const CrudPackplan({super.key, this.packplanId});
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PackPlanCubit(
          sl<PacklistRepositoryInterface>(),
          sl<GearRepositoryInterface>(),
        );
        if (packplanId != null) {
          cubit.loadPackPlanById(packplanId!);
        }
        return cubit;
      },
      child: const _PackplansView(),
    );
  }
}

  class _PackplansView extends StatelessWidget {
    const _PackplansView({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Pack Plan',
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           const ExpansionTile(
              title: Text("Pack Plan Details"),
            ),
            BlocBuilder<PackPlanCubit, PackPlanState>(
              builder: (context, state) {
                return TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    // Eksempel på å sende data til cubiten (forutsetter en metode i din Cubit)
                    // context.read<PackPlanCubit>().updateDescription(value);
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // 4. Bruk context.read for å trigge funksjoner (events/handlinger) uten å tegne om UI
                // context.read<PackPlanCubit>().savePackPlan();
              },
              child: const Text('Save'),
            ),
          ],
        )
      ),
    );
  }
}

