import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/common_widgets.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart';
import 'package:pixel_preview/utils/pixel_theme.dart';
import 'package:pixel_preview/utils/presets.dart';
import 'package:pixel_preview/utils/sizes.dart';

class ScreensBuilder extends StatefulWidget {
  final List<PixelPreview> screens;
  final double gridSpacing;
  const ScreensBuilder(
      {super.key, required this.screens, required this.gridSpacing});
  @override
  State<ScreensBuilder> createState() => _ScreensBuilderState();
}

class _ScreensBuilderState extends State<ScreensBuilder> {
  // Device filter state
  DeviceType _selectedDeviceFilter = DeviceType.iPad;

  // Map to store screens by device type
  final Map<DeviceType, List<PixelPreview>> _screensByDeviceType = {};
  List<DeviceType> _uniqueDeviceTypes = [];
  List<PixelPreview> _displayScreens = [];

  @override
  void initState() {
    super.initState();
    _processScreens();
  }

  @override
  void didUpdateWidget(ScreensBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screens != widget.screens) {
      _processScreens();
    }
  }

  // Process screens and organize them by device type
  void _processScreens() {
    _screensByDeviceType.clear();

    // Get all unique device types and organize screens by device type
    final Set<DeviceType> deviceTypesSet = {};

    for (final screen in widget.screens) {
      final deviceType = _getDeviceType(screen);
      if (deviceType != null) {
        deviceTypesSet.add(deviceType);

        // Add screen to the appropriate list in the map
        if (!_screensByDeviceType.containsKey(deviceType)) {
          _screensByDeviceType[deviceType] = [];
        }
        _screensByDeviceType[deviceType]!.add(screen);
      }
    }

    // Set default device filter if not set and we have items
    if (_uniqueDeviceTypes.isNotEmpty) {
      // Default to iPhone16 if available, otherwise use the first device type
      if (deviceTypesSet.contains(DeviceType.iPhone16)) {
        _selectedDeviceFilter = DeviceType.iPhone16;
      } else if (deviceTypesSet.isNotEmpty) {
        _selectedDeviceFilter = deviceTypesSet.first;
      }
    }

    _uniqueDeviceTypes = deviceTypesSet.toList();
    _displayScreens = _screensByDeviceType[_selectedDeviceFilter]!;

    // Ensure the widget rebuilds with the new data
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get filtered items based on selected device type

        // Determine columns based on selected device type
        int columns = _getColumnsForDeviceType(
            _selectedDeviceFilter, constraints.maxWidth);

        // Fixed aspect ratio based on the thumbnail sizes for screens
        double aspectRatio = 0.46; // Default phone aspect ratio

        // Adjust aspect ratio for different device types
        if (_selectedDeviceFilter == DeviceType.desktop) {
          aspectRatio = 1.5; // Desktop has wider aspect ratio
        } else if (_selectedDeviceFilter == DeviceType.iPad) {
          aspectRatio = 0.75; // iPad has more square aspect ratio
        }
        return widget.screens.isEmpty
            ? EmptyState(isScreen: true)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device type filter chips
                  Padding(
                    padding: EdgeInsets.fromLTRB(widget.gridSpacing,
                        widget.gridSpacing, widget.gridSpacing, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _uniqueDeviceTypes.map((deviceType) {
                        final deviceInfo =
                            DeviceDimensions.dimensions[deviceType]!;
                        final deviceName = deviceInfo['name'] as String;

                        return FilterChip(
                          label: Text(deviceName),
                          selected: _selectedDeviceFilter == deviceType,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDeviceFilter =
                                  selected ? deviceType : _selectedDeviceFilter;
                              _displayScreens =
                                  _screensByDeviceType[_selectedDeviceFilter]!;
                            });
                          },
                          selectedColor: PixelTheme.lightBlue.withValues(alpha: 0.3),
                          checkmarkColor: PixelTheme.primaryBlue,
                          labelStyle: TextStyle(
                            color: _selectedDeviceFilter == deviceType
                                ? PixelTheme.primaryBlue
                                : PixelTheme.secondaryText,
                            fontWeight: _selectedDeviceFilter == deviceType
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Grid of filtered screens
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(widget.gridSpacing),
                      child: _displayScreens.isEmpty
                          ? Center(
                              child: Text(
                                'No screens found for ${DeviceDimensions.dimensions[_selectedDeviceFilter]?["name"] ?? "selected device"}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: PixelTheme.secondaryText,
                                ),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: widget.gridSpacing,
                                mainAxisSpacing: widget.gridSpacing,
                                childAspectRatio: aspectRatio,
                              ),
                              itemCount: _displayScreens.length,
                              itemBuilder: (context, index) {
                                return GridItem(child: _displayScreens[index]);
                              },
                            ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  // Get device type from a widget (if it's a PixelPreview with ScreenPresets)
  DeviceType? _getDeviceType(Widget widget) {
    if (widget is PixelPreview && widget.presets is ScreenPresets) {
      return (widget.presets as ScreenPresets).deviceType;
    }
    return null;
  }

  // These methods are no longer needed as the filtering is done in initState
  // and the results are stored in _screensByDeviceType map

  // Get appropriate number of columns based on device type
  int _getColumnsForDeviceType(DeviceType? deviceType, double screenWidth) {
    // Default column count based on screen width
    int defaultColumns = 2;
    if (screenWidth >= 1200) {
      defaultColumns = 4;
    } else if (screenWidth >= 800) {
      defaultColumns = 3;
    }

    // Adjust columns based on device type
    if (deviceType == null) {
      return defaultColumns;
    }

    switch (deviceType) {
      case DeviceType.desktop:
        return 1; // Always show desktop screens in single column
      case DeviceType.iPad:
        return screenWidth >= 1200 ? 2 : 1; // Max 2 columns for iPad screens
      default:
        return defaultColumns; // Use default for phone screens
    }
  }
}
