
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/core/service_locator.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/packlist_repository_interface.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_cubit.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan_state.dart';
import 'package:flutter_supabase_pack/routing/app_routes/all_app_routes.dart';
import 'package:go_router/go_router.dart';

class CrudPackplan extends StatelessWidget {

  final int? packplanId;


  const CrudPackplan({super.key, this.packplanId});
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PackPlanCubit(
          sl<PacklistRepositoryInterface>(),
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


class _PackplansView extends StatefulWidget {
  const _PackplansView();

  @override
  State<_PackplansView> createState() => _PackplansViewState();
}

class _PackplansViewState extends State<_PackplansView> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final state = context.read<PackPlanCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _descriptionController = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<List<PackplanItem>?> _showAddGearDialog(BuildContext context) async {
    final gearRepo = sl<GearRepositoryInterface>();
  // fetch once and reuse so FutureBuilder doesn't restart on every setState
  final gearFuture = gearRepo.getAllGear();

  String search = '';
    GearType? selectedType;
    final selectedIds = <int>{};
    final quantities = <int, int>{};

    return showDialog<List<PackplanItem>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return FutureBuilder<List<Gear>>(
            future: gearFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const AlertDialog(content: SizedBox(height: 120, child: Center(child: CircularProgressIndicator())));
              }

                final allGear = snap.data ?? [];
              // Build the list of types present in the gear list, but
              // ordered to match the declaration order in GearType itself
              // (not the order gear happens to appear in the fetched list).
                final presentTypes = allGear.map((g) => g.type).toSet();
                final types = GearType.values.where(presentTypes.contains).toList();
                for (final g in allGear) {
                  quantities.putIfAbsent(g.id!, () => 1);
                }
              selectedType ??= types.isNotEmpty ? types.first : null;

                // If searching, search across ALL gear regardless of the
                // selected type. Only apply the type filter when the
                // search box is empty.
                var filtered = search.isNotEmpty
                    ? allGear.where((g) => g.name.toLowerCase().contains(search.toLowerCase())).toList()
                    : allGear.where((g) => selectedType == null || g.type == selectedType).toList();

              return AlertDialog(
                title: const Text('Legg til utstyr'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 480,
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Søk...'),
                        onChanged: (v) => setState(() => search = v),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<GearType>(
                        value: selectedType,
                        isExpanded: true,
                        hint: const Text('Velg type'),
                        items: types.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(),
                        onChanged: (t) => setState(() => selectedType = t),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('Ingen utstyr funnet'))
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (c, i) {
                                  final g = filtered[i];
                                  final isSelected = selectedIds.contains(g.id);
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: InkWell(
                                      onTap: () => setState(
                                          () => isSelected ? selectedIds.remove(g.id) : selectedIds.add(g.id!)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: isSelected,
                                                  onChanged: (v) => setState(
                                                      () => v == true ? selectedIds.add(g.id!) : selectedIds.remove(g.id)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    g.name,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Text('${g.grams} g'),
                                              ],
                                            ),
                                            if (g.description.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 48, right: 8, bottom: 4),
                                                child: Text(
                                                  g.description,
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 40, bottom: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.remove),
                                                    onPressed: () => setState(() {
                                                      final current = quantities[g.id] ?? 1;
                                                      if (current > 1) quantities[g.id!] = current - 1;
                                                    }),
                                                  ),
                                                  Text('${quantities[g.id] ?? 1}'),
                                                  IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () => setState(() {
                                                      final current = quantities[g.id] ?? 1;
                                                      quantities[g.id!] = current + 1;
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Avbryt')),
                  ElevatedButton(
                    onPressed: selectedIds.isEmpty
                        ? null
                        : () {
                            final items = selectedIds.map((id) {
                              final gear = allGear.firstWhere((g) => g.id == id);
                              final qty = quantities[id] ?? 1;
                              return PackplanItem(quantity: qty, gear: gear);
                            }).toList();
                            Navigator.of(ctx).pop(items);
                          },
                    child: const Text('Legg til valgte'),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PackPlanCubit, PackPlanState>(
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit Pack Plan' : 'Create Pack Plan');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<PackPlanCubit, PackPlanState>(
          listener: (context, state) {
            if (state.status == PackplanStatus.loaded) {
              // Packplan finished loading from the backend (edit mode):
              // sync the text fields once, without resetting the cursor
              // on every keystroke.
              _nameController.text = state.name ?? '';
              _descriptionController.text = state.description ?? '';
            } else if (state.status == PackplanStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Packplan lagret')));
              context.go(Destinations.packplans);
            } else if (state.status == PackplanStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Feil')));
            }
          },
          child: BlocBuilder<PackPlanCubit, PackPlanState>(
            builder: (context, state) {
              final cubit = context.read<PackPlanCubit>();

              // Gruppér items etter type
              final Map<String, List<PackplanItem>> grouped = {};
              for (final item in state.gearList) {
                final type = item.gear.type.toString().split('.').last;
                grouped.putIfAbsent(type, () => []).add(item);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Row(
                      children: [
                        const Text("Details"),
                        const SizedBox(width: 16),
                        Text(
                          "Total: ${state.totalWeight.toStringAsFixed(0)} g",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Navn'),
                        onChanged: cubit.updateName,
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        onChanged: cubit.updateDescription,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: grouped.isEmpty
                        ? const Center(child: Text("No gear in this pack plan yet."))
                        : ListView(
                            children: grouped.entries.map((entry) {
                              final type = entry.key;
                              final items = entry.value;
                              return ExpansionTile(
                                title: Text(type),
                                children: items.map((item) {
                                  return ListTile(
                                    title: Text(item.gear.name),
                                    subtitle: Text(item.gear.description),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => cubit.decrementQuantity(item),
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => cubit.incrementQuantity(item),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${item.gear.grams * item.quantity} g'),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => cubit.removeGear(item),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add Gear"),
                        onPressed: () async {
                          final added = await _showAddGearDialog(context);
                          if (added != null && added.isNotEmpty) {
                            cubit.addMultiple(added);
                          }
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => cubit.savePackPlan(),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

