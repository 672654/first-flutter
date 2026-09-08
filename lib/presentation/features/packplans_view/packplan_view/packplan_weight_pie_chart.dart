import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/domain/models/packplan_item.dart';

/// A deterministic color per [GearType] so the pie chart's colors stay
/// consistent across rebuilds and sessions.
const Map<GearType, Color> _gearTypeColors = {
  GearType.pack: Colors.brown,
  GearType.shelter: Colors.green,
  GearType.sleeping: Colors.indigo,
  GearType.cooking: Colors.orange,
  GearType.nutrition: Colors.amber,
  GearType.clothing: Colors.pink,
  GearType.tech: Colors.blueGrey,
  GearType.packraft: Colors.cyan,
  GearType.hunting: Colors.deepOrange,
  GearType.fishing: Colors.teal,
  GearType.other: Colors.grey,
};

/// Shows a pie chart with a legend, visualizing how the total weight of a
/// packplan is distributed across the different [GearType]s.
class PackplanWeightPieChart extends StatelessWidget {
  final List<PackplanItem> gearList;

  const PackplanWeightPieChart({super.key, required this.gearList});

  Map<GearType, double> _weightByType() {
    final Map<GearType, double> result = {};
    for (final item in gearList) {
      final weight = item.gear.grams * item.quantity;
      result.update(item.gear.type, (value) => value + weight, ifAbsent: () => weight.toDouble());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (gearList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('Legg til utstyr for å se vektfordeling')),
      );
    }

    final weightByType = _weightByType();
    final totalWeight = weightByType.values.fold<double>(0, (sum, w) => sum + w);
    // Sort by type declaration order (same convention used elsewhere in the app).
    final entries = GearType.values
        .where((t) => weightByType.containsKey(t))
        .map((t) => MapEntry(t, weightByType[t]!))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: entries.map((entry) {
                final percentage = totalWeight == 0 ? 0 : (entry.value / totalWeight) * 100;
                return PieChartSectionData(
                  color: _gearTypeColors[entry.key] ?? Colors.grey,
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: entries.map((entry) {
            final label = entry.key.toString().split('.').last;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _gearTypeColors[entry.key] ?? Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text('$label (${entry.value.toStringAsFixed(0)} g)'),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
