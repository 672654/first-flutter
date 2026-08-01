import 'package:flutter/material.dart';
import 'package:flutter_supabase_pack/presentation/core/navigation/nav_destination.dart';
import 'package:go_router/go_router.dart';


class BottomNav extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const BottomNav({
    super.key,
    required this.navigationShell
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index, 
            initialLocation: index == navigationShell.currentIndex);
        },
        destinations: AppNavDestination.appNavDestinations.map((destination) {
          return NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          );
        }).toList(),
      ),
    );
  }
}