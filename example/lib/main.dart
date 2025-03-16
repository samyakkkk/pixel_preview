import 'package:example/component.dart';
import 'package:example/screen.dart.dart';
import 'package:flutter/material.dart';
import 'package:pixel_preview/pixel_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color primaryBlue = Color(0xFF1A365D);
  // static const Color lightBlue = Color(0xFF4299E1);
  // static const Color coralRed = Color(0xFFFF6B6B);
  bool component = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Preview Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: PixelApp(
          title: 'Pixel UI Kit',
          // Using a single widgets list instead of separate components and screens lists
          widgets: [
            // Component 1
            PixelPreview(
              kind: PixelKind.component,
              child: ResponsiveAppComponent(
                title: 'Dashboard Card',
                description: 'A responsive card component for dashboards.',
                icon: Icons.dashboard,
                onTap: () {},
              ),
            ),
            // Component 2
            PixelPreview(
              kind: PixelKind.component,
              child: ResponsiveAppComponent(
                title: 'Analytics Widget',
                description: 'Data visualization component with responsive layout.',
                icon: Icons.analytics,
                onTap: () {},
              ),
            ),
            // Component 3
            PixelPreview(
              kind: PixelKind.component,
              child: ResponsiveAppComponent(
                title: 'User Profile',
                description: 'User profile card with adaptive sizing.',
                icon: Icons.person,
                onTap: () {},
              ),
            ),
            // Component 4
            PixelPreview(
              kind: PixelKind.component,
              child: ResponsiveAppComponent(
                title: 'Settings Panel',
                description: 'Configuration panel with responsive layout.',
                icon: Icons.settings,
                onTap: () {},
              ),
            ),
            // Screen 1
            PixelPreview(
              kind: PixelKind.screen,
              child: ResponsiveScreen(title: "Dashboard"),
            ),
            // Screen 2
            PixelPreview(
              kind: PixelKind.screen,
              child: ResponsiveScreen(title: "Analytics"),
            ),
            // Screen 3
            PixelPreview(
              kind: PixelKind.screen,
              child: ResponsiveScreen(title: "User Profile"),
            ),
          ],
          // Customize grid layout
          gridSpacing: 20.0,
          largeScreenColumns: 4,
          mediumScreenColumns: 3,
          smallScreenColumns: 2,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
