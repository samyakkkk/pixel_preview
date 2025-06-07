import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview.dart';
import 'package:pixel_preview/pixel_thumbnail/grid_thumbnail_builder.dart';
import 'package:pixel_preview/pixel_thumbnail/slanting_thumbnail_builder.dart';

enum ThumbnailBuilderKind { slanting, grid }

/// A widget that displays a collection of PixelPreview components in a grid layout.
///
/// This widget provides a responsive grid layout optimized for larger landscape screens.
///
/// Note: The widgets provided to this class should already be wrapped in PixelPreview widgets.
///
/// Screens support is coming in a future update.
class PixelThumbnail extends StatelessWidget {
  /// List of all widgets (currently only components are supported) to display
  final List<PixelPreview> screens;
  final ThumbnailBuilderKind thumbnailBuilderKind;

  const PixelThumbnail(
      {super.key,
      required this.screens,
      this.thumbnailBuilderKind = ThumbnailBuilderKind.slanting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: thumbnailBuilderKind == ThumbnailBuilderKind.slanting
            ? SlantingThumbnailBuilder(
                screens: screens,
              )
            : GridThumbnailBuilder(screens: screens));
  }
}
