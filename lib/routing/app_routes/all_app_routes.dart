
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/widgets/gear_screen_2.dart';
import 'package:flutter_supabase_pack/presentation/features/home_view/widgets/home_screen.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/packplan_view/crud_packplan.dart';
import 'package:flutter_supabase_pack/presentation/features/packplans_view/widgets/packplans.dart';
import 'package:flutter_supabase_pack/presentation/features/trips_view/my_trips_screen.dart';
import 'package:go_router/go_router.dart';

class Destinations{
  Destinations._();

  static const String home = '/';

  static const String gear = '/gear';
  static const String gear2 = '/gear2';

  static const String packplan = '/packplan';
  static const String packplans = '/packplans';
  static const String crudPackplanSubPath = 'crud';
  static const String crudPackplan = '/packplans/crud';

  static const String myTrips = '/my-trips';

  static const String settings = '/settings';
}

/* legg til vanlige routes her som dekker hele skjermen. eksempel: Da kan man bare skrive crudTwo i router.dart.
final crudTwo = GoRoute(
  path: Destinations.crudPackplanTwo,
  builder: (context, state) => const CrudPackplan(),
);
*/

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

final gearBranch2 = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.gear2,
      builder: (context, state) => const GearScreen2(),
    ),
  ],
);

final packplanBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: Destinations.packplans,
      builder: (context, state) {
        return const Packplans();
      },
      routes: [
        GoRoute(
          path: Destinations.crudPackplanSubPath,
          builder: (context, state) {
            final idParam = state.uri.queryParameters['id'];
            final packplanId = idParam != null ? int.tryParse(idParam) : null;
            return CrudPackplan(packplanId: packplanId);
          },
        ),
      ],
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
