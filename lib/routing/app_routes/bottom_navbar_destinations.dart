import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/home_view/widgets/home_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/widgets/packplan.dart';
import 'package:flutter_supabase_pack/presentation/features/trips_view/my_trips_screen.dart';
import 'package:flutter_supabase_pack/routing/app_routes/all_app_routes.dart';

class BottomNavRoutes{
  final String path;
  final String label;
  final IconData icon;
  final WidgetBuilder screenBuilder;

  const BottomNavRoutes({
    required this.path,
    required this.label,
    required this.icon,
    required this.screenBuilder,
  });

  static final List<BottomNavRoutes> mainBottomNavDestinations = [
    BottomNavRoutes(
      path: Destinations.home,
      label: "home",
      icon: Icons.home_rounded,
      screenBuilder: (context) => const HomeScreen(),
    ),
    BottomNavRoutes(
      path: Destinations.gear,
      label: "gear",
      icon: Icons.backpack_rounded,
      screenBuilder: (context) => const GearScreen(),
    ),
    BottomNavRoutes(
      path: Destinations.packplan,
      label: "packplans",
      icon: Icons.stay_primary_landscape,
      screenBuilder: (context) => const PackPlan(),
    ),
    BottomNavRoutes(
      path: Destinations.myTrips,
      label: "My Trips",
      icon: Icons.directions_walk_rounded,
      screenBuilder: (context) => const MyTripsScreen(),
    )
  ];
}