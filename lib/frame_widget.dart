import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_theme.dart';

class FrameWidget extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double initialHeight;
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final Color backgroundColor;

  final Function(double, double)? onSizeChanged;

  const FrameWidget({
    super.key,
    required this.child,
    this.initialWidth = 500.0,
    this.initialHeight = 333.0,
    this.minWidth = 100.0,
    this.minHeight = 100.0,
    this.maxWidth = 2000.0,
    this.maxHeight = 2000.0,
    this.backgroundColor = Colors.transparent,
    this.onSizeChanged,
  });

  @override
  State<FrameWidget> createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  double _scale = 1.0;
  late double _width;
  late double _height;
  bool _draggingRight = false;
  bool _draggingBottom = false;
  bool _draggingCorner = false;

  static const handleSize = 20.0;
  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
  }

  @override
  void didUpdateWidget(FrameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update dimensions if initial values change
    if (oldWidget.initialWidth != widget.initialWidth) {
      setState(() {
        _width = widget.initialWidth;
      });
    }
    if (oldWidget.initialHeight != widget.initialHeight) {
      setState(() {
        _height = widget.initialHeight;
      });
    }
  }

  void _notifySizeChanged() {
    if (widget.onSizeChanged != null) {
      widget.onSizeChanged!(_width, _height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final widthScale = availableWidth / _width;
        final heightScale = availableHeight / _height;
        final minScale = min(widthScale, heightScale);
        _scale = minScale < 1 ? minScale : 1;

        // Use FittedBox instead of Transform.scale to properly fit the content
        return Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _width,
              height: _height,
              child: Stack(
                children: [
                  // Main content container
                  ClipRect(
                    child: Container(
                      width: _width,
                      height: _height,
                      decoration: PixelTheme.frameBorderDecoration(
                          backgroundColor: widget.backgroundColor),
                      child: Center(child: widget.child),
                    ),
                  ),

                  // Right handle
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) => setState(() => _draggingRight = true),
                      onPanEnd: (_) {
                        setState(() => _draggingRight = false);
                        _notifySizeChanged();
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _width = (_width + details.delta.dx / _scale).clamp(
                            widget.minWidth,
                            widget.maxWidth,
                          );
                        });
                        _notifySizeChanged();
                      },
                      child: Container(
                        width: handleSize,
                        color: _draggingRight
                            ? PixelTheme.activeHandleHighlight
                            : Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 30,
                            decoration: PixelTheme.handleDecoration,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom handle
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onPanStart: (_) => setState(() => _draggingBottom = true),
                      onPanEnd: (_) {
                        setState(() => _draggingBottom = false);
                        _notifySizeChanged();
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _height = (_height + details.delta.dy / _scale).clamp(
                            widget.minHeight,
                            widget.maxHeight,
                          );
                        });
                        _notifySizeChanged();
                      },
                      child: Container(
                        height: handleSize,
                        color: _draggingBottom
                            ? PixelTheme.activeHandleHighlight
                            : Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 4,
                            decoration: PixelTheme.handleDecoration,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Corner handle
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (_) => setState(() => _draggingCorner = true),
                      onPanEnd: (_) {
                        setState(() => _draggingCorner = false);
                        _notifySizeChanged();
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _width = (_width + details.delta.dx / _scale).clamp(
                            widget.minWidth,
                            widget.maxWidth,
                          );
                          _height = (_height + details.delta.dy / _scale).clamp(
                            widget.minHeight,
                            widget.maxHeight,
                          );
                        });
                        _notifySizeChanged();
                      },
                      child: Container(
                        width: handleSize,
                        height: handleSize,
                        color: _draggingCorner
                            ? PixelTheme.activeHandleHighlight
                            : Colors.transparent,
                        child: Center(
                          child: Icon(
                            Icons.drag_handle,
                            size: 16,
                            color: PixelTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
