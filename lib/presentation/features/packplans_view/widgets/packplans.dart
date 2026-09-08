

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/service_locator.dart';
import 'package:flutter_supabase_pack/core/utils/extensions/datetime_extensions.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/presentation/core/widgets/crud_button.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_cubit.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_state.dart';
import 'package:flutter_supabase_pack/routing/app_routes/all_app_routes.dart';
import 'package:go_router/go_router.dart';

class Packplans extends StatelessWidget {
  const Packplans({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackplansCubit(sl<PacklistRepositoryInterface>())..startListeningToPackplansStream(),
      child: const _PackplansView(),
    );
  }
}

class _PackplansView extends StatelessWidget {
  const _PackplansView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SelectableText('Packplans')),
      body: BlocConsumer<PackplansCubit, PackplansState>(
        listener: (context, state) {

          if (state.status == PackplansStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }

        },
        builder: (context, state) {
          if (state.status == PackplansStatus.loading && state.packplans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PackplansStatus.error && state.packplans.isEmpty) {
            return Center(
              child: Text('Could not load packplans: ${state.errorMessage}'),
            );
          }

          return ListView.builder(
            itemCount: state.packplans.length,
            itemBuilder: (context, index) {
              final packplan = state.packplans[index];
              return ExpansionTile(
                title: Text(packplan.name ?? ''),
                subtitle: Text(packplan.description ?? ''),
                trailing: Text('${packplan.totalWeight} g'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(packplan.description ?? ''),
                      subtitle: Text('Created: ${packplan.createdAt?.toNorwegianFormat() ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CrudButton(
                            type: CrudType.update,
                            customLabel: 'Open',
                            action: () {
                              context.go('${Destinations.crudPackplan}?id=${packplan.id}');
                            },
                          ),
                          const SizedBox(width: 8),
                          CrudButton(
                            type: CrudType.delete,
                            action: () {
                              if (packplan.id != null) {
                                context.read<PackplansCubit>().deletePackplan(packplan.id!);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        SnackBar snackBar = SnackBar(
                          content: Text('Packplan: ${packplan.name}, Total Weight: ${packplan.totalWeight} g'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: 
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.go(Destinations.crudPackplan);
            },
            mini: true,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}