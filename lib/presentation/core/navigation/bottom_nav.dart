import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/routing/app_routes/bottom_navbar_destinations.dart';
import 'package:go_router/go_router.dart';

/// Ren, gjenbrukbar UI-komponent for et navigasjonsskall med bunnmeny.
///
/// Vet INGENTING om AppNavDestination.appNavDestinations spesifikt -
/// den mottar listen med destinasjoner som en parameter, akkurat som
/// navigationShell. Dette gjør at samme BottomNav-widget kan brukes
/// med andre destinasjons-lister andre steder i appen (f.eks. en egen
/// bunnmeny for en admin-seksjon), og gjør widgeten enkel å teste
/// isolert med en fiktiv liste.
class BottomNav extends StatelessWidget {

  final StatefulNavigationShell navigationShell;
  final List<BottomNavRoutes> destinations;

  const BottomNav({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Bruk linjen under fremfor body: navigationShell dersom det ønskes at all tekst i appen kan kopieres.
      //body: SelectionArea(child: navigationShell),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index, 
            initialLocation: index == navigationShell.currentIndex);
        },
        destinations: destinations.map((destination) {
          return NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          );
        }).toList(),
      ),
    );
  }
}