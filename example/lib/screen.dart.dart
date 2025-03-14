import 'package:flutter/material.dart';
import 'package:example/component.dart';

/// A responsive screen that adapts to various screen sizes.
class ResponsiveScreen extends StatefulWidget {
  final String title;

  const ResponsiveScreen({super.key, required this.title});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  int _selectedIndex = 0;

  // colors
  static const Color primaryBlue = Color(0xFF1A365D);
  static const Color lightBlue = Color(0xFF4299E1);
  static const Color coralRed = Color(0xFFFF6B6B);
  static const Color mintGreen = Color(0xFF4FD1C5);
  static const Color lightGray = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use MediaQuery to get screen size information
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
        final isSmallScreen = screenSize.width < 600;
        final isMediumScreen =
            screenSize.width >= 600 && screenSize.width < 1024;
        final isLargeScreen = screenSize.width >= 1024;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            actions:
                isSmallScreen
                    ? []
                    : [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildUserAvatar(),
                      const SizedBox(width: 24),
                    ],
          ),
          drawer: isSmallScreen ? _buildDrawer() : null,
          body: Row(
            children: [
              // Side navigation for medium and large screens
              if (!isSmallScreen) _buildSideNavigation(isLargeScreen),

              // Main content area
              Expanded(
                child: _buildMainContent(
                  isSmallScreen,
                  isMediumScreen,
                  isLargeScreen,
                ),
              ),

              // Right sidebar for large screens
              if (isLargeScreen) _buildRightSidebar(),
            ],
          ),

          bottomNavigationBar: isSmallScreen ? _buildBottomNavigation() : null,
          floatingActionButton: FloatingActionButton(
            backgroundColor: coralRed,
            foregroundColor: Colors.white,
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildUserAvatar() {
    return const CircleAvatar(
      backgroundColor: lightBlue,
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryBlue),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUserAvatar(),
                  const SizedBox(height: 16),
                  const Text(
                    'PixelPreview Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavigationItems(),
        ],
      ),
    );
  }

  Widget _buildSideNavigation(bool isExpanded) {
    return Container(
      width: isExpanded ? 240 : 80,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          if (isExpanded)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'DASHBOARD',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          _buildNavigationItems(isCompact: !isExpanded),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isExpanded
                    ? OutlinedButton.icon(
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        side: const BorderSide(color: lightGray),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    )
                    : IconButton(
                      icon: const Icon(Icons.settings, color: primaryBlue),
                      onPressed: () {},
                    ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavigationItems({bool isCompact = false}) {
    final items = [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.analytics, 'label': 'Analytics'},
      {'icon': Icons.people, 'label': 'Users'},
      {'icon': Icons.folder, 'label': 'Projects'},
      {'icon': Icons.message, 'label': 'Messages'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedIndex == index;

        if (isCompact) {
          return Tooltip(
            message: item['label'] as String,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? lightBlue.withValues(alpha: 0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  item['icon'] as IconData,
                  color: isSelected ? lightBlue : Colors.grey,
                ),
                onPressed: () => setState(() => _selectedIndex = index),
              ),
            ),
          );
        } else {
          return ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: isSelected ? lightBlue : Colors.grey,
            ),
            title: Text(
              item['label'] as String,
              style: TextStyle(
                color: isSelected ? primaryBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            selectedTileColor: lightBlue.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () => setState(() => _selectedIndex = index),
          );
        }
      },
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: lightBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
      ],
    );
  }

  Widget _buildMainContent(
    bool isSmallScreen,
    bool isMediumScreen,
    bool isLargeScreen,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(isSmallScreen),
          const SizedBox(height: 24),
          _buildStatsSection(isSmallScreen, isMediumScreen),
          const SizedBox(height: 32),
          _buildComponentsSection(isSmallScreen, isMediumScreen, isLargeScreen),
          const SizedBox(height: 32),
          if (!isLargeScreen) _buildRecentActivitySection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to PixelPreview Dashboard',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitor your app performance and user engagement',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(bool isSmallScreen, bool isMediumScreen) {
    final statItems = [
      {
        'icon': Icons.people,
        'label': 'Users',
        'value': '2,543',
        'color': lightBlue,
      },
      {
        'icon': Icons.bar_chart,
        'label': 'Revenue',
        'value': '\$12,432',
        'color': mintGreen,
      },
      {
        'icon': Icons.trending_up,
        'label': 'Growth',
        'value': '+24%',
        'color': coralRed,
      },
      {
        'icon': Icons.star,
        'label': 'Rating',
        'value': '4.8',
        'color': Colors.amber,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: (isSmallScreen || isMediumScreen) ? 1.3 : 1.2,
      ),
      itemCount: statItems.length,
      itemBuilder: (context, index) {
        final item = statItems[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 28,
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    item['value'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   item['label'] as String,
                //   style: const TextStyle(fontSize: 14, color: Colors.black54),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComponentsSection(
    bool isSmallScreen,
    bool isMediumScreen,
    bool isLargeScreen,
  ) {
    // Create a list of sample components
    final components = [
      ResponsiveAppComponent(
        title: 'User Management',
        description: 'Manage user accounts, permissions, and roles with ease.',
        icon: Icons.people,
        onTap: () {},
      ),
      ResponsiveAppComponent(
        title: 'Analytics Dashboard',
        description:
            'Track performance metrics and user engagement in real-time.',
        icon: Icons.analytics,
        onTap: () {},
      ),
      ResponsiveAppComponent(
        title: 'Content Library',
        description: 'Organize and manage your digital assets in one place.',
        icon: Icons.folder,
        onTap: () {},
      ),
      ResponsiveAppComponent(
        title: 'Messaging System',
        description:
            'Connect with users through in-app notifications and messages.',
        icon: Icons.message,
        onTap: () {},
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: const Text(
                'Available Components',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New'),
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: lightBlue),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ResponsiveComponentGrid(
          components: components,
          spacing: isSmallScreen ? 12 : 16,
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    final activities = [
      {
        'user': 'John Doe',
        'action': 'created a new project',
        'time': '2 hours ago',
      },
      {
        'user': 'Jane Smith',
        'action': 'updated user settings',
        'time': '4 hours ago',
      },
      {
        'user': 'Mike Johnson',
        'action': 'uploaded new content',
        'time': 'Yesterday',
      },
      {
        'user': 'Sarah Williams',
        'action': 'completed onboarding',
        'time': 'Yesterday',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: lightBlue.withValues(alpha: 0.2),
                  child: Text(
                    activity['user']!.substring(0, 1),
                    style: const TextStyle(
                      color: lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: activity['user'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${activity['action']}'),
                    ],
                  ),
                ),
                subtitle: Text(
                  activity['time']!,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: lightGray, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityTimeline(),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    final activities = [
      {'user': 'John Doe', 'action': 'created a new project', 'time': '2h ago'},
      {
        'user': 'Jane Smith',
        'action': 'updated user settings',
        'time': '4h ago',
      },
      {
        'user': 'Mike Johnson',
        'action': 'uploaded new content',
        'time': 'Yesterday',
      },
      {
        'user': 'Sarah Williams',
        'action': 'completed onboarding',
        'time': 'Yesterday',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: index == 0 ? coralRed : lightGray,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index < activities.length - 1)
                    Container(width: 2, height: 40, color: lightGray),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: activity['user'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' ${activity['action']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.add_circle, 'label': 'New Project', 'color': mintGreen},
      {'icon': Icons.person_add, 'label': 'Add User', 'color': lightBlue},
      {'icon': Icons.upload_file, 'label': 'Upload File', 'color': coralRed},
      {'icon': Icons.settings, 'label': 'Settings', 'color': Colors.grey},
    ];

    return Column(
      children:
          actions.map((action) {
            return ListTile(
              leading: Icon(
                action['icon'] as IconData,
                color: action['color'] as Color,
              ),
              title: Text(
                action['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: () {},
            );
          }).toList(),
    );
  }
}
