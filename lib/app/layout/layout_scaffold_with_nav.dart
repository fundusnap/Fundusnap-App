import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';

class LayoutScaffoldWithNav extends StatelessWidget {
  const LayoutScaffoldWithNav({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layout Scaffold with Nav')),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
                selectedIcon: Icon(destination.selectedIcon),
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
