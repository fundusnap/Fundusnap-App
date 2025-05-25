import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';
import 'package:sugeye/app/routing/routes.dart';

class LayoutScaffoldWithNav extends StatelessWidget {
  const LayoutScaffoldWithNav({
    required this.navigationShell,
    required this.shellLocation,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final String shellLocation;

  @override
  Widget build(BuildContext context) {
    late String appBarTitle;

    switch (shellLocation) {
      case Routes.home:
        appBarTitle = "Home";
      case Routes.scan:
        appBarTitle = "Scan";
      case Routes.patients:
        appBarTitle = "Patients";
      case Routes.profile:
        appBarTitle = "Profile";
      default:
        "";
    }

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
                // selectedIcon: Icon(destination.icon),
              ),
            )
            .toList(),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}
