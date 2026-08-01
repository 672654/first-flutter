import 'package:flutter_supabase_pack/presentation/core/navigation/nav_destination.dart';
import 'package:flutter_supabase_pack/presentation/core/widgets/bottom_nav.dart';
import 'package:go_router/go_router.dart';

/// Ruteroppsettet for hele appen.
///
/// Denne filen vet INGENTING om PackPlan/GearScreen direkte - den
/// genererer kun én StatefulShellBranch (= én fane) per element i
/// AppNavDestination.appNavDestinations. Legger du til en ny fane i
/// den listen, dukker den automatisk opp her også, i riktig rekkefølge.
final GoRouter appRouter = GoRouter(
  initialLocation: AppNavDestination.appNavDestinations.first.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          BottomNav(navigationShell: navigationShell),
      branches: AppNavDestination.appNavDestinations.map((destination) {
        return StatefulShellBranch(
          routes: [
            GoRoute(
              path: destination.path,
              builder: (context, state) => destination.screenBuilder(context),
            ),
          ],
        );
      }).toList(),
    ),
  ],
);