import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart'; // Added for PixelPreview

class GridThumbnailBuilder extends StatelessWidget {
  final List<PixelPreview> screens;

  const GridThumbnailBuilder({
    super.key,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenRatio = constraints.maxWidth / constraints.maxHeight;
      final ratio = 1.5;
      late double height;
      late double width;
      if (screenRatio >= ratio) {
        height = constraints.maxHeight;
        width = constraints.maxHeight * ratio;
      } else {
        width = constraints.maxWidth;
        height = constraints.maxWidth / ratio;
      }

      return Center(
        child: Container(
            color: Colors.grey.shade100,
            height: height,
            width: width,
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(children: [
                Positioned(
                    left: 45,
                    top: 45,
                    child: Image.network(
                      'https://cdn-images-1.medium.com/v2/resize:fit:1200/1*KKM72hHVmUGEP4kD3GffbQ.jpeg',
                      height: 100,
                    )),
                Positioned(
                    left: 25,
                    bottom: 45,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                      height: 40,
                    )),
                ..._buildColumn(
                    screens.sublist(0, 3), constraints.maxHeight, 0.1, 0),
                ..._buildColumn(
                    screens.sublist(3, 6), constraints.maxHeight, 0.3, 1),
                ..._buildColumn(
                    screens.sublist(6, 9), constraints.maxHeight, 0.1, 2),
                ..._buildColumn(
                    screens.sublist(9, 12), constraints.maxHeight, 0.3, 3),
              ]);
            })),
      );
    });
  }

  List<Widget> _buildColumn(List<PixelPreview> widgets, double maxHeight,
      double startingPoint, int columnIndex) {
    final deviceHeightRatio = 0.73;
    final paddingRatio = 0.01;
    final totalRatio = deviceHeightRatio + (2 * paddingRatio);
    final deviceHeight = maxHeight * deviceHeightRatio;
    final devicePadding = maxHeight * paddingRatio;
    final double leftStartingPoint = maxHeight * 0.25 + (columnIndex * 330);

    return [
      _buildPositionedScreen(widgets[0], deviceHeight, devicePadding,
          leftStartingPoint, maxHeight * (startingPoint - totalRatio)),
      _buildPositionedScreen(widgets[1], deviceHeight, devicePadding,
          leftStartingPoint, maxHeight * startingPoint),
      _buildPositionedScreen(widgets[2], deviceHeight, devicePadding,
          leftStartingPoint, maxHeight * (startingPoint + totalRatio))
    ];
  }

  Widget _buildPositionedScreen(PixelPreview widgetToRender, double height,
      double padding, double left, double top) {
    PixelPreview child = widgetToRender;

    child = PixelPreview(
      presets: child.presets,
      enabled: child.enabled,
      thumbnailMode: true,
      name: child.name,
      child: child.child,
    );

    return Positioned(
      left: left,
      top: top,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: SizedBox(
          width: height * child.presets.aspectRatio,
          height: height,
          child:
              ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
        ),
      ),
    );
  }
}
