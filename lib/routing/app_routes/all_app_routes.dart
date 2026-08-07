
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/home_view/widgets/home_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/widgets/packplan.dart';
import 'package:flutter_supabase_pack/presentation/features/trips_view/my_trips_screen.dart';
import 'package:go_router/go_router.dart';

class Destinations{
  Destinations._();

  static const String home = '/';
  static const String gear = '/gear';
  static const String packplan = '/packplan';
  static const String myTrips = '/my-trips';
  static const String settings = '/settings';
}

final homeBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);

final gearBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.gear,
      builder: (context, state) => const GearScreen(),
    ),
  ],
);

final packplanBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.packplan,
      builder: (context, state) => const PackPlan(),
    ),
  ],
);

final myTripsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.myTrips,
      builder: (context, state) => const MyTripsScreen(),
    ),
  ],
);
