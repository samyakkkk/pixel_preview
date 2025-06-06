import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/components_builder.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';
import 'package:pixel_preview/pixel_thumbnail/thumbnail_builder.dart';
import 'package:pixel_preview/utils/pixel_theme.dart';

/// A widget that displays a collection of PixelPreview components in a grid layout.
///
/// This widget provides a responsive grid layout optimized for larger landscape screens.
///
/// Note: The widgets provided to this class should already be wrapped in PixelPreview widgets.
///
/// Screens support is coming in a future update.
class PixelApp extends StatelessWidget {
  /// List of all widgets (currently only components are supported) to display
  final List<PixelGroup> groups;

  /// Optional title for the app
  final String title;

  /// Whether PixelApp is displayed within an iframe in your website.
  final bool iFrameMode;

  final double gridSpacing = 24.0;
  const PixelApp({
    super.key,
    required this.groups,
    this.title = 'Pixel Preview',
    this.iFrameMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !iFrameMode
            ? AppBar(
                title: Text(title),
                backgroundColor: PixelTheme.primaryBlue,
                foregroundColor: Colors.white,
              )
            : null,
        body: ThumbnailBuilder(
          groups: groups,
          canvasSize: Size(1000, 1000),
        ));
  }
}
