import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color palette inspired by Apple Weather
  static const Color primaryBlue = Color(0xFF74B9FF);
  static const Color darkBlue = Color(0xFF0984E3);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color accentBlue = Color(0xFF2196F3);
  
  static const Color sunnyYellow = Color(0xFFFDCB6E);
  static const Color sunnyOrange = Color(0xFFE17055);
  static const Color cloudyGray = Color(0xFF636E72);
  static const Color rainyBlue = Color(0xFF74B9FF);
  static const Color snowyWhite = Color(0xFFDDD6FE);
  
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  static const Color darkBackgroundColor = Color(0xFF1E1E1E);
  static const Color darkSurfaceColor = Color(0xFF2C2C2C);
  static const Color darkCardColor = Color(0xFF3C3C3C);
  
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFDDD6FE);
  static const Color darkTextLight = Color(0xFF74B9FF);

  // Gradients
  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDCB6E), Color(0xFFE17055)],
  );
  
  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF636E72), Color(0xFF2D3436)],
  );
  
  static const LinearGradient rainyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
  );
  
  static const LinearGradient snowyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDDD6FE), Color(0xFFA29BFE)],
  );
  
  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
  );

  // Light theme
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: accentBlue,
      surface: surfaceColor,
      background: backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onBackground: textPrimary,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro Display',
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    ),
    textTheme: _buildTextTheme(Brightness.light),
    fontFamily: 'SF Pro Text',
  );

  // Dark theme
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: accentBlue,
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkTextPrimary,
      onBackground: darkTextPrimary,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro Display',
      ),
    ),
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),
    ),
    textTheme: _buildTextTheme(Brightness.dark),
    fontFamily: 'SF Pro Text',
  );

  TextTheme _buildTextTheme(Brightness brightness) {
    final Color primaryColor = brightness == Brightness.light ? textPrimary : darkTextPrimary;
    final Color secondaryColor = brightness == Brightness.light ? textSecondary : darkTextSecondary;
    final Color lightColor = brightness == Brightness.light ? textLight : darkTextLight;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        fontFamily: 'SF Pro Display',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        fontFamily: 'SF Pro Text',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        fontFamily: 'SF Pro Text',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        fontFamily: 'SF Pro Text',
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        fontFamily: 'SF Pro Text',
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        fontFamily: 'SF Pro Text',
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: lightColor,
        fontFamily: 'SF Pro Text',
      ),
    );
  }

  // Weather-based theme methods
  LinearGradient getWeatherGradient(String condition, bool isDay) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? sunnyGradient : nightGradient;
      case 'cloudy':
      case 'partly cloudy':
        return cloudyGradient;
      case 'rain':
      case 'drizzle':
      case 'showers':
        return rainyGradient;
      case 'snow':
      case 'sleet':
        return snowyGradient;
      default:
        return isDay ? sunnyGradient : nightGradient;
    }
  }

  Color getWeatherColor(String condition, bool isDay) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? sunnyYellow : darkBlue;
      case 'cloudy':
      case 'partly cloudy':
        return cloudyGray;
      case 'rain':
      case 'drizzle':
      case 'showers':
        return rainyBlue;
      case 'snow':
      case 'sleet':
        return snowyWhite;
      default:
        return isDay ? sunnyYellow : darkBlue;
    }
  }

  // Custom widget decorations
  static BoxDecoration glassmorphismDecoration({
    Color? color,
    double borderRadius = 16,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
    );
  }

  static BoxDecoration cardDecoration({
    Color? color,
    double borderRadius = 16,
    double elevation = 0,
  }) {
    return BoxDecoration(
      color: color ?? surfaceColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: elevation > 0
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: elevation,
                offset: Offset(0, elevation / 2),
              ),
            ]
          : null,
    );
  }

  // Typography helpers
  static TextStyle get temperatureStyle => const TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w100,
    color: Colors.white,
    fontFamily: 'SF Pro Display',
  );

  static TextStyle get conditionStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'SF Pro Display',
  );

  static TextStyle get locationStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    fontFamily: 'SF Pro Text',
  );

  static TextStyle get sectionHeaderStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SF Pro Display',
  );

  static TextStyle get hourlyTemperatureStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SF Pro Text',
  );

  static TextStyle get dailyTemperatureStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SF Pro Text',
  );

  static TextStyle get detailLabelStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    fontFamily: 'SF Pro Text',
  );

  static TextStyle get detailValueStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SF Pro Text',
  );
}