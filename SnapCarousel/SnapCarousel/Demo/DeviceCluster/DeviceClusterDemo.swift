//
//  DeviceClusterDemo.swift
//  SnapCarouselDemos
//

import SwiftUI
import AppKit
import SnapCarousel

let sampleDevices: [DeviceInfo] = [
    DeviceInfo(deviceName: "Paul's Mac Studio",    modelName: "Mac13,1",  chipName: "Apple M1 Ultra", unifiedMemory: "128 GB"),
    DeviceInfo(deviceName: "Jordan's MacBook Pro", modelName: "Mac14,10", chipName: "Apple M2 Pro",   unifiedMemory: "32 GB"),
    DeviceInfo(deviceName: "Alex's MacBook Air",   modelName: "Mac14,15", chipName: "Apple M2",       unifiedMemory: "16 GB"),
    DeviceInfo(deviceName: "Sam's iMac",           modelName: "iMac21,1", chipName: "Apple M1",       unifiedMemory: "8 GB"),
    DeviceInfo(deviceName: "Taylor's Mac Studio",  modelName: "Mac13,2",  chipName: "Apple M1 Max",   unifiedMemory: "64 GB"),
]

struct DeviceClusterDemo: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer().frame(height: 45)
                Text("Setting Up a Mac Cluster").font(.largeTitle).bold().frame(height: 30)
                Spacer().frame(height: 55 - 30)

                DeviceCarousel()

                Spacer().frame(height: 30 - 20)
                Spacer()

                Text("To add a device to the Mac Cluster, make sure it is powered on with Wi-Fi enabled and has this app opened.")
                    .multilineTextAlignment(.center)
                    .frame(width: 350, height: 60)

                Spacer().frame(height: 40)
            }
            .frame(height: 460)

            ZStack {
                Text("Click continue once all your devices are connected.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 10)

            HStack {
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Text("Quit").frame(width: 100, height: 25)
                }
                .controlSize(.large)

                Button {
                    // Demo only.
                } label: {
                    Text("Continue").frame(width: 100, height: 25)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(height: 80)
        }
    }
}

private struct DeviceCarousel: View {
    @Environment(Devices.self) private var devices
    @State private var selection: Int? = 0

    var body: some View {
        SnapCarouselView(devices.devices, selection: $selection) { device, isExpanded in
            VStack(spacing: 10) {
                DeviceItem(device: device, isExpanded: isExpanded)

                Text(device.deviceName)
                    .font(.system(size: 11 * 1.2))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

#Preview {
    DeviceClusterDemo()
        .environment({ let d = Devices(); d.devices = sampleDevices; return d }())
        .frame(width: 900, height: 550)
}
