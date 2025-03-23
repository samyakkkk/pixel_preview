import 'package:example/widgets/component.dart';
import 'package:example/widgets/screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';
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
        title: 'Dashboard UI Kit',
        // Using a single widgets list instead of separate components and screens lists
        groups: [
          PixelGroup(
            title: 'Cards',
            children: [
              // Original components
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
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.large,
                  backgroundColor: Colors.white,
                ),
                child: ResponsiveAppComponent(
                  title: 'Dashboard Card',
                  description: 'A responsive card component for dashboards.',
                  icon: Icons.dashboard,
                  onTap: () {},
                ),
              ),

              // StatWidget
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.medium,
                  backgroundColor: Colors.white,
                ),
                child: StatWidget(
                  primaryBlue: const Color(0xFF1A365D),

                  statItems: statItems,
                ),
              ),
              PixelPreview(
                presets: ComponentPresets(
                  size: Size(950.0, 500.0),
                  backgroundColor: Colors.white,
                ),
                child: StatWidget(
                  primaryBlue: const Color(0xFF1A365D),

                  statItems: statItems,
                ),
              ),
            ],
          ),
          PixelGroup(
            title: 'Utility',
            children: [
              // TimelineActivityCard
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.medium,
                  backgroundColor: Colors.white,
                ),
                child: TimelineActivityCard(
                  coralRed: const Color(0xFFFF6B6B),
                  lightGray: const Color(0xFFE2E8F0),
                  activities: [
                    {
                      'user': 'John Doe',
                      'action': 'created a new project',
                      'time': '2h ago',
                    },
                    {
                      'user': 'Jane Smith',
                      'action': 'updated user settings',
                      'time': '4h ago',
                    },
                    {
                      'user': 'Mike Johnson',
                      'action': 'uploaded new content',
                      'time': 'Yesterday',
                    },
                    {
                      'user': 'Sarah Williams',
                      'action': 'completed onboarding',
                      'time': 'Yesterday',
                    },
                  ],
                ),
              ),

              // ActivityCard
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.medium,
                  backgroundColor: Colors.white,
                ),
                child: ActivityCard(
                  lightBlue: const Color(0xFF4299E1),
                  activity: {
                    'user': 'John Doe',
                    'action': 'created a new project',
                    'time': '2 hours ago',
                  },
                ),
              ),

              // BottomNav widget
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.large,
                  backgroundColor: Colors.white,
                ),
                child: BottomNav(
                  lightBlue: const Color(0xFF4299E1),
                  selectedIndex: 0,
                  updateIndex: (index) {},
                ),
              ),

              // QuickAction
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.small,
                  backgroundColor: Colors.white,
                ),
                child: QuickAction(
                  action: {
                    'icon': Icons.add_circle,
                    'label': 'New Project',
                    'color': const Color(0xFF4FD1C5),
                  },
                ),
              ),
            ],
          ),

          PixelGroup(
            title: "Avatars",
            children: [
              // Newly created widgets from screen.dart.dart
              // UserAvatar widget
              PixelPreview(
                presets: ComponentPresets(
                  size: ComponentSizes.small,
                  backgroundColor: Colors.white,
                ),
                child: UserAvatar(lightBlue: const Color(0xFF4299E1)),
              ),
            ],
          ),
        ],
      );
    }
  }

  final statItems = [
    {
      'icon': Icons.people,
      'label': 'Users',
      'value': '2,543',
      'color': lightBlue,
    },
    {
      'icon': Icons.bar_chart,
      'label': 'Revenue',
      'value': '\$12,432',
      'color': mintGreen,
    },
    {
      'icon': Icons.trending_up,
      'label': 'Growth',
      'value': '+24%',
      'color': coralRed,
    },
    {
      'icon': Icons.star,
      'label': 'Rating',
      'value': '4.8',
      'color': Colors.amber,
    },
  ];
}
