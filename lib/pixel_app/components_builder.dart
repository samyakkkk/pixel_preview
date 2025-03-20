import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_theme.dart';
import 'package:pixel_preview/preview_widget.dart';
import 'package:pixel_preview/pixel_app/common_widgets.dart';

class ComponentsBuilder extends StatefulWidget {
  final List<PixelPreview> components;
  final double gridSpacing;
  const ComponentsBuilder(
      {super.key, required this.components, required this.gridSpacing});

  @override
  State<ComponentsBuilder> createState() => _ComponentsBuilderState();
}

class _ComponentsBuilderState extends State<ComponentsBuilder> {
  final double gridSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For components, use the original grid layout
        int columns = 2;
        if (constraints.maxWidth >= 1200) {
          columns = 4;
        } else if (constraints.maxWidth >= 800) {
          columns = 3;
        }

        double aspectRatio = 1.5; // Component aspect ratio

        return widget.components.isEmpty
            ? EmptyState(isScreen: false)
            : Padding(
                padding: EdgeInsets.all(widget.gridSpacing),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: widget.gridSpacing,
                    mainAxisSpacing: widget.gridSpacing,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: widget.components.length,
                  itemBuilder: (context, index) {
                    return GridItem(child: widget.components[index]);
                  },
                ),
              );
      },
    );
  }
}

