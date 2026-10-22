//
//  GlassEffect.swift
//  SnapCarouselDemos
//

import SwiftUI

extension View {
    @ViewBuilder
    func glassEffectWithFallback(radius: CGFloat = .infinity) -> some View {
        if #available(macOS 27.0, *) {
            self.glassEffect(in: RoundedRectangle(cornerRadius: radius))
        } else {
            self.background(
                RoundedRectangle(cornerRadius: radius).fill(.ultraThinMaterial)
            )
        }
    }
}
