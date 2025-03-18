import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_preview/frame_widget.dart';
import 'package:pixel_preview/pixel_theme.dart';
import 'package:pixel_preview/screenshot_thumbnail.dart';

/// Predefined component sizes
enum ComponentSize {
  small,
  medium,
  large,
}

/// Component size dimensions
class ComponentSizes {
  static const Map<ComponentSize, Map<String, double>> dimensions = {
    ComponentSize.small: {'width': 300.0, 'height': 200.0},
    ComponentSize.medium: {'width': 450.0, 'height': 300.0},
    ComponentSize.large: {'width': 750.0, 'height': 500.0},
  };
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

/// Device dimensions mapping
class DeviceDimensions {
  static const Map<DeviceType, Map<String, dynamic>> dimensions = {
    DeviceType.iPhoneSE: {
      'name': 'iPhone SE',
      'width': 375.0,
      'height': 667.0,
    },
    DeviceType.iPhone16: {
      'name': 'iPhone 16',
      'width': 393.0,
      'height': 852.0,
    },
    DeviceType.iPhone16ProMax: {
      'name': 'iPhone 16 Pro Max',
      'width': 440.0,
      'height': 956.0,
    },
    DeviceType.samsungGalaxyS25: {
      'name': 'Samsung Galaxy S25',
      'width': 415.0,
      'height': 900.0,
    },
    DeviceType.iPad: {
      'name': 'iPad',
      'width': 768.0,
      'height': 1024.0,
    },
    DeviceType.desktop: {
      'name': 'Desktop',
      'width': 1440.0,
      'height': 960.0,
    },
  };
}

/// Abstract base class for all presets
abstract class Presets {
  const Presets();

  /// Returns true if this preset is for a screen, false for a component
  bool get isScreen;

  /// Get the initial width for this preset
  double get initialWidth;

  /// Get the initial height for this preset
  double get initialHeight;

  /// Get the initial background color
  Color get backgroundColor => Colors.white;
}

/// Preset configuration for component previews
class ComponentPresets extends Presets {
  /// Initial size of the component
  final ComponentSize size;

  /// Initial background color
  @override
  final Color backgroundColor;

  const ComponentPresets({
    this.size = ComponentSize.medium,
    this.backgroundColor = Colors.white,
  });

  @override
  bool get isScreen => false;

  @override
  double get initialWidth => ComponentSizes.dimensions[size]!['width']!;

  @override
  double get initialHeight => ComponentSizes.dimensions[size]!['height']!;
}

/// Preset configuration for screen previews
class ScreenPresets extends Presets {
  /// Initial device type
  final DeviceType deviceType;

  /// Initial orientation (true for landscape, false for portrait)
  final bool isLandscape;

  const ScreenPresets({
    this.deviceType = DeviceType.iPhone16,
    this.isLandscape = false,
  });

  @override
  bool get isScreen => true;

  @override
  double get initialWidth {
    final dimensions = DeviceDimensions.dimensions[deviceType]!;
    return isLandscape ? dimensions['height'] : dimensions['width'];
  }

  @override
  double get initialHeight {
    final dimensions = DeviceDimensions.dimensions[deviceType]!;
    return isLandscape ? dimensions['width'] : dimensions['height'];
  }

  /// Get the device name
  String get deviceName => DeviceDimensions.dimensions[deviceType]!['name'];
}

class PixelPreview extends StatefulWidget {
  final Widget child;
  final bool enabled;

  /// When true, the sidebar with component options will be hidden.
  /// This is useful for thumbnail displays or when embedding in a grid.
  final bool thumbnailMode;

  /// Preset configuration for this preview
  /// The type of preset (ComponentPresets or ScreenPresets) determines
  /// whether this is a component or screen preview
  final Presets presets;

  const PixelPreview({
    super.key,
    required this.child,
    required this.presets,
    this.enabled = !kReleaseMode,
    this.thumbnailMode = false,
  });

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
  }

  // Sidebar state
  bool _sidebarExpanded = false;

