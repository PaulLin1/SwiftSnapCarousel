//
//  DeviceInfo.swift
//  SnapCarouselDemos
//
//  Demo model + card for the "Mac cluster" carousel.
//  Extracted from ClusterSetupAssistant's DiscoveryView.swift.
//

import SwiftUI

struct DeviceInfo: Identifiable {
    let id = UUID()
    let deviceName: String
    let modelName: String
    let chipName: String
    let unifiedMemory: String
}

@Observable class Devices {
    var devices: [DeviceInfo] = []
}


private func deviceImage(named name: String) -> NSImage {
    let bundle = Bundle.main

    if let url = bundle.url(
        forResource: name,
        withExtension: "png",
        subdirectory: "Resources"
    ) ?? bundle.url(
        forResource: name,
        withExtension: "png"
    ),
    let image = NSImage(contentsOf: url) {
        return image
    }

    print("Could not load image: \(name).png")

    return NSImage(size: NSSize(width: 100, height: 100))
}


struct DeviceItem: View {
    let device: DeviceInfo
    var isExpanded: Bool = false

    private var horizontalPadding: CGFloat { 25 }

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(alignment: .center) {
                Image(nsImage: deviceImage(named: MacIdentifier.identifier[device.modelName]?[1] ?? "Mac Studio"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .fixedSize()
                if isExpanded {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(MacIdentifier.identifier[device.modelName]?[1] ?? "Mac")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(device.chipName)
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text(device.unifiedMemory)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .transition(
                        .opacity.combined(with: .move(edge: .trailing))
                    )
                    .frame(width: 100)
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, horizontalPadding)

            .glassEffectWithFallback()
            .animation(.easeInOut(duration: 0.25), value: isExpanded)
        }
    }
}
