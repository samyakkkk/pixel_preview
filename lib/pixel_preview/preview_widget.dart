import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_preview/pixel_preview/frame_widget.dart';
import 'package:pixel_preview/utils/pixel_theme.dart';
import 'package:pixel_preview/utils/presets.dart';
import 'package:pixel_preview/utils/sizes.dart';

/// Preview type for backward compatibility
@Deprecated(
    'Use presets parameter instead of kind for more customization options')
enum PixelKind {
  component,
  screen,
}

/// Component size dimensions
class ComponentSizes {
  // Predefined sizes
  static const Size small = Size(300.0, 300.0);
  static const Size medium = Size(450.0, 450.0);
  static const Size large = Size(750.0, 750.0);
}

/// Available device types for screen previews
enum DeviceType {
  iPhoneSE,
  iPhone16,
  iPhone16ProMax,
  samsungGalaxyS25,
  iPad,
  desktop,
}

class PixelPreview extends StatefulWidget {
  /// Your widget to view preview of.
  final Widget child;

  /// If disabled, will just display the widget itself. Disabled by default in release mode.
  final bool enabled;

  /// When true, the sidebar with component options will be hidden.
  /// This is useful for thumbnail displays or when embedding in a grid.
  final bool thumbnailMode;

  /// Preset configuration for this preview
  /// The type of preset (ComponentPresets or ScreenPresets) determines
  /// whether this is a component or screen preview
  final Presets presets;

  final String name;

  /// Creates a PixelPreview widget.
  ///
  /// The type of preset [ComponentPresets] or [ScreenPresets] determines
  /// whether this is a component or screen preview
  PixelPreview(
      {super.key,
      required this.child,
      required this.presets,
      this.enabled = !kReleaseMode,
      this.thumbnailMode = false,
      String? name})
      : name = name ?? child.toString();
  @override
  State<PixelPreview> createState() => _PixelPreviewState();
}

class _PixelPreviewState extends State<PixelPreview> {
  Color _backgroundColor = PixelTheme.lightBackground;

  // Size constraints
  late double _width;
  late double _height;

  static const double _minWidth = 100;
  static const double _minHeight = 100;
  static const double _maxWidth = 2000;
  static const double _maxHeight = 2000;

  @override
  void initState() {
    super.initState();

    // Set initial dimensions and configuration based on the preset type
    _width = widget.presets.initialWidth;
    _height = widget.presets.initialHeight;
    _backgroundColor = widget.presets.backgroundColor;

    if (widget.presets is ScreenPresets) {
      // Handle screen-specific initialization
      final screenPresets = widget.presets as ScreenPresets;
      _isLandscape = screenPresets.isLandscape;
      _currentDevice = screenPresets.deviceName;
    }

    if (widget.thumbnailMode) {
      _sidebarExpanded = false;
    }
  }

  // Sidebar state
  bool _sidebarExpanded = true;

  // Orientation state
  bool _isLandscape = false;
  String _currentDevice = '';

