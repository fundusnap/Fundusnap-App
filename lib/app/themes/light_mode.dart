import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugeye/app/themes/app_colors.dart';

final ColorScheme sugeyeLightColor = ColorScheme.fromSeed(
  seedColor: AppColors.angelBlue,
  brightness: Brightness.light,
);

final ThemeData sugeyeLightTheme = ThemeData().copyWith(
  colorScheme: sugeyeLightColor,
  textTheme: GoogleFonts.lexendTextTheme(),
  appBarTheme: const AppBarTheme(
    toolbarHeight: 65,
    backgroundColor: AppColors.angelBlue,
    foregroundColor: AppColors.white,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.angelBlue,
    indicatorColor: AppColors.bittersweet,
    iconTheme: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? (const IconThemeData(color: AppColors.angelBlue))
          : (const IconThemeData(color: AppColors.white)),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? const TextStyle(color: AppColors.bittersweet)
          : const TextStyle(color: AppColors.white),
    ),
  ),

  scaffoldBackgroundColor: AppColors.white,
);
