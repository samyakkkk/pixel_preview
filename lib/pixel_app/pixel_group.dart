import 'package:pixel_preview/pixel_preview/preview_widget.dart';

/// This allows for organizing components into logical sections within a PixelApp.
class PixelGroup {
  /// The title of the group
  final String title;

  /// The list of widgets to display in this group
  final List<PixelPreview> children;

  /// Creates a new PixelGroup.
  ///
  /// The [title] parameter is required and will be displayed as the group header.
  /// The [children] parameter should contain the widgets to display in this group,
  /// typically PixelPreview widgets.
  const PixelGroup({
    required this.title,
    required this.children,
  });

  PixelGroup get components {
    return PixelGroup(
        title: title,
        children: children.where((c) => !c.presets.isScreen).toList());
  }

  PixelGroup get screens {
    return PixelGroup(
        title: title,
        children: children.where((c) => c.presets.isScreen).toList());
  }
}
