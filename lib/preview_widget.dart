import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_preview/frame_widget.dart';
import 'package:pixel_preview/pixel_theme.dart';

enum PixelKind { component, screen }

class PixelPreview extends StatefulWidget {
  final Widget child;
  final PixelKind kind;
  final bool enabled;
  const PixelPreview({
    super.key,
    required this.kind,
    required this.child,
    this.enabled = !kReleaseMode,
  });

  @override
  State<PixelPreview> createState() => _PixelPreviewState();
}

class _PixelPreviewState extends State<PixelPreview> {
  Color _backgroundColor = PixelTheme.lightBackground;

  // Size constraints
  double _width = 500.0; // Default width up to 500px
  double _height = 333.0; // Default 2:3 height ratio

  static const double _minWidth = 100;
  static const double _minHeight = 100;
  static const double _maxWidth = 2000;
  static const double _maxHeight = 2000;

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
                              child: widget.kind == PixelKind.component
                                  ? _buildComponentSidebar()
                                  : _buildScreenSidebar(),
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
}
