import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    String appBarTitle = "";
    print("LayoutScaffoldWithNav building. shellLocation: '$shellLocation'");

    switch (shellLocation) {
      case Routes.home:
        appBarTitle = "Fundusnap";
      case Routes.scan:
        appBarTitle = "Scan";
      case Routes.cases:
        appBarTitle = "Cases";
      case Routes.profile:
        appBarTitle = "Profile";
      default:
        "Default";
    }

    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 24,
        title: Text(
          appBarTitle,
          style: TextStyle(
            // fontFamily: GoogleFonts.poppins().fontFamily,
            // fontFamily: appBarTitle == "Fundusnap"
            // ? GoogleFonts.majorMonoDisplay().fontFamily
            // ? GoogleFonts.poppins().fontFamily
            // : GoogleFonts.poppins().fontFamily,
            letterSpacing: appBarTitle == "Fundusnap" ? 2.5 : null,
            fontWeight: appBarTitle == "Fundusnap" ? FontWeight.bold : null,
          ),
        ),
        centerTitle: appBarTitle == "Fundusnap" ? true : false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20, right: 20),
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        key: ValueKey<int>(navigationShell.currentIndex),
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
                selectedIcon: Icon(destination.icon),
              ),
            )
            .toList(),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // print(GoRouterState.of(context).matchedLocation);
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}
