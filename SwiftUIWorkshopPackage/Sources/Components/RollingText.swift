//
//  RollingText.swift
//  SwiftUIWorkshopPackage
//
//  Created by Jun Morita on 2025/03/21.
//

import SwiftUI

public struct RollingText: View {
    @State private var offsetY: CGFloat
    private let texts: [String]
    private let textHeight: CGFloat
    private let minWidth: CGFloat
    private let font: UIFont
    private let textColor: Color
    private let startDelay: CGFloat
    private let onAppeared: (() -> Void)?

    public init(
        currentText: String,
        nextText: String,
        textHeight: CGFloat,
        minWidth: CGFloat,
        font: UIFont,
        textColor: Color = .black,
        startDelay: CGFloat = 1.0,
        onAppeared: (() -> Void)? = nil) {
        offsetY = textHeight
        texts = [currentText, nextText]
        self.textHeight = textHeight
        self.minWidth = minWidth
        self.font = font
        self.textColor = textColor
        self.startDelay = startDelay
        self.onAppeared = onAppeared
    }

    public var body: some View {
        VStack(spacing: 8) {
            ForEach(texts, id: \.self) { text in
                Text(text)
                    .font(.init(font))
                    .foregroundStyle(textColor)
                    .frame(minWidth: minWidth, alignment: .trailing)
                    .animation(.spring(response: 0.95, dampingFraction: 1, blendDuration: 0.95), value: offsetY)
            }
            .offset(y: offsetY)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
                offsetY = -textHeight
            }
            onAppeared?()
        }
        .clipped()
    }
}

#Preview {
    RollingText(currentText: "100", nextText: "1000", textHeight: 24, minWidth: 30, font: .systemFont(ofSize: 20))
}
