import 'package:flutter/material.dart';

/// Theme class for PixelPreview widgets
class PixelTheme {
  // Primary colors
  static const Color primaryBlue = Color(0xFF0066A6);
  static const Color lightBlue = Color(0xFF42B0F0);
  static const Color coralRed = Color(0xFFF05042);
  static const Color mintGreen = Color(0xFF7DDFD3);
  static const Color lightGray = Color(0xFFCCCCCC);

  // Background colors
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color darkBackground = Color(0xFF333333);
  static const Color canvasBackground = Color(0xFFF5F5F7); // Light color for canvas

  // Text colors
  static const Color primaryText = Color(0xFF0066A6);
  static const Color secondaryText = Color(0xFF666666);

  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(color: primaryBlue),
    ),
  );

  // Toggle button style
  static ButtonStyle toggleButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryBlue,
    elevation: 2,
    shape: const CircleBorder(),
  );

  // Card style
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Frame border style
  static BoxDecoration frameBorderDecoration({Color backgroundColor = Colors.transparent}) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: primaryBlue.withOpacity(0.3), width: 1.5),
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: [
        BoxShadow(
          color: primaryBlue.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Handle style
  static BoxDecoration handleDecoration = BoxDecoration(
    color: primaryBlue.withOpacity(0.8),
    borderRadius: BorderRadius.circular(2),
  );

  // Active handle highlight
  static Color activeHandleHighlight = lightBlue.withOpacity(0.3);

  // Text styles
  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryBlue,
  );

  static TextStyle subtitleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: primaryBlue,
  );

  static TextStyle bodyTextStyle = const TextStyle(
    fontSize: 14,
    color: secondaryText,
  );
}
