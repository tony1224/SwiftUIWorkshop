//
//  MarqueeText.swift
//  SwiftUIWorkshopPackage
//
//  Created by Jun Morita on 2025/03/21.
//

import SwiftUI

public struct MarqueeText: View {
    @State private var animate = false
    private let text: String
    private let font: UIFont
    private let startDelay: Double
    private let animationSpeed: Double
    private var leftPadding: CGFloat
    private var rightPadding: CGFloat

    public init(text: String,
                font: UIFont,
                startDelay: Double = 1.0,
                animationSpeed: CGFloat = 0.05,
                leftPadding: CGFloat = 0.0,
                rightPadding: CGFloat = 0.0) {
        self.text = text
        self.font = font
        self.startDelay = startDelay
        self.animationSpeed = animationSpeed
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
    }

    public var body: some View {
        let stringWidth = textSize().width
        let stringHeight = textSize().height

        let animation = Animation
            .linear(duration: animationSpeed * stringWidth)
            .delay(startDelay)
            .repeatForever(autoreverses: false)
        let nullAnimation = Animation
            .linear(duration: 0)

        return ZStack {
            GeometryReader { geo in
                Group {
                    firstText(width: stringWidth, height: stringHeight, animation: animation, nullAnimation: nullAnimation)
                    nextText(width: stringWidth, height: stringHeight, animation: animation, nullAnimation: nullAnimation)
                }
                .offset(x: leftPadding)
                .mask(maskView)
                .frame(width: geo.size.width + leftPadding)
                .offset(x: leftPadding * -1)
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: stringWidth)
        .onAppear {
            DispatchQueue.main.async {
                animate = true
            }
        }
        .onDisappear { animate = false }
    }

    private func firstText(width: CGFloat, height: CGFloat, animation: Animation, nullAnimation: Animation) -> some View {
        Text(text)
            .lineLimit(1)
            .font(.init(font))
            .offset(x: animate ? -width - height * 2 : 0)
            .animation(animate ? animation : nullAnimation, value: animate)
            .onAppear {
                DispatchQueue.main.async {
                    animate = true
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    private func nextText(width: CGFloat, height: CGFloat, animation: Animation, nullAnimation: Animation) -> some View {
        Text(text)
            .lineLimit(1)
            .font(.init(font))
            .offset(x: animate ? 0 : width + height * 2)
            .animation(animate ? animation : nullAnimation, value: animate)
            .onAppear {
                DispatchQueue.main.async {
                    animate = true
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    private var maskView: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: leftPadding)
                .opacity(0)
            LinearGradient(
                gradient: Gradient(colors: [.black, .black]),
                startPoint: /*@START_MENU_TOKEN@*/ .leading/*@END_MENU_TOKEN@*/,
                endPoint: /*@START_MENU_TOKEN@*/ .trailing/*@END_MENU_TOKEN@*/)
            Rectangle()
                .frame(width: rightPadding)
                .opacity(0)
        }
    }

    private func textSize() -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: attributes)
    }
}

#Preview {
    MarqueeText(text: "test animation.", font: .systemFont(ofSize: 16), startDelay: 1.0, animationSpeed: 0.05)
}
