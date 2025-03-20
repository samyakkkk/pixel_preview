import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_theme.dart';
import 'package:pixel_preview/preview_widget.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.isScreen,
  });

  final bool isScreen;

  @override
  Widget build(BuildContext context) {
    final String itemType = isScreen ? 'screens' : 'components';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isScreen ? Icons.phone_android_outlined : Icons.widgets_outlined,
            size: 64,
            color: PixelTheme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No $itemType added yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PixelTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add $itemType to see them displayed here',
            style: TextStyle(
              fontSize: 16,
              color: PixelTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.child,
    this.gridSpacing = 16.0,
  });
  final PixelPreview child;
  final double gridSpacing;

  @override
  Widget build(BuildContext context) {
    // Ensure thumbnail mode is enabled for all PixelPreview widgets
    Widget thumbnailChild = child;
    if (!child.thumbnailMode) {
      thumbnailChild = PixelPreview(
        presets: child.presets,
        enabled: child.enabled,
        thumbnailMode: true,
        child: child.child, // Force thumbnail mode
      );
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(gridSpacing / 2),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: PixelTheme.lightGray, width: 1),
      ),
      child: thumbnailChild,
    );
  }
}
