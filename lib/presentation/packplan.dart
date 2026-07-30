import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PackPlan extends StatefulWidget {
  const PackPlan({super.key});

  @override
  State<PackPlan> createState() => _PackPlanState();
}

class _PackPlanState extends State<PackPlan> {
  List<dynamic>? _packPlans;
  String totalGrams = "0";

  @override
  void initState() {
    super.initState();
    readPackPlans();
  }

  void readPackPlans() async {
    try {
      // Henter alle packlist-rader, sammen med koblingsraden
      // pakningsplan_utstyr og det nøstede gear-objektet.
      final response = await Supabase.instance.client
          .from('packList')
          .select('*, pakningsplan_utstyr(*, gear(*))');

      setState(() {
        _packPlans = response as List<dynamic>?;
        totalGrams = calculateTotalGrams();
      });
    } catch (error) {
      print('Error reading pack plans: $error');
    }
  }

  String calculateTotalGrams() {
    int total = 0;
    if (_packPlans != null) {
      for (var packPlan in _packPlans!) {
        final utsyrRows =
            (packPlan['pakningsplan_utstyr'] as List<dynamic>?) ?? [];
        for (var row in utsyrRows) {
          final gear = row['gear'] as Map<String, dynamic>?;
          if (gear != null && gear['grams'] != null) {
            total += gear['grams'] as int;
          }
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
        title: const Text('Pack Plans'),
      ),
      body: _packPlans == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _packPlans!.length,
              itemBuilder: (context, index) {
                final packPlan = _packPlans![index];

                // Liste over koblingsrader (pakningsplan_utstyr) for denne packlisten
                final utsyrRows =
                    (packPlan['pakningsplan_utstyr'] as List<dynamic>?) ?? [];

                return ExpansionTile(
                  title: Text(packPlan['name'] ?? ''),
                  subtitle: Text('Total: $totalGrams g'),
                  children: utsyrRows.map((row) {
                    final gear = row['gear'] as Map<String, dynamic>?;
                    if (gear == null) {
                      return const ListTile(title: Text('Ukjent utstyr'));
                    }
                    return ListTile(
                      title: Text(gear['name'] ?? ''),
                      subtitle: Text(gear['description'] ?? ''),
                      trailing: Text('${gear['grams']} g'),
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
