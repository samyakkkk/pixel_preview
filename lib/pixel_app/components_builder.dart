import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/common_widgets.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';
import 'package:pixel_preview/utils/presets.dart';

class GridBuilder extends StatefulWidget {
  final List<PixelGroup> groups;
  final double gridSpacing;

  const GridBuilder(
      {super.key, required this.groups, required this.gridSpacing});

  @override
  State<GridBuilder> createState() => _GridBuilderState();
}

class _GridBuilderState extends State<GridBuilder> {
  final double gridSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For components, use the original grid layout
        int columns = 2;
        if (constraints.maxWidth >= 1600) {
          columns = 5;
        } else if (constraints.maxWidth >= 1200) {
          columns = 4;
        } else if (constraints.maxWidth >= 800) {
          columns = 3;
        }

        // If we have groups, display them in a scrollable list

        return SingleChildScrollView(
          padding: EdgeInsets.all(widget.gridSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.groups.map(
                  (group) => _buildGroupSection(group, columns)),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build a group section
  Widget _buildGroupSection(PixelGroup group, int columns) {


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
              childAspectRatio: group.preset.aspectRatio,
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
