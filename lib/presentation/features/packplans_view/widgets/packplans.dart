

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/utils/extensions/datetime_extensions.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_cubit.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_state.dart';
import 'package:flutter_supabase_pack/routing/app_routes/all_app_routes.dart';
import 'package:go_router/go_router.dart';

class Packplans extends StatelessWidget {
  const Packplans({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PackplansView();
  }
}

class _PackplansView extends StatelessWidget {
  const _PackplansView({super.key});

  @override
  Widget build(BuildContext context) {
    final PackplansCubit packplansCubit = context.read<PackplansCubit>();

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
                trailing: Text('Created: ${packplan.createdAt?.toNorwegianFormat() ?? ''}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 95, 201, 205)),
                            ),
                            onPressed: () {
                              packplansCubit.selectPackplan(packplan.id!);
                              context.go(Destinations.crudPackplan, extra: packplansCubit);
                            },
                            child: Text('Open'),
                          ),
                        ],
                      ),
                      title: Text(packplan.name ?? ''),
                      subtitle: Text(packplan.description ?? ''),
                      trailing: Text(packplan.totalWeight.toString()+' g'),
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
              packplansCubit.selectPackplan(null);
              context.go(Destinations.crudPackplan, extra: packplansCubit);
            },
            mini: true,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}