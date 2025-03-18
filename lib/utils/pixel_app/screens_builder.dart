import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_theme.dart';
import 'package:pixel_preview/preview_widget.dart';
import 'package:pixel_preview/utils/pixel_app/components_builder.dart';
import 'package:pixel_preview/utils/pixel_app/common_widgets.dart';

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
  DeviceType? _selectedDeviceFilter;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For screens, add device type filtering
        final uniqueDeviceTypes = _getUniqueDeviceTypes(widget.screens);
        final filteredItems =
            _filterScreensByDeviceType(widget.screens, _selectedDeviceFilter);

        // Set default device filter if not set and we have items
        if (_selectedDeviceFilter == null && uniqueDeviceTypes.isNotEmpty) {
          // Default to iPhone16 if available, otherwise use the first device type
          _selectedDeviceFilter =
              uniqueDeviceTypes.contains(DeviceType.iPhone16)
                  ? DeviceType.iPhone16
                  : uniqueDeviceTypes.first;
        }

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
        print("filtered screens :${filteredItems.length}");

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
                      children: uniqueDeviceTypes.map((deviceType) {
                        final deviceInfo =
                            DeviceDimensions.dimensions[deviceType]!;
                        final deviceName = deviceInfo['name'] as String;

                        return FilterChip(
                          label: Text(deviceName),
                          selected: _selectedDeviceFilter == deviceType,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDeviceFilter =
                                  selected ? deviceType : null;
                            });
                          },
                          selectedColor: PixelTheme.lightBlue.withOpacity(0.3),
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
                      child: filteredItems.isEmpty
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
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return GridItem(child: filteredItems[index]);
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

  // Get all unique device types used in the screens
  List<DeviceType> _getUniqueDeviceTypes(List<Widget> screens) {
    final deviceTypes = <DeviceType>{};

    for (final screen in screens) {
      final deviceType = _getDeviceType(screen);
      if (deviceType != null) {
        deviceTypes.add(deviceType);
      }
    }

    // Always include iPhone16 as default if available
    if (deviceTypes.isNotEmpty && !deviceTypes.contains(DeviceType.iPhone16)) {
      deviceTypes.add(DeviceType.iPhone16);
    }

    return deviceTypes.toList();
  }

  // Filter screens by device type
  List<PixelPreview> _filterScreensByDeviceType(
      List<Widget> screens, DeviceType? deviceType) {
    if (deviceType == null) {
      return List<PixelPreview>.from(screens);
    }

    return List<PixelPreview>.from(screens.where((screen) {
      final screenDeviceType = _getDeviceType(screen);
      return screenDeviceType == deviceType;
    }).toList());
  }

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
