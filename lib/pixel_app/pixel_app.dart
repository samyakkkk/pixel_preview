import 'package:flutter/material.dart';
import 'package:pixel_preview/preview_widget.dart';
import 'package:pixel_preview/pixel_theme.dart';
import 'package:pixel_preview/pixel_app/components_builder.dart';
import 'package:pixel_preview/pixel_app/screens_builder.dart';

/// A widget that displays a collection of PixelPreview components and screens in a grid layout.
///
/// This widget provides a tabbed interface to separate components and screens,
/// and displays them in a responsive grid layout optimized for larger landscape screens.
///
/// Note: The widgets provided to this class should already be wrapped in PixelPreview widgets.
class PixelApp extends StatefulWidget {
  /// List of all widgets (components and screens) to display
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

    // If widgets are provided, filter them by preset type
    List<PixelPreview> componentWidgets =
        List<PixelPreview>.from(widget.widgets.where((w) {
      if (w is PixelPreview) {
        return !w.presets.isScreen; // Component presets
      }
      return false;
    }).toList());

    List<PixelPreview> screenWidgets =
        List<PixelPreview>.from(widget.widgets.where((w) {
      if (w is PixelPreview) {
        return w.presets.isScreen; // Screen presets
      }
      return false;
    }).toList());

    return MaterialApp(
      title: widget.title,
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pixel App View"),
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
