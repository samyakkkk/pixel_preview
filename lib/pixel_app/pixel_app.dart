import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/components_builder.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';
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
  final List<PixelGroup> groups;

  /// Optional title for the app
  final String title;

  const PixelApp({
    super.key,
    required this.groups,
    this.title = 'Pixel Preview',
  });

  @override
  State<PixelApp> createState() => _PixelAppState();
}

class _PixelAppState extends State<PixelApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final double gridSpacing = 24.0;
  late final List<PixelGroup> componentGroups;
  late final List<PixelGroup> screenGroups;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    componentGroups = widget.groups.map((group) => group.components).toList();
    screenGroups = widget.groups.map((group) => group.screens).toList();

    for (final group in screenGroups) {
      if (group.children.isNotEmpty) {
        debugPrint(
            '[PixelApp] Found ${group.children.length} screen widgets in group "${group.title}", but screens are not currently supported.');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: PixelTheme.primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: GridBuilder(groups: widget.groups, gridSpacing: gridSpacing)
        );
  }
}
