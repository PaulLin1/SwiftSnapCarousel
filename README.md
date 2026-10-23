# SnapCarousel

A horizontal snap carousel for SwiftUI.

![Cluster demo](media/cluster-demo.gif)

## Requirements

- macOS 14+ (`.scrollPosition`, `.scrollTargetLayout`, `.contentMargins`)
- macOS 15+ for the drag‑gating polish — on 14 the carousel still works, cards
  just stay expanded during a drag (they never overlap)
- Swift 5.9 / Xcode 16

## Installation

Swift Package Manager:

```swift
.package(url: "https://github.com/<you>/SnapCarousel.git", from: "1.0.0")
```

```swift
.target(name: "MyApp", dependencies: [
    .product(name: "SnapCarousel", target: "SnapCarousel")
])
```

## Usage

```swift
import SnapCarousel

struct WallpaperPicker: View {
    @State private var selection: Int? = 0          // index of the centred card

    var body: some View {
        SnapCarouselView(wallpapers, selection: $selection) { wallpaper, isExpanded in
            WallpaperCard(wallpaper: wallpaper, isExpanded: isExpanded)
        }
    }
}
```

The closure is handed each item and a `Bool` that is `true` for the centred,
settled card. Render whatever you want for either state.

## Demos

Two demos of the same component, switchable from a segmented control:

```bash
swift run SnapCarouselDemos
```

## More Info

Detailed writeup at linpaul.com/portfolio/snap-carousel
