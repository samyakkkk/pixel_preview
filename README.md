<h1 align="center">Pixel Preview</h1>

<p align="center">A powerful Flutter package for visualizing and testing UI components and screens in isolation</p>

<!-- <p align="center"> -->
  <!-- <a href="https://pub.dev/packages/pixel_preview">
    <img src="https://img.shields.io/pub/v/pixel_preview.svg?color=0066A6" alt="Pub Version" />
  </a>
  <a href="https://github.com/samyakkkk/pixel_preview/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/samyakkkk/pixel_preview?color=7DDFD3" alt="License" />
  </a>
  <a href="https://github.com/samyakkkk/pixel_preview/stargazers">
    <img src="https://img.shields.io/github/stars/samyakkkk/pixel_preview?style=flat&color=F05042" alt="Stars" />
  </a>
</p> -->

<div align="center">
  <p><b>Component Preview</b></p>
  <img src="https://github.com/samyakkkk/pixel_preview/raw/main/media/component-preview.gif" alt="Component Preview" width="80%" />
  <p><b>Screen Preview</b></p>
  <img src="https://github.com/samyakkkk/pixel_preview/raw/main/media/screen-preview.gif" alt="Screen Preview" width="80%" />
</div>

## ✨ Features

- **Interactive Preview Environment**: View your Flutter widgets in an isolated environment with resizable frames
- **Component & Screen Modes**: Preview individual components or entire screens with specialized settings for each
- **Customizable Background**: Toggle between light, dark, and transparent backgrounds to ensure your UI works in all themes
- **Responsive Testing**: Resize components with intuitive handles to test responsiveness
- **Device Presets**: Test screens on common device sizes (iPhone, Samsung, iPad, Desktop)
- **Orientation Testing**: Switch between portrait and landscape orientations
- **Development Mode Only**: Automatically disabled in release builds for zero production impact

## 📱 Cross-Device Support

Pixel Preview works seamlessly across all devices where Flutter runs. Unlike other preview tools that may have platform limitations, you can use Pixel Preview on:

- **Desktop**: Windows, macOS, and Linux
- **Mobile**: iOS and Android phones and tablets
- **Web**: Any modern browser

This cross-platform capability means you can preview your UI components and screens on the same device you're developing on, regardless of what that device is. The preview environment automatically adapts to your screen size, providing a consistent experience across all platforms.

## 🚀 Getting Started

Add PixelPreview to your `pubspec.yaml`:

```bash
flutter pub add pixel_preview
```

Import the package in your Dart code:

```dart
import 'package:pixel_preview/pixel_preview.dart';
```

## 📱 Usage

### Previewing a Component

Wrap any widget with `PixelPreview` to create an interactive preview environment:

```dart
PixelPreview(
  kind: PixelKind.component,
  child: YourCustomWidget(),
)
```

The component preview mode provides:
- Background color options (light/dark/transparent)
- Resizable canvas with drag handles
- Current size display

### Previewing a Screen

For full screens, use the screen mode which provides device size presets:

```dart
PixelPreview(
  kind: PixelKind.screen,
  child: YourScreenWidget(),
)
```

The screen preview mode provides:
- Preset device sizes (iPhone, Samsung, iPad, Desktop)
- Orientation switching (portrait/landscape)
- Resizable canvas with drag handles
- Current size display

### Disabling in Production

PixelPreview is automatically disabled in release mode, but you can explicitly control this behavior:

```dart
PixelPreview(
  kind: PixelKind.component,
  enabled: kDebugMode, // Only enabled in debug mode
  child: YourWidget(),
)
```

## 📚 Example

Check out the `/example` folder for a complete implementation showing both component and screen previews:

```dart
// Component example
PixelPreview(
  kind: PixelKind.component,
  child: ResponsiveAppComponent(
    title: 'Feature Card',
    description: 'A responsive component that adapts to various constraint sizes.',
    icon: Icons.star,
    onTap: () {},
  ),
)

// Screen example
PixelPreview(
  kind: PixelKind.screen,
  child: ResponsiveScreen(
    title: "Dashboard",
  ),
)
```

## 🔄 Why Pixel Preview?

<table>
  <tr>
    <th>Feature</th>
    <th>Pixel Preview</th>
    <th>Other Preview Tools</th>
  </tr>
  <tr>
    <td>Cross-platform support</td>
    <td>✅ All platforms where Flutter runs</td>
    <td>❌ Often limited to specific platforms</td>
  </tr>
  <tr>
    <td>Component & Screen modes</td>
    <td>✅ Specialized modes for both</td>
    <td>❌ Usually focused on just one</td>
  </tr>
  <tr>
    <td>Interactive resizing</td>
    <td>✅ Intuitive drag handles</td>
    <td>❌ Often fixed sizes only</td>
  </tr>
  <tr>
    <td>Background options</td>
    <td>✅ Light, dark, transparent</td>
    <td>❌ Limited or no options</td>
  </tr>
  <tr>
    <td>Orientation switching</td>
    <td>✅ One-click toggle</td>
    <td>❌ Often requires restart</td>
  </tr>
</table>

## ⚠️ Limitations

PixelPreview is a development tool designed to help you visualize and test your UI across different screen sizes. While it's a great way to catch responsive design issues early, it doesn't replace testing on actual devices.

For the most accurate results, we recommend:
- Using PixelPreview during development to catch obvious layout issues
- Testing on real devices or emulators before releasing
- Using automated testing tools for comprehensive coverage

## 📄 License

This package is available under the [LICENSE](LICENSE) included in the repository.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
