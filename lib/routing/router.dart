import 'package:flutter_supabase_pack/presentation/core/navigation/bottom_nav.dart';
import 'package:flutter_supabase_pack/routing/app_routes/all_app_routes.dart';
import 'package:flutter_supabase_pack/routing/app_routes/bottom_navbar_destinations.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouterOne = GoRouter(
  initialLocation: Destinations.home,

  // Sleng på denne for å få en topbar.
  /*
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(title: Text("DETTE ER EN GLOBAL TOPBAR")),
          body: child,
        );
      },
      */

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNav(
          navigationShell: navigationShell,
          destinations: BottomNavRoutes.mainBottomNavDestinations,
        );
      },
      //legg inn alle ruter i appen her. Disse finnes i /routing/app_routes/all_app_routes.dart
      branches: [homeBranch, gearBranch, packplanBranch, myTripsBranch],
    ),
  ],
);

///  ],
/// );
