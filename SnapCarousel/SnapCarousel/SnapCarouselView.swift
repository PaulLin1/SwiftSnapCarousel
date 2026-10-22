//
//  SnapCarouselView.swift
//  SnapCarousel
//

import SwiftUI

public struct SnapCarouselView<Item, Card: View>: View {
    public static var restingCardWidth: CGFloat { 150 }
    public static var expandedCardWidth: CGFloat { 280 }

    private let items: [Item]
    @Binding private var selection: Int?
    private let scale: CGFloat
    private let animation: Animation
    private let card: (Item, Bool) -> Card

    @State private var isScrolling = false

    public init(
        _ items: [Item],
        selection: Binding<Int?>,
        scale: CGFloat = 1,
        animation: Animation = .easeInOut(duration: 0.25),
        @ViewBuilder card: @escaping (Item, Bool) -> Card
    ) {
        self.items = items
        self._selection = selection
        self.scale = max(0.1, scale)
        self.animation = animation
        self.card = card
    }

    private var cardWidth: CGFloat { Self.restingCardWidth * scale }
    private var spacing: CGFloat { 25 * scale }
    private var visibleWidth: CGFloat { 950 * scale }
    private var sideInset: CGFloat { (950 - Self.restingCardWidth) / 2 * scale }
    private var overhang: CGFloat {
        (Self.expandedCardWidth - Self.restingCardWidth) / 2 * scale
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        let expanded = selection == index && !isScrolling

                        card(item, expanded)
                            .frame(width: Self.restingCardWidth)
                            .scaleEffect(scale)
                            .frame(width: cardWidth)
                            .zIndex(expanded ? 1 : 0)
                            .id(index)
                            .offset(x: sideShift(index))
                            .animation(animation, value: sideShift(index))
                            .animation(animation, value: expanded)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, sideInset, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selection, anchor: .center)
            .frame(width: visibleWidth)
            .onUserScrollingChange { scrolling in
                withAnimation(animation) {
                    isScrolling = scrolling
                }
            }
            .modifier(EdgeFade(fraction: 0.3))
            .onAppear {
                if selection == nil, !items.isEmpty {
                    selection = 0
                }

                guard let target = selection else { return }

                for delay in [Duration.zero, .milliseconds(60), .milliseconds(250)] {
                    Task { @MainActor in
                        try? await Task.sleep(for: delay)
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            proxy.scrollTo(target, anchor: .center)
                        }
                    }
                }
            }
        }
    }

    private func sideShift(_ index: Int) -> CGFloat {
        guard !isScrolling, let selection else { return 0 }
        if index < selection { return -overhang }
        if index > selection { return overhang }
        return 0
    }
}

private struct EdgeFade: ViewModifier {
    let fraction: CGFloat

    func body(content: Content) -> some View {
        content.mask {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: fraction),
                    .init(color: .black, location: 1 - fraction),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

private extension View {
    @ViewBuilder
    func onUserScrollingChange(_ action: @escaping (Bool) -> Void) -> some View {
        if #available(macOS 15.0, *) {
            onScrollPhaseChange { _, phase in
                switch phase {
                case .tracking, .interacting, .decelerating:
                    action(true)
                default:
                    action(false)
                }
            }
        } else {
            self
        }
    }
}
