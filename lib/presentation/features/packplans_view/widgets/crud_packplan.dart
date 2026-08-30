
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/viewmodel/packplans_cubit.dart';

class CrudPackplan extends StatelessWidget {
  const CrudPackplan({super.key});

  @override
  Widget build(BuildContext context) {

    final packplansCubit = context.read<PackplansCubit>();
    final bool isNewPackplan = packplansCubit.state.selectedPackplanId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewPackplan ? 'Create Pack Plan' : 'Update Pack Plan',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Pack Plan Name'),
              onChanged: (value) {
                
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                
              },
            ),
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Save'),
            ),
          ],
        )
      ),
    );
  }
}