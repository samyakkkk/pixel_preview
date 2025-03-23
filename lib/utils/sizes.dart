import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview/preview_widget.dart';

/// Device dimensions mapping
class DeviceDimensions {
  static const Map<DeviceType, Map<String, dynamic>> dimensions = {
    DeviceType.iPhoneSE: {
      'name': 'iPhone SE',
      'size': Size(375.0, 667.0),
    },
    DeviceType.iPhone16: {
      'name': 'iPhone 16',
      'size': Size(393.0, 852.0),
    },
    DeviceType.iPhone16ProMax: {
      'name': 'iPhone 16 Pro Max',
      'size': Size(440.0, 956.0),
    },
    DeviceType.samsungGalaxyS25: {
      'name': 'Samsung Galaxy S25',
      'size': Size(415.0, 900.0),
    },
    DeviceType.iPad: {
      'name': 'iPad',
      'size': Size(768.0, 1024.0),
    },
    DeviceType.desktop: {
      'name': 'Desktop',
      'size': Size(1440.0, 960.0),
    },
  };
}
