import 'package:flutter/material.dart';
import 'package:pixel_preview/preview_widget.dart';
import 'package:pixel_preview/pixel_theme.dart';

/// A widget that displays a collection of PixelPreview components and screens in a grid layout.
/// 
/// This widget provides a tabbed interface to separate components and screens,
/// and displays them in a responsive grid layout optimized for larger landscape screens.
/// 
/// Note: The widgets provided to this class should already be wrapped in PixelPreview widgets.
class PixelApp extends StatefulWidget {
  /// List of components (already wrapped in PixelPreview) to display in the Components tab
  final List<Widget> components;
  
  /// List of screens (already wrapped in PixelPreview) to display in the Screens tab
  final List<Widget> screens;
  
  /// Optional list of all widgets (components and screens) to display
  /// If provided, this will be used instead of the separate components and screens lists
  final List<Widget>? widgets;
  
  /// Optional title for the app
  final String title;
  
  /// Optional custom theme for the app
  final ThemeData? theme;
  
  /// Optional spacing between grid items
  final double gridSpacing;
  
  /// Optional number of columns for the grid on large screens
  final int largeScreenColumns;
  
  /// Optional number of columns for the grid on medium screens
  final int mediumScreenColumns;
  
  /// Optional number of columns for the grid on small screens
  final int smallScreenColumns;

  const PixelApp({
    super.key,
    this.components = const [],
    this.screens = const [],
    this.widgets,
    this.title = 'Pixel Preview',
    this.theme,
    this.gridSpacing = 16.0,
    this.largeScreenColumns = 3,
    this.mediumScreenColumns = 2,
    this.smallScreenColumns = 1,
  });

  @override
  State<PixelApp> createState() => _PixelAppState();
}

class _PixelAppState extends State<PixelApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: PixelTheme.primaryBlue),
      useMaterial3: true,
    );

    // If widgets are provided, filter them by kind
    List<Widget> componentWidgets = widget.components;
    List<Widget> screenWidgets = widget.screens;

    if (widget.widgets != null) {
      componentWidgets = widget.widgets!.where((w) {
        if (w is PixelPreview) {
          return w.kind == PixelKind.component;
        }
        return false;
      }).toList();

      screenWidgets = widget.widgets!.where((w) {
        if (w is PixelPreview) {
          return w.kind == PixelKind.screen;
        }
        return false;
      }).toList();
    }

    return MaterialApp(
      title: widget.title,
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: PixelTheme.primaryBlue,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Components', icon: Icon(Icons.widgets)),
              Tab(text: 'Screens', icon: Icon(Icons.phone_android)),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildGridView(componentWidgets, PixelKind.component),
            _buildGridView(screenWidgets, PixelKind.screen),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Widget> items, PixelKind kind) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns based on screen width
        int columns = widget.smallScreenColumns;
        if (constraints.maxWidth >= 1200) {
          columns = widget.largeScreenColumns;
        } else if (constraints.maxWidth >= 800) {
          columns = widget.mediumScreenColumns;
        }
        
        // Fixed aspect ratio based on the thumbnail sizes
        // Component: 300 x 200 = 1.5 aspect ratio
        // Screen: 393 x 852 = 0.46 aspect ratio
        double aspectRatio = kind == PixelKind.component ? 1.5 : 0.46;

        return items.isEmpty
            ? _buildEmptyState(kind)
            : Padding(
                padding: EdgeInsets.all(widget.gridSpacing),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: widget.gridSpacing,
                    mainAxisSpacing: widget.gridSpacing,
                    childAspectRatio: aspectRatio, // Different aspect ratios for components vs screens
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildGridItem(items[index], kind);
                  },
                ),
              );
      },
    );
  }

  Widget _buildGridItem(Widget child, PixelKind kind) {
    // Ensure thumbnail mode is enabled for all PixelPreview widgets
    Widget thumbnailChild = child;
    if (child is PixelPreview && !child.thumbnailMode) {
      thumbnailChild = PixelPreview(
        kind: child.kind,
        child: child.child,
        enabled: child.enabled,
        thumbnailMode: true, // Force thumbnail mode
      );
    }
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(widget.gridSpacing / 2),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: PixelTheme.lightGray, width: 1),
      ),
      child: thumbnailChild,
    );
  }

  Widget _buildEmptyState(PixelKind kind) {
    final String itemType = kind == PixelKind.component ? 'components' : 'screens';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            kind == PixelKind.component ? Icons.widgets_outlined : Icons.phone_android_outlined,
            size: 64,
            color: PixelTheme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No $itemType added yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PixelTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add $itemType to see them displayed here',
            style: TextStyle(
              fontSize: 16,
              color: PixelTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

/// A helper class to create a PixelApp with a builder pattern
class PixelAppBuilder {
  final List<Widget> _components = [];
  final List<Widget> _screens = [];
  final List<Widget> _widgets = [];
  bool _useWidgets = false;
  String _title = 'Pixel Preview';
  ThemeData? _theme;
  double _gridSpacing = 16.0;
  int _largeScreenColumns = 3;
  int _mediumScreenColumns = 2;
  int _smallScreenColumns = 1;

  /// Add a component (already wrapped in PixelPreview) to the Components tab
  PixelAppBuilder addComponent(Widget component) {
    _components.add(component);
    return this;
  }

  /// Add multiple components (already wrapped in PixelPreview) to the Components tab
  PixelAppBuilder addComponents(List<Widget> components) {
    _components.addAll(components);
    return this;
  }

  /// Add a screen (already wrapped in PixelPreview) to the Screens tab
  PixelAppBuilder addScreen(Widget screen) {
    _screens.add(screen);
    return this;
  }

  /// Add multiple screens (already wrapped in PixelPreview) to the Screens tab
  PixelAppBuilder addScreens(List<Widget> screens) {
    _screens.addAll(screens);
    return this;
  }
  
  /// Add a widget (already wrapped in PixelPreview) to the widgets collection
  /// This will override the separate components and screens lists
  PixelAppBuilder addWidget(Widget widget) {
    _widgets.add(widget);
    _useWidgets = true;
    return this;
  }
  
  /// Add multiple widgets (already wrapped in PixelPreview) to the widgets collection
  /// This will override the separate components and screens lists
  PixelAppBuilder addWidgets(List<Widget> widgets) {
    _widgets.addAll(widgets);
    _useWidgets = true;
    return this;
  }

  /// Set the title for the app
  PixelAppBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  /// Set a custom theme for the app
  PixelAppBuilder setTheme(ThemeData theme) {
    _theme = theme;
    return this;
  }

  /// Set the spacing between grid items
  PixelAppBuilder setGridSpacing(double spacing) {
    _gridSpacing = spacing;
    return this;
  }

  /// Set the number of columns for different screen sizes
  PixelAppBuilder setGridColumns({
    int large = 3,
    int medium = 2,
    int small = 1,
  }) {
    _largeScreenColumns = large;
    _mediumScreenColumns = medium;
    _smallScreenColumns = small;
    return this;
  }

  /// Build and return the PixelApp
  PixelApp build() {
    return PixelApp(
      components: _useWidgets ? [] : _components,
      screens: _useWidgets ? [] : _screens,
      widgets: _useWidgets ? _widgets : null,
      title: _title,
      theme: _theme,
      gridSpacing: _gridSpacing,
      largeScreenColumns: _largeScreenColumns,
      mediumScreenColumns: _mediumScreenColumns,
      smallScreenColumns: _smallScreenColumns,
    );
  }
}
