import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugeye/app/themes/app_colors.dart';

final ColorScheme sugeyeLightColor = ColorScheme.fromSeed(
  seedColor: AppColors.angelBlue,
  brightness: Brightness.light,
);

final ThemeData sugeyeLightTheme = ThemeData().copyWith(
  colorScheme: sugeyeLightColor,
  // textTheme: GoogleFonts.lexendTextTheme(),
  textTheme: GoogleFonts.plusJakartaSansTextTheme(),

  appBarTheme: const AppBarTheme(
    toolbarHeight: 65,
    backgroundColor: AppColors.angelBlue,
    // backgroundColor: AppColors.white,
    foregroundColor: AppColors.bleachedCedar,
    titleTextStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: AppColors.bleachedCedar,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.angelBlue,
    indicatorColor: AppColors.bleachedCedar,
    // indicatorColor: AppColors.mint,
    iconTheme: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          // ? (const IconThemeData(color: AppColors.angelBlue))
          ? (const IconThemeData(color: AppColors.angelBlue))
          // : (const IconThemeData(color: AppColors.gray)),
          : (const IconThemeData(color: AppColors.bleachedCedar)),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? const TextStyle(color: AppColors.bleachedCedar)
          // : const TextStyle(color: AppColors.gray),
          : const TextStyle(color: AppColors.bleachedCedar),
    ),
  ),

  scaffoldBackgroundColor: AppColors.white,
);