  @override
  Widget build(BuildContext context) {
    // If preview is disabled, just return the child widget
    if (!widget.enabled) {
      return widget.child;
    }

    // Determine if we're in a mobile view
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: PixelTheme.canvasBackground,
      body: Row(
        children: [
          // Main content (now first in the row order)
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: FrameWidget(
                    initialWidth: _width,
                    initialHeight: _height,
                    minWidth: _minWidth,
                    minHeight: _minHeight,
                    maxWidth: _maxWidth,
                    maxHeight: _maxHeight,
                    backgroundColor: _backgroundColor,
                    onSizeChanged: (width, height) {
                      setState(() {
                        _width = width;
                        _height = height;
                      });
                    },
                    isThumbnail: widget.thumbnailMode,
                    child: widget.child,
                  ),
                ),
                if (!(widget.thumbnailMode || isMobile))
                  // Sidebar toggle button (visible on all devices)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: PixelTheme.primaryBlue,
                      child: Icon(
                        _sidebarExpanded
                            ? Icons.chevron_right
                            : Icons.chevron_left,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _sidebarExpanded = !_sidebarExpanded;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),

          if (!(widget.thumbnailMode || isMobile))
            // Right sidebar
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _sidebarExpanded ? (isTablet ? 280 : 320) : 0,
              child: _sidebarExpanded
                  ? Container(
                      margin: EdgeInsets.all(8),
                      decoration: PixelTheme.cardDecoration,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Component Options",
                              style: PixelTheme.titleTextStyle,
                            ),
                            SizedBox(height: 16),
                            Divider(),
                            SizedBox(height: 8),

                            // Scrollable content area
                            Expanded(
                              child: SingleChildScrollView(
                                child: widget.presets.isScreen
                                    ? _buildScreenSidebar()
                                    : _buildComponentSidebar(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  Widget _buildComponentSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Component size presets
        Text('Component Size', style: PixelTheme.subtitleTextStyle),
        SizedBox(height: 12),

        // Size preset buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSizeButton(ComponentSizes.small, 'Small'),
            _buildSizeButton(ComponentSizes.medium, 'Medium'),
            _buildSizeButton(ComponentSizes.large, 'Large'),
          ],
        ),

        SizedBox(height: 24),
        Divider(),
        SizedBox(height: 16),

        // Background color options
        Text('Background Color', style: PixelTheme.subtitleTextStyle),
        SizedBox(height: 12),

        // Radio buttons for background color
        RadioListTile<Color>(
          title: Text('Light', style: PixelTheme.bodyTextStyle),
          value: PixelTheme.lightBackground,
          activeColor: PixelTheme.primaryBlue,
          groupValue: _backgroundColor,
          onChanged: (Color? value) {
            if (value != null) {
              setState(() {
                _backgroundColor = value;
              });
            }
          },
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        RadioListTile<Color>(
          title: Text('Dark', style: PixelTheme.bodyTextStyle),
          value: PixelTheme.darkBackground,
          activeColor: PixelTheme.primaryBlue,
          groupValue: _backgroundColor,
          onChanged: (Color? value) {
            if (value != null) {
              setState(() {
                _backgroundColor = value;
              });
            }
          },
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        RadioListTile<Color>(
          title: Text('Transparent', style: PixelTheme.bodyTextStyle),
          value: Colors.transparent,
          activeColor: PixelTheme.primaryBlue,
          groupValue: _backgroundColor,
          onChanged: (Color? value) {
            if (value != null) {
              setState(() {
                _backgroundColor = value;
              });
            }
          },
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),

        SizedBox(height: 24),
        Divider(),
        SizedBox(height: 16),

        // Component size info
        Text('Component Size', style: PixelTheme.subtitleTextStyle),
        SizedBox(height: 8),
        Text('${_width.toInt()} × ${_height.toInt()}'),
        SizedBox(height: 12),
        Text('Drag the handles to resize the component.',
            style: PixelTheme.bodyTextStyle),
      ],
    );
  }

  Widget _buildScreenSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Device', style: PixelTheme.subtitleTextStyle),
        SizedBox(height: 12),

        // Device selection buttons
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DeviceDimensions.dimensions.keys.map((key) {
              return _buildDeviceButton(
                  DeviceDimensions.dimensions[key]!['name'],
                  DeviceDimensions.dimensions[key]!['size']);
            }).toList()),

        // Only show orientation toggle for phones and tablets, not desktop
        if (_currentDevice != '' && _currentDevice != 'Desktop')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Orientation',
                style: PixelTheme.subtitleTextStyle,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('Portrait'),
                    selected: !_isLandscape,
                    selectedColor: PixelTheme.lightBlue.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                        color: !_isLandscape
                            ? PixelTheme.primaryBlue
                            : PixelTheme.secondaryText),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _isLandscape = false;
                          // Swap dimensions if coming from landscape
                          if (_width > _height) {
                            final temp = _width;
                            _width = _height;
                            _height = temp;
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Landscape'),
                    selected: _isLandscape,
                    selectedColor: PixelTheme.lightBlue.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                        color: _isLandscape
                            ? PixelTheme.primaryBlue
                            : PixelTheme.secondaryText),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _isLandscape = true;
                          // Swap dimensions if coming from portrait
                          if (_width < _height) {
                            final temp = _width;
                            _width = _height;
                            _height = temp;
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        SizedBox(height: 24),
        Divider(),
        SizedBox(height: 16),

        // Component size info
        Text('Component Size', style: PixelTheme.subtitleTextStyle),
        SizedBox(height: 8),
        Text('${_width.toInt()} × ${_height.toInt()}'),
        SizedBox(height: 12),
        Text('Drag the handles to resize the component.',
            style: PixelTheme.bodyTextStyle),
      ],
    );
  }

  // Helper method to build device selection buttons
  Widget _buildDeviceButton(String label, Size size) {
    double width = size.width;
    double height = size.height;
    // Check if dimensions match in either orientation
    bool isSelected = (_width == width && _height == height) ||
        (_width == height && _height == width.toDouble() && _isLandscape);

    return InkWell(
      onTap: () {
        setState(() {
          // Set dimensions based on current orientation
          if (_isLandscape && label != 'Desktop') {
            _width = height.toDouble();
            _height = width.toDouble();
          } else {
            _width = width.toDouble();
            _height = height.toDouble();
          }
          _currentDevice = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? PixelTheme.lightBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? PixelTheme.primaryBlue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              label == 'iPad'
                  ? Icons.tablet
                  : label == 'Desktop'
                      ? Icons.desktop_mac_outlined
                      : Icons.phone_iphone,
              size: 24,
              color: isSelected
                  ? PixelTheme.primaryBlue
                  : PixelTheme.secondaryText,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? PixelTheme.primaryBlue
                    : PixelTheme.secondaryText,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a component size button
  Widget _buildSizeButton(Size size, String label) {
    final width = size.width;
    final height = size.height;

    // Check if this size is currently selected (approximately)
    bool isSelected =
        (_width - width).abs() < 10 && (_height - height).abs() < 10;

    return InkWell(
      onTap: () {
        setState(() {
          _width = width;
          _height = height;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? PixelTheme.lightBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? PixelTheme.primaryBlue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? PixelTheme.primaryBlue : PixelTheme.secondaryText,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
