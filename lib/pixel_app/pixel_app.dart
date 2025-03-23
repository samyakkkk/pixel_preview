import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart';
import 'package:pixel_preview/pixel_app/components_builder.dart';
import 'package:pixel_preview/utils/pixel_theme.dart';

/// A widget that displays a collection of PixelPreview components in a grid layout.
///
/// This widget provides a responsive grid layout optimized for larger landscape screens.
///
/// Note: The widgets provided to this class should already be wrapped in PixelPreview widgets.
///
/// Screens support is coming in a future update.
class PixelApp extends StatefulWidget {
  /// List of all widgets (currently only components are supported) to display
  final List<Widget> widgets;

  /// Optional title for the app
  final String title;

  /// Optional custom theme for the app
  final ThemeData? theme;

  /// Optional spacing between grid items
  final double gridSpacing;

  /// Optional number of columns for the grid on large screens
  final int largeScreenColumns;

  /// Optional number of columns for the grid on medium screens
  final int mediumScreenColumns;

  /// Optional number of columns for the grid on small screens
  final int smallScreenColumns;

  const PixelApp({
    super.key,
    required this.widgets,
    this.title = 'Pixel Preview',
    this.theme,
    this.gridSpacing = 16.0,
    this.largeScreenColumns = 3,
    this.mediumScreenColumns = 2,
    this.smallScreenColumns = 1,
  });

  @override
  State<PixelApp> createState() => _PixelAppState();
}

class _PixelAppState extends State<PixelApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Check if user has provided any screens in the init state
    final hasScreens = widget.widgets.any((w) {
      if (w is PixelPreview) {
        return w.presets.isScreen;
      }
      return false;
    });
    
    if (hasScreens) {
      debugPrint('PixelApp: Screens are not currently supported. Screen widgets will be ignored.');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ??
        ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: PixelTheme.primaryBlue),
          useMaterial3: true,
        );

    // If widgets are provided, filter them by preset type (only components are currently supported)
    List<PixelPreview> componentWidgets =
        List<PixelPreview>.from(widget.widgets.where((w) {
      if (w is PixelPreview) {
        return !w.presets.isScreen; // Component presets
      }
      return false;
    }).toList());
    
    // Check if user has provided any screens and log a debug message
    final screenWidgets = widget.widgets.where((w) {
      if (w is PixelPreview) {
        return w.presets.isScreen; // Screen presets
      }
      return false;
    }).toList();
    
    if (screenWidgets.isNotEmpty) {
      debugPrint('PixelApp: Found ${screenWidgets.length} screen widgets, but screens are not currently supported.');
    }

    // List<PixelPreview> screenWidgets =
    //     List<PixelPreview>.from(widget.widgets.where((w) {
    //   if (w is PixelPreview) {
    //     return w.presets.isScreen; // Screen presets
    //   }
    //   return false;
    // }).toList());

    return MaterialApp(
      title: widget.title,
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: PixelTheme.primaryBlue,
          foregroundColor: Colors.white,
          // bottom: TabBar(
          //   controller: _tabController,
          //   tabs: const [
          //     Tab(text: 'Components', icon: Icon(Icons.widgets)),
          //     Tab(text: 'Screens', icon: Icon(Icons.phone_android)),
          //   ],
          //   labelColor: Colors.white,
          //   unselectedLabelColor: Colors.white70,
          //   indicatorColor: Colors.white,
          // ),
        ),
        body: ComponentsBuilder(
                components: componentWidgets, gridSpacing: widget.gridSpacing)
        // body: TabBarView(
        //   controller: _tabController,
        //   children: [
        //     ComponentsBuilder(
        //         components: componentWidgets, gridSpacing: widget.gridSpacing),
        //     ScreensBuilder(
        //         screens: screenWidgets, gridSpacing: widget.gridSpacing),
        //   ],
        // ),
      ),
    );
  }
}
