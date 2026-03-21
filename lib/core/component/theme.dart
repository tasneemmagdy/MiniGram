import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFB39DDB),    
    secondary: Color(0xFFCE93D8), 
    surface: Color(0xFF1E1E2E),
    background: Color(0xFF13131F),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
   scaffoldBackgroundColor: const Color(0xFF1C1C1C),
cardColor: const Color(0xFF272727),
  dividerColor: Colors.white12,
  iconTheme: const IconThemeData(color: Colors.white60),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white54),
    titleMedium: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A3E),
    hintStyle: const TextStyle(color: Colors.white30),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFB39DDB)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
backgroundColor: Color(0xFF272727),
    selectedItemColor: Color(0xFFB39DDB),
    unselectedItemColor: Colors.white30,
    elevation: 20,
    type: BottomNavigationBarType.fixed,
  ),
  appBarTheme: const AppBarTheme(
    
    titleSpacing: 20.0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
backgroundColor: Color(0xFF272727),
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
statusBarColor: Color(0xFF272727),      statusBarBrightness: Brightness.light,
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color(0xFF2A2A3E),
    textStyle: TextStyle(color: Colors.white),
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
primary: Color.fromARGB(255, 217, 177, 251),
    secondary: Color(0xFFF48FB1),  
    surface: Color(0xFFFAFAFA),
    background: Color(0xFFF5F5F5),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF2D2D2D),
    onBackground: Color(0xFF2D2D2D),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardColor: Colors.white,
  dividerColor: Colors.black38,
  iconTheme: const IconThemeData(color: Color(0xFF555555)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2D2D2D),
    ),
    bodyMedium: TextStyle(color: Color(0xFF444444)),
    bodySmall: TextStyle(color: Color(0xFF888888)),
    titleMedium: TextStyle(color: Color(0xFF2D2D2D)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF7E57C2)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Color(0xFF444444)),
    titleTextStyle: TextStyle(
      color: Color(0xFF2D2D2D),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF7E57C2),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF7E57C2),
    unselectedItemColor: Color(0xFFAAAAAA),
    elevation: 20.0,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
    textStyle: TextStyle(color: Color(0xFF444444)),
  ),
);