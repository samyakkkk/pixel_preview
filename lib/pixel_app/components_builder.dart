import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/common_widgets.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';

class ComponentsBuilder extends StatefulWidget {
  final List<PixelGroup> groups;
  final double gridSpacing;

  const ComponentsBuilder(
      {super.key, required this.groups, required this.gridSpacing});

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

        // If we have groups, display them in a scrollable list

        return SingleChildScrollView(
          padding: EdgeInsets.all(widget.gridSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.groups.map(
                  (group) => _buildGroupSection(group, columns, aspectRatio)),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build a group section
  Widget _buildGroupSection(PixelGroup group, int columns, double aspectRatio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group title
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0, left: 8.0),
            child: Text(
              group.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          // Group components in a grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: widget.gridSpacing,
              mainAxisSpacing: widget.gridSpacing,
              childAspectRatio: aspectRatio,
            ),
            itemCount: group.children.length,
            itemBuilder: (context, index) {
              return GridItem(child: group.children[index]);
            },
          ),
        ],
      ),
    );
  }
}
