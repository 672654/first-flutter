import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/trips_view/my_trips_screen.dart';
import 'package:flutter_supabase_pack/presentation/packplan.dart';

/// Beskriver ÉN fane i bunnmenyen: metadata for UI (label/icon) OG
/// hvilken skjerm/rute den peker til (path + screenBuilder).
///
/// Dette er den ENESTE kilden til sannhet for navigasjon i appen:
/// - bottom_nav.dart bruker label/icon til å tegne NavigationBar.
/// - app_router.dart bruker path/screenBuilder til å generere routes.
/// Antall faner, rekkefølge og innhold kan derfor ALDRI komme ut av
/// synk, siden alt kommer fra denne ene listen.
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

  static final List<AppNavDestination> appNavDestinations = [
    AppNavDestination(
      path: "/home",
      label: "packplans",
      icon: Icons.home,
      screenBuilder: (context) => const PackPlan(),
    ),
    AppNavDestination(
      path: "/gear",
      label: "gear",
      icon: Icons.backpack_rounded,
      screenBuilder: (context) => const GearScreen(),
    ),
    AppNavDestination(
      path: "/my-trips",
      label: "My Trips",
      icon: Icons.directions_walk_rounded,
      screenBuilder: (context) => const MyTripsScreen(),
    )
  ];
}