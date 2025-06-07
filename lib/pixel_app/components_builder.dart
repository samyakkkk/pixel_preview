import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_app/common_widgets.dart';
import 'package:pixel_preview/pixel_app/pixel_group.dart';

class IframeGridBuilder extends StatefulWidget {
  final List<PixelGroup> groups;
  const IframeGridBuilder({required this.groups, super.key});

  @override
  State<IframeGridBuilder> createState() => _IframeGridBuilderState();
}

class _IframeGridBuilderState extends State<IframeGridBuilder> {
  PixelGroup? _selectedGroup;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.groups.isNotEmpty) {
      _selectedGroup = widget.groups[0];
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGroup == null) {
      return const Center(child: Text("No groups to display."));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dropdown for group selection
              if (widget.groups.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Lighter grey background
                    border: Border.all(
                        color: Color(0xFF0747A6), width: 1.0), // Thinner border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                  
                    child: DropdownButton<PixelGroup>(
                      padding: EdgeInsets.zero,
                      value: _selectedGroup,
                      hint: const Text("Select Group"),
                      items: widget.groups.map((PixelGroup group) {
                        return DropdownMenuItem<PixelGroup>(
                          value: group,
                          child: Text(group.title, style:TextStyle(fontSize: 14),),
                        );
                      }).toList(),
                      onChanged: (PixelGroup? newValue) {
                        setState(() {
                          _selectedGroup = newValue;
                        });
                      },
                      style: Theme.of(context).textTheme.titleMedium,
                      dropdownColor: Theme.of(context).canvasColor,
                      focusColor: Theme.of(context).canvasColor,
                      
                    ),
                  ),
                )
              else if (widget.groups.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0), // Adjusted padding
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // Lighter grey background
                    border: Border.all(
                        color: Color(0xFF0747A6), width: 1.0), // Thinner border
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.groups.first.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

              // Scroll buttons
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Material(
                      child: InkWell(
                        hoverColor: Color(0xFF0747A6).withValues(alpha: 0.05),
                        splashColor: Color(0xFF0747A6).withValues(alpha: 0.15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF0747A6),
                                width: 1.0), // Thinner border
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.only(
                              left: 12.0, right: 4.0, top: 8.0, bottom: 8.0),
                          child: Center(
                            child: const Icon(Icons.arrow_back_ios,
                            size: 20,
                                color: Color(0xFF0747A6)),
                          ),
                        ),
                        onTap: () {
                          if (_scrollController.hasClients) {
                            final newOffset = _scrollController.offset -
                                280; // Adjust scroll amount as needed
                            _scrollTo(newOffset < 0 ? 0 : newOffset);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Material(
                      child: InkWell(
                        hoverColor: Color(0xFF0747A6).withValues(alpha: 0.05),
                        splashColor: Color(0xFF0747A6).withValues(alpha: 0.15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF0747A6),
                                width: 1.0), // Thinner border
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(
                              8.0), // Adjusted padding for forward arrow
                          child: Center(
                            child: const Icon(Icons.arrow_forward_ios,size: 20.0,
                                color: Color(0xFF0747A6)),
                          ),
                        ),
                        onTap: () {
                          if (_scrollController.hasClients) {
                            final maxScroll =
                                _scrollController.position.maxScrollExtent;
                            final newOffset = _scrollController.offset +
                                280; // Adjust scroll amount as needed
                            _scrollTo(
                                newOffset > maxScroll ? maxScroll : newOffset);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildGroupSection(_selectedGroup!),
        ),
      ],
    );
  }

  // Helper method to build a group section
  Widget _buildGroupSection(
    PixelGroup group,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: ListView.builder(
                  controller: _scrollController, // Assign the scroll controller
                  scrollDirection: Axis.horizontal,
                  itemCount: group.children.length,
                  itemBuilder: (context, index) {
                    final child = group.children[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: SizedBox(
                          height: constraints.maxHeight,
                          width:
                              constraints.maxHeight * group.preset.aspectRatio,
                          child: GridItem(child: child)),
                    );
                  }),
            );
          }),
        )
      ],
    );
  }
}

class GridBuilder extends StatefulWidget {
  final List<PixelGroup> groups;
  final double gridSpacing;
  final bool iFrameMode; // This flag now controls item layout within groups

  const GridBuilder(
      {super.key,
      required this.groups,
      required this.gridSpacing,
      this.iFrameMode = false});

  @override
  State<GridBuilder> createState() => _GridBuilderState();
}

class _GridBuilderState extends State<GridBuilder> {
  @override
  Widget build(BuildContext context) {
    // The main layout is always a vertical list of groups
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine columns for vertical grid layout (when isHorizontal is false)
        int columnsForVerticalGrid = 2;
        if (constraints.maxWidth >= 1600) {
          columnsForVerticalGrid = 5;
        } else if (constraints.maxWidth >= 1200) {
          columnsForVerticalGrid = 4;
        } else if (constraints.maxWidth >= 800) {
          columnsForVerticalGrid = 3;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.groups.map((group) => _buildGroupSection(
                  group,
                  columnsForVerticalGrid, // Used if group items are not horizontal
                  widget.iFrameMode, // Determines item layout within this group
                  constraints
                      .maxHeight, // Pass available height from LayoutBuilder
                )),
          ],
        );
      },
    );
  }

  // Helper method to build a group section
  Widget _buildGroupSection(
    PixelGroup group,
    int columnsForVerticalGrid, // Number of columns if items are in a grid
    bool isGroupHorizontal, // True if items in this group scroll horizontally
    double availableParentHeight, // Max height from the parent LayoutBuilder
  ) {
    double horizontalItemListHeight;
    if (isGroupHorizontal) {
      // Calculate height for the horizontal list as a fraction of available parent height.
      // This makes the row height responsive to the space given to GridBuilder.

      horizontalItemListHeight =
          availableParentHeight - widget.gridSpacing * 1.5;
    } else {
      // This value is not used for vertical grid, but initialize to avoid errors.
      horizontalItemListHeight = 0;
    }

    return Padding(
      padding: EdgeInsets.only(
          bottom: widget.gridSpacing * 1.5,
          left: widget.gridSpacing / 3,
          right: widget.gridSpacing / 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group title
          if (!widget.iFrameMode)
            Padding(
              padding: EdgeInsets.only(
                  bottom: widget.gridSpacing, top: widget.gridSpacing / 2),
              child: Text(
                group.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

          // Group children
          if (isGroupHorizontal)
            SizedBox(
              height: horizontalItemListHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: group.children.length,
                itemBuilder: (context, index) {
                  final child = group.children[index];
                  // Calculate item width based on aspect ratio and fixed height
                  final itemWidth =
                      horizontalItemListHeight * group.preset.aspectRatio;
                  return Padding(
                    padding: EdgeInsets.only(right: widget.gridSpacing),
                    child: SizedBox(
                      width: itemWidth,
                      height:
                          horizontalItemListHeight, // Ensure item respects the row height
                      child: GridItem(child: child),
                    ),
                  );
                },
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnsForVerticalGrid,
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
