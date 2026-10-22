//
//  DemoApp.swift
//  SnapCarouselDemos
//

import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct DemoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let devices: Devices = {
        let d = Devices()
        d.devices = sampleDevices
        return d
    }()

    var body: some Scene {
        WindowGroup {
            DeviceClusterDemo()
                .environment(devices)
                .frame(width: 900, height: 600)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
