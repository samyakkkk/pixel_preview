import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart'; // Added for PixelPreview

class SlantingThumbnailBuilder extends StatelessWidget {
  final List<PixelPreview> screens;

  final bool lenientLayout = true;

  const SlantingThumbnailBuilder({super.key, required this.screens});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenRatio = constraints.maxWidth / constraints.maxHeight;
      final ratio = 1.66;
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
                    left: constraints.maxHeight * 0.1,
                    top: constraints.maxHeight * 0.1,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                      height: constraints.maxHeight * 0.1,
                    )),
                _buildColumn(
                    screens.sublist(0, 2), constraints.maxHeight, -0.3, 0),
                _buildColumn(
                    screens.sublist(2, 4), constraints.maxHeight, -0.5, 1),
                _buildColumn(
                    screens.sublist(4, 5), constraints.maxHeight, 0.38, 2)
              ]);
            })),
      );
    });
  }

  Widget _buildColumn(List<PixelPreview> widgets, double maxHeight,
      double startingPoint, int columnIndex) {
    final deviceHeightRatio = lenientLayout ? 1.0 : 0.9;
    final paddingRatio = lenientLayout ? 0.03 : 0.02;

    final deviceHeight = maxHeight * deviceHeightRatio;
    final deviceWidth = deviceHeight * widgets[0].presets.aspectRatio;
    final devicePadding = maxHeight * paddingRatio;
    final deviceBorder = maxHeight * 0.025;
    double leftStartingPoint = maxHeight * (lenientLayout ? 0.32 : 0.34);

    switch (columnIndex) {
      case 0:
        leftStartingPoint = leftStartingPoint;
        break;
      case 1:
        leftStartingPoint = leftStartingPoint +
            (columnIndex * (deviceWidth + devicePadding) * 1.635);
        break;
      case 2:
        leftStartingPoint = leftStartingPoint +
            (columnIndex * (deviceWidth + devicePadding)) *
                (lenientLayout ? 1.25 : 1.15);
        break;
      default:
        leftStartingPoint = leftStartingPoint;
    }

    return Positioned(
      left: leftStartingPoint,
      top: maxHeight * startingPoint,
      child: Transform.rotate(
        angle: 35 * 3.141592653589793 / 180,
        child: Column(
          children: [
            // check if widgets[i] is availablef for each positioned.
            if (widgets.isNotEmpty)
              _buildPositionedScreen(widgets[0], deviceHeight, deviceWidth,
                  devicePadding, deviceBorder),
            if (widgets.length > 1)
              _buildPositionedScreen(widgets[1], deviceHeight, deviceWidth,
                  devicePadding, deviceBorder),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionedScreen(PixelPreview widgetToRender, double height,
      double width, double padding, double borderRadius) {
    PixelPreview child = widgetToRender;

    child = PixelPreview(
      presets: child.presets,
      enabled: child.enabled,
      thumbnailMode: true,
      name: child.name,
      child: child.child,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius), child: child),
      ),
    );
  }
}
