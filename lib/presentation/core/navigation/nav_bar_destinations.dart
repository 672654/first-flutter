import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/trips_view/my_trips_screen.dart';
import 'package:flutter_supabase_pack/presentation/packplan.dart';


class AppNavDestination {
  final String path;
  final String label;
  final IconData icon;
  final WidgetBuilder screenBuilder;

  const AppNavDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.screenBuilder,
  });

  static final List<AppNavDestination> mainBottomNavDestinations = [
    AppNavDestination(
      path: "/gear",
      label: "gear",
      icon: Icons.backpack_rounded,
      screenBuilder: (context) => const GearScreen(),
    ),
    AppNavDestination(
      path: "/packplans",
      label: "packplans",
      icon: Icons.stay_primary_landscape,
      screenBuilder: (context) => const PackPlan(),
    ),
    AppNavDestination(
      path: "/my-trips",
      label: "My Trips",
      icon: Icons.directions_walk_rounded,
      screenBuilder: (context) => const MyTripsScreen(),
    )
  ];
}