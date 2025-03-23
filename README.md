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
- **Component & Screen Presets**: Use specialized `ComponentPresets` and `ScreenPresets` for different preview types
- **Device Type Presets**: Test screens on common device sizes (iPhone, Samsung, iPad, Desktop)
- **Responsive Testing**: Resize components with intuitive handles to test responsiveness
- **Component Library**: Create a comprehensive UI component library with `PixelApp`

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

Wrap any widget with `PixelPreview` and use `ComponentPresets` to create an interactive component preview environment:

```dart
PixelPreview(
  presets: ComponentPresets(),
  child: CardWidget(),
)
```


### Previewing a Screen

For full screens, use `ScreenPresets` which provides device size presets:

```dart
PixelPreview(
  presets: ScreenPresets(
    deviceType: DeviceType.iPhone16,  // Choose from various device types
  ),
  child: LoginScreen(),
)
```

### Disabling in Production

PixelPreview is automatically disabled in release mode, but you can explicitly control this behavior:

```dart
PixelPreview(
  presets: ComponentPresets(
    size: ComponentSizes.medium,
  ),
  enabled: kDebugMode, // Only enabled in debug mode
  child: CardWidget(),
)
```

### Creating a UI Component Library with PixelApp
<p align="center">
  <img src="https://github.com/samyakkkk/pixel_preview/raw/main/media/uikit.png" alt="UI Kit" width="80%" style="border-radius: 6px; border: 1px solid #ddd;" />
</p>

`PixelApp` allows you to create a comprehensive UI component library by displaying all your components and screens(support soon) together in a responsive grid layout:

```dart
PixelApp(
  title: 'My UI Kit',
  groups: [
    // Add your components here in groups
    PixelGroup(
      title: 'Cards',
      children: [
        PixelPreview(
          presets: ComponentPresets(
            size: ComponentSizes.medium,
          ),
          child: CardWidget(),
        ),
        // other card widgets
      ],
    ),
    PixelGroup(
      title: 'Buttons',
      children: [
        PixelPreview(
          presets: ComponentPresets(
            size: ComponentSizes.medium,
          ),
          child: ButtonWidget(),
        ),
        // other button widgets
      ],
    ),
  ],
)
```

Check out the example app's `main.dart` file for a complete implementation of a UI component library using PixelApp.

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

Hi! I'm Samyak. I'm actively developing this package and am going to add AI based UI generation features as well soon! Do give the package a like and create an [issue](https://github.com/samyakkkk/pixel_preview) to share your feedback!

All contributions are warmly welcome!
