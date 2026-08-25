import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/data/repositories/packlist_repo/supabase_packlist_repository_impl.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service_packplan.dart';
import 'package:flutter_supabase_pack/domain/models/packplan.dart';       // Importer din Packplan-modell
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';  // Importer din PackplanItem-modell
import 'package:supabase_flutter/supabase_flutter.dart';

class PackPlan extends StatefulWidget {
  const PackPlan({super.key});

  @override
  State<PackPlan> createState() => _PackPlanState();
}

class _PackPlanState extends State<PackPlan> {
  // Bruker den eksakte modellen din i stedet for dynamic
  List<Packplan>? _packPlans;
  String totalGrams = "0";

  @override
  void initState() {
    super.initState();
    getAllPackplans();
  }

  void getAllPackplans() async {
    try {
      final response = await SupabasePacklistRepositoryImpl(SupabaseServicePackplan()).getAllPackplans();

      setState(() {
        _packPlans = response;
        totalGrams = calculateTotalGrams();
      });
    } catch (error) {
      print('Error fetching pack plans: $error');
    }
  }

  String calculateTotalGrams() {
    int total = 0;
    if (_packPlans != null) {
      for (Packplan packPlan in _packPlans!) {
        final List<PackplanItem> items = packPlan.gearList ?? [];
        for (PackplanItem item in items) {
          final gear = item.gear;
          // Ganger vekten med antallet (quantity) for nøyaktig totalvekt
          total += (gear.grams) * item.quantity;
        }
      }
    }
    return total.toString();
  }

  void createPackPlan(String name) async {
    await Supabase.instance.client
        .from('packList')
        .insert({'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Pack Plans'),
      ),
      body: _packPlans == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _packPlans!.length,
              itemBuilder: (context, index) {
                final Packplan packPlan = _packPlans![index];

                final String planName = packPlan.name ?? 'Uten navn';
                final List<PackplanItem> items = packPlan.gearList ?? [];

                return ExpansionTile(
                  title: Text(planName),
                  subtitle: Text('Total: $totalGrams g'),
                  children: items.map((PackplanItem item) {
                    final gear = item.gear;
                    
                    final String gearName = gear.name;
                    final String gearDesc = gear.description;
                    final int gearGrams = gear.grams;
                    final int qty = item.quantity;

                    // Viser antall hvis det er mer enn 1 (f.eks: "Sokker x2")
                    final String displayName = qty > 1 ? '$gearName (x$qty)' : gearName;
                    // Regner ut totalen for akkurat dette utstyret basert på antall
                    final int itemTotalGrams = gearGrams * qty;

                    return ListTile(
                      title: Text(displayName),
                      subtitle: Text(gearDesc),
                      trailing: Text('$itemTotalGrams g'),
                    );
                  }).toList(),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createPackPlan("New Pack Plan");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
