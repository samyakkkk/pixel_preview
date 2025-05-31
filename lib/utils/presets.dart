import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart';
import 'package:pixel_preview/utils/sizes.dart';

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

  double get aspectRatio ;
}

/// Preset configuration for component previews
class ComponentPresets extends Presets {
  /// Size of the component
  final Size size;

  /// Initial background color
  @override
  final Color backgroundColor;

  const ComponentPresets({
    this.size = ComponentSizes.medium,
    this.backgroundColor = Colors.white,
  });

  @override
  bool get isScreen => false;

  @override
  double get initialWidth => size.width;

  @override
  double get initialHeight => size.height;

  @override
  double get aspectRatio => size.width/size.height;
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
    final size = dimensions['size'] as Size;
    return isLandscape ? size.height : size.width;
  }

  @override
  double get initialHeight {
    final dimensions = DeviceDimensions.dimensions[deviceType]!;
    final size = dimensions['size'] as Size;
    return isLandscape ? size.width : size.height;
  }

  /// Get the device name
  String get deviceName => DeviceDimensions.dimensions[deviceType]!['name'];

  @override
  double get aspectRatio => initialWidth/initialHeight;
}
