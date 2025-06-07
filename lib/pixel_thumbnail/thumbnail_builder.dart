import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart'; // Added for PixelPreview
import 'package:pixel_preview/utils/presets.dart';

class ThumbnailBuilder extends StatelessWidget {
  final List<PixelPreview> groups;
  final Size canvasSize;
  final int maxScreensOverlay;
  final double targetScreenPercentageOfCanvas;
  final Offset baseOffset;
  final Offset staggerOffset; // Not used in current centered logic

  const ThumbnailBuilder({
    super.key,
    required this.groups,
    required this.canvasSize,
    this.maxScreensOverlay = 3, // We'll now potentially use up to 3 screens
    this.targetScreenPercentageOfCanvas = 0.8,
    this.baseOffset = const Offset(100, 100),
    this.staggerOffset = const Offset(250, 250),
  });

  @override
  Widget build(BuildContext context) {
    List<PixelPreview> screenWidgets = [];
    List<Presets> screenPresets = [];
    const double screenSpacing = 10.0; // Spacing between screens
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
                // Positioned(
                //     left: constraints.maxHeight * 0.1,
                //     top: constraints.maxHeight * 0.1,
                //     child: Image.network(
                //       'https://cdn-images-1.medium.com/v2/resize:fit:1200/1*KKM72hHVmUGEP4kD3GffbQ.jpeg',
                //       height: constraints.maxHeight * 0.2,
                //     )),
                Positioned(
                    left: constraints.maxHeight * 0.1,
                    top: constraints.maxHeight * 0.1,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                      height: constraints.maxHeight * 0.1,
                    )),

                _buildColumn(
                    groups.sublist(0, 2), constraints.maxHeight, -0.3, 0),
                _buildColumn(
                    groups.sublist(2,4), constraints.maxHeight, -0.5, 1),
                _buildColumn(
                    groups.sublist(4, 5), constraints.maxHeight, 0.38, 2)

                // ..._buildColumn(
                //     groups[0].children, constraints.maxHeight, 0.3, 3),
              ]);
            })),
      );
    });
  }

  Widget _buildColumn(List<PixelPreview> widgets, double maxHeight,
      double startingPoint, int columnIndex) {
    final deviceHeightRatio = 0.9;
    final paddingRatio = 0.02;
    final totalRatio = deviceHeightRatio + (2 * paddingRatio);
    final deviceHeight = maxHeight * deviceHeightRatio;
    final deviceWidth = deviceHeight * widgets[0].presets.aspectRatio;
    final devicePadding = maxHeight * paddingRatio;
    final deviceBorder = maxHeight * 0.025;
    late double leftStartingPoint;
    switch (columnIndex) {
      case 0:
        leftStartingPoint = maxHeight * 0.34;
        break;
      case 1:
        leftStartingPoint = maxHeight * 0.34 +
            (columnIndex * (deviceWidth + devicePadding) * 1.635);
        break;
      case 2:
        leftStartingPoint = maxHeight * 0.34 +
            (columnIndex * (deviceWidth + devicePadding)) * 1.15;
      default:
        leftStartingPoint = maxHeight * 0.34;
        break;
    }

    print(maxHeight);
    return Positioned(
      left: leftStartingPoint,
      top: maxHeight * startingPoint,
      child: Transform.rotate(
        // angle: 0,
        angle: 35 * 3.141592653589793 / 180,
        child: Column(
          children: [
            // check if widgets[i] is availablef for each positioned.
            if (widgets.length > 0)
              _buildPositionedScreen(widgets[0], deviceHeight, deviceWidth,
                  devicePadding, deviceBorder),
            if (widgets.length > 1)
              _buildPositionedScreen(widgets[1], deviceHeight, deviceWidth,
                  devicePadding, deviceBorder),
            // if (widgets.length > 2)
            //   _buildPositionedScreen(widgets[2], deviceHeight, deviceWidth,
            //       devicePadding, deviceBorder)
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
