import 'package:flutter/material.dart';

import '../../Utilits/colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: weevoPrimaryOrangeColor,
          onPrimary: Colors.white,
          secondary: weevoGreen,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.white,
          elevation: 0.0,
          toolbarHeight: 70.0,
          iconTheme: IconThemeData(color: weevoPrimaryOrangeColor),
          titleTextStyle: TextStyle(
            color: weevoPrimaryOrangeColor,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: const Color(0xff091147),
              displayColor: const Color(0xff091147),
              fontFamily: 'ArabFont',
            ),
      );
}