  // Orientation state
  bool _isLandscape = false;
  String _currentDevice = '';

  @override
  Widget build(BuildContext context) {
    // If preview is disabled, just return the child widget
    if (!widget.enabled) {
      return widget.child;
    }

    // If thumbnail mode is enabled, return a simplified version without the sidebar
    if (widget.thumbnailMode) {
      return _buildThumbnailView();
    }

    // Determine if we're in a mobile view
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isMobile = screenSize.width < 600;
    if (isMobile) {
      return Scaffold(
        backgroundColor: PixelTheme.canvasBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.screen_lock_portrait,
                  size: 50,
                  color: PixelTheme.primaryText,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Please switch to landscape mode to use Pixel Preview.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: PixelTheme.primaryText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                    child: widget.child,
                  ),
                ),

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
          children: [
            _buildSizeButton(ComponentSize.small),
            _buildSizeButton(ComponentSize.medium),
            _buildSizeButton(ComponentSize.large),
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

  /// Builds a simplified view for thumbnail mode without the sidebar
  Widget _buildThumbnailView() {
    late final double thumbnailWidth;
    late final double thumbnailHeight;

    if (widget.presets.isScreen) {
      thumbnailWidth = 393.0;
      thumbnailHeight = 852.0;
    } else {
      thumbnailWidth = 300.0;
      thumbnailHeight = 200.0;
    }

    // Use actual widget size for rendering
    double renderWidth = widget.presets.initialWidth;
    double renderHeight = widget.presets.initialHeight;

    return ScreenshotThumbnailBuilder(
      backgroundColor: _backgroundColor,
      renderWidth: renderWidth,
      renderHeight: renderHeight,
      // thumbnailWidth: thumbnailWidth,
      // thumbnailHeight: thumbnailHeight,
      onTap: () {
        // Open the full preview when thumbnail is tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(widget.presets.isScreen
                    ? 'Screen Preview'
                    : 'Component Preview'),
                backgroundColor: PixelTheme.primaryBlue,
              ),
              body: PixelPreview(
                presets: widget.presets,
                thumbnailMode: false,
                child: widget.child, // Full preview mode
              ),
            ),
          ),
        );
      },
      child: widget.child,
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
          children: [
            // Latest iPhone models (2024-2025) - 3 varying sizes
            _buildDeviceButton('iPhone SE', 375, 667),
            _buildDeviceButton('iPhone 16', 393, 852),
            _buildDeviceButton('iPhone 16 Pro Max', 440, 956),

            // // Other devices
            // _buildDeviceButton('Pixel 4', 393, 851),
            // _buildDeviceButton('Pixel 9 Pro XL', 443, 985),
            // _buildDeviceButton('Pixel 9', 410, 919),
            _buildDeviceButton('Samsung Galaxy S25', 415, 900),
            _buildDeviceButton('iPad', 768, 1024),
            _buildDeviceButton('Desktop', 1440, 960),
          ],
        ),

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
  Widget _buildDeviceButton(String label, int width, int height) {
    // Check if dimensions match in either orientation
    bool isSelected =
        (_width == width.toDouble() && _height == height.toDouble()) ||
            (_width == height.toDouble() &&
                _height == width.toDouble() &&
                _isLandscape);

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
  Widget _buildSizeButton(ComponentSize size) {
    // Get the dimensions for this size
    final dimensions = ComponentSizes.dimensions[size]!;
    final width = dimensions['width']!;
    final height = dimensions['height']!;

    // Check if this size is currently selected (approximately)
    bool isSelected =
        (_width - width).abs() < 10 && (_height - height).abs() < 10;

    // Get label for the button
    String label;
    switch (size) {
      case ComponentSize.small:
        label = 'S (${width.toInt()}×${height.toInt()})';
        break;
      case ComponentSize.medium:
        label = 'M (${width.toInt()}×${height.toInt()})';
        break;
      case ComponentSize.large:
        label = 'L (${width.toInt()}×${height.toInt()})';
        break;
    }

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
              ? PixelTheme.lightBlue.withOpacity(0.2)
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
