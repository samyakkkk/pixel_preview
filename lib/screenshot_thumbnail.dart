import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that renders another widget at its actual size, captures a screenshot,
/// and displays it as a thumbnail.
class ScreenshotThumbnail extends StatefulWidget {
  /// The widget to render and capture
  final Widget child;

  /// The background color for the widget
  final Color backgroundColor;

  /// The width of the widget when rendered for screenshot
  final double renderWidth;

  /// The height of the widget when rendered for screenshot
  final double renderHeight;

  // /// The width of the displayed thumbnail
  // final double thumbnailWidth;

  // /// The height of the displayed thumbnail
  // final double thumbnailHeight;

  /// Callback when the thumbnail is tapped
  final VoidCallback? onTap;

  const ScreenshotThumbnail({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.renderWidth,
    required this.renderHeight,
    // required this.thumbnailWidth,
    // required this.thumbnailHeight,
    this.onTap,
  });

  @override
  State<ScreenshotThumbnail> createState() => _ScreenshotThumbnailState();
}

class _ScreenshotThumbnailState extends State<ScreenshotThumbnail> {
  ui.Image? _screenshot;
  bool _isCapturing = false;
  bool _showFabric = true;

  @override
  void initState() {
    super.initState();
  }

  // Callback for when the screenshot is available
  void _onScreenshotAvailable(ui.Image image) {
    setState(() {
      _screenshot = image;
      _isCapturing = false;
      _showFabric =
          false; // Remove the fabric from the tree once we have the screenshot
    });
  }

  // Callback for when screenshot capture starts
  void _onCaptureStarted() {
    setState(() {
      _isCapturing = true;
    });
  }

  // Callback for when screenshot capture fails
  void _onCaptureFailed() {
    setState(() {
      _isCapturing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Only show the fabric when needed
        if (_showFabric)
          ScrollableFabric(
            widget: widget,
            onScreenshotAvailable: _onScreenshotAvailable,
            onCaptureStarted: _onCaptureStarted,
            onCaptureFailed: _onCaptureFailed,
          ),
        // if (!_showFabric)
        InkWell(
          onTap: widget.onTap,
          child: Container(
            constraints: BoxConstraints.expand(),
            color: widget.backgroundColor,
            child: _isCapturing || _screenshot == null
                ?
                // Show loading indicator while capturing
                const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: RawImage(
                      image: _screenshot,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class ScrollableFabric extends StatefulWidget {
  const ScrollableFabric({
    super.key,
    required this.widget,
    required this.onScreenshotAvailable,
    required this.onCaptureStarted,
    required this.onCaptureFailed,
  });

  final ScreenshotThumbnail widget;
  final Function(ui.Image) onScreenshotAvailable;
  final VoidCallback onCaptureStarted;
  final VoidCallback onCaptureFailed;

  @override
  State<ScrollableFabric> createState() => _ScrollableFabricState();
}

class _ScrollableFabricState extends State<ScrollableFabric> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    // Schedule the screenshot capture after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureScreenshot();
    });
  }

  Future<void> _captureScreenshot() async {
    if (_isCapturing) return;

    _isCapturing = true;
    widget.onCaptureStarted();

    // Get the RenderRepaintBoundary
    final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) throw Error();

    // Capture the image with proper device pixel ratio for better quality
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final image = await boundary.toImage(pixelRatio: pixelRatio);

    // Notify parent that screenshot is available
    widget.onScreenshotAvailable(image);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "screenshot render width ${widget.widget.renderWidth} height: ${widget.widget.renderHeight}");
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: widget.widget.renderWidth,
          height: widget.widget.renderHeight,
          child: Center(
            child: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: widget.widget.child,
          )
          ),
        ),
      ),
    );
  }
}

/// A widget that renders a widget with its actual size in the background,
/// takes a screenshot, and displays it as a thumbnail.
class ScreenshotThumbnailBuilder extends StatelessWidget {
  /// The widget to render and capture
  final Widget child;

  /// The background color for the widget
  final Color backgroundColor;

  /// The width of the widget when rendered for screenshot
  final double renderWidth;

  /// The height of the widget when rendered for screenshot
  final double renderHeight;

  // /// The width of the displayed thumbnail
  // final double thumbnailWidth;

  // /// The height of the displayed thumbnail
  // final double thumbnailHeight;

  /// Callback when the thumbnail is tapped
  final VoidCallback? onTap;

  const ScreenshotThumbnailBuilder({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.renderWidth,
    required this.renderHeight,
    // required this.thumbnailWidth,
    // required this.thumbnailHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenshotThumbnail(
        backgroundColor: backgroundColor,
        renderWidth: renderWidth,
        renderHeight: renderHeight,
        // thumbnailWidth: thumbnailWidth,
        // thumbnailHeight: thumbnailHeight,
        onTap: onTap,
        child: child,
    
    );
  }
}