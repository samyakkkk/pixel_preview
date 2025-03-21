import 'package:example/widgets/component.dart';
import 'package:example/widgets/screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const Color primaryBlue = Color(0xFF1A365D);

  // Set only one of these to true at a time
  bool showPixelApp = true; // Show the full PixelApp with all components
  bool showComponent = false; // Show a single component preview
  bool showScreen = false; // Show a single screen preview

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Preview Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        useMaterial3: true,
      ),
      home: Scaffold(body: _buildContent()),
    );
  }

  // Helper method to build the appropriate content based on selected view mode
  Widget _buildContent() {
    // COMPONENT VIEW
    if (showComponent) {
      return PixelPreview(
        presets: ComponentPresets(
          size: ComponentSizes.medium,
          backgroundColor: Colors.white,
        ),
        child: ResponsiveAppComponent(
          title: 'Dashboard Card',
          description: 'A responsive card component for dashboards.',
          icon: Icons.dashboard,
          onTap: () {},
        ),
      );
    }
    // SCREEN VIEW
    else if (showScreen) {
      return PixelPreview(
        key: ValueKey("SCREEN_PREVIEW"),
        presets: ScreenPresets(
          deviceType: DeviceType.iPhone16,
          isLandscape: false,
        ),
        child: ResponsiveScreen(title: 'Dashboard'),
      );
    }
    // PIXEL APP VIEW (DEFAULT)
    else {
      return PixelApp(
        title: 'Pixel UI Kit',
        // Using a single widgets list instead of separate components and screens lists
        widgets: [
          // Component 1 with small size preset
          PixelPreview(
            presets: ComponentPresets(
              size: ComponentSizes.small,
              backgroundColor: Colors.white,
            ),
            child: ResponsiveAppComponent(
              title: 'Dashboard Card',
              description: 'A responsive card component for dashboards.',
              icon: Icons.dashboard,
              onTap: () {},
            ),
          ),
          // Component 2 with medium size preset
          PixelPreview(
            presets: ComponentPresets(
              size: ComponentSizes.medium,
              backgroundColor: const Color(0xFFF5F5F5),
            ),
            child: ResponsiveAppComponent(
              title: 'Analytics Widget',
              description:
                  'Data visualization component with responsive layout.',
              icon: Icons.analytics,
              onTap: () {},
            ),
          ),
          // Component 3 with large size preset
          PixelPreview(
            presets: ComponentPresets(
              size: ComponentSizes.large,
              backgroundColor: Colors.white,
            ),
            child: ResponsiveAppComponent(
              title: 'User Profile',
              description: 'User profile card with adaptive sizing.',
              icon: Icons.person,
              onTap: () {},
            ),
          ),
          // Component 4 with custom background color
          PixelPreview(
            presets: ComponentPresets(
              size: ComponentSizes.medium,
              backgroundColor: const Color(0xFFE6F7FF), // Light blue background
            ),
            child: ResponsiveAppComponent(
              title: 'Settings Panel',
              description: 'Configuration panel with responsive layout.',
              icon: Icons.settings,
              onTap: () {},
            ),
          ),
          // Screen 1 with iPhone 16 preset
          PixelPreview(
            presets: ScreenPresets(deviceType: DeviceType.iPhone16),
            child: ResponsiveScreen(
              title: "Dashboard",
              key: ValueKey("DASHBOARD"),
            ),
          ),
          // Screen 2 with iPad preset
          PixelPreview(
            key: ValueKey("ANALYTICS"),
            presets: ScreenPresets(deviceType: DeviceType.iPad),
            child: ResponsiveScreen(title: "Analytics"),
          ),
          // Screen 3 with desktop preset in landscape mode
          PixelPreview(
            key: ValueKey("USER PROFILE"),
            presets: ScreenPresets(
              deviceType: DeviceType.desktop,
              isLandscape: true,
            ),
            child: ResponsiveScreen(title: "User Profile"),
          ),
        ],
      );
    }
  }
}
