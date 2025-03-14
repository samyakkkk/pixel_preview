import 'package:flutter/material.dart';

/// A responsive component that adapts to various constraint sizes.
class ResponsiveAppComponent extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const ResponsiveAppComponent({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  State<ResponsiveAppComponent> createState() => _ResponsiveAppComponentState();
}

class _ResponsiveAppComponentState extends State<ResponsiveAppComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovering = false;

  static const Color primaryBlue = Color(0xFF1A365D);
  static const Color lightBlue = Color(0xFF4299E1);
  static const Color coralRed = Color(0xFFFF6B6B);
  static const Color mintGreen = Color(0xFF4FD1C5);
  static const Color lightGray = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to adapt to different constraint sizes
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine layout based on available width
        final isCompact = constraints.maxWidth < 400;
        final isMedium =
            constraints.maxWidth >= 400 && constraints.maxWidth < 700;
        final isExpanded = constraints.maxWidth >= 700;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
              decoration: BoxDecoration(
                color:
                    _isHovering
                        ? lightGray.withValues(alpha: 0.7)
                        : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: _isHovering ? lightBlue : lightGray,
                  width: 2.0,
                ),
              ),
              child: _buildLayout(isCompact, isMedium, isExpanded),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayout(bool isCompact, bool isMedium, bool isExpanded) {
    if (isCompact) {
      // Compact layout (vertical stack)
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconHeader(),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          _buildActionButton(small: true),
        ],
      );
    } else if (isMedium) {
      // Medium layout (horizontal with limited description)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconHeader(size: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildActionButton(),
        ],
      );
    } else {
      // Expanded layout (horizontal with full description and extra features)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconHeader(size: 80),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                _buildFeatureTags(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _buildActionButton(expanded: true),
        ],
      );
    }
  }

  Widget _buildIconHeader({double size = 50}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: coralRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(widget.icon, size: size * 0.6, color: coralRed),
    );
  }

  Widget _buildActionButton({bool small = false, bool expanded = false}) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal:
              small
                  ? 12
                  : expanded
                  ? 24
                  : 16,
          vertical:
              small
                  ? 8
                  : expanded
                  ? 16
                  : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        expanded ? 'Learn More' : 'View',
        style: TextStyle(
          fontSize:
              small
                  ? 12
                  : expanded
                  ? 16
                  : 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeatureTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFeatureTag('Interactive', mintGreen),
        _buildFeatureTag('Responsive', lightBlue),
        _buildFeatureTag('Customizable', coralRed),
      ],
    );
  }

  Widget _buildFeatureTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// A grid of responsive app components that adapts to the available space.
/// This demonstrates how the ResponsiveAppComponent can be used in a collection.
class ResponsiveComponentGrid extends StatelessWidget {
  final List<ResponsiveAppComponent> components;
  final double spacing;

  const ResponsiveComponentGrid({
    super.key,
    required this.components,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on available width
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1; // Single column for small screens
        } else if (constraints.maxWidth < 700) {
          crossAxisCount = 2; // Two columns for medium screens
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 3; // Three columns for large screens
        } else {
          crossAxisCount = 4; // Four columns for extra large screens
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio:
                crossAxisCount == 1
                    ? 1.6
                    : crossAxisCount == 2
                    ? 1.2
                    : crossAxisCount == 3
                    ? 1.1
                    : 1,
          ),
          itemCount: components.length,
          itemBuilder: (context, index) => components[index],
        );
      },
    );
  }
}
