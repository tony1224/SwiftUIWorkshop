//
//  ContentView.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/21.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                rollingTextLink
                marqueeTextLink
                segmentPickerView
            }
            .navigationTitle("SwiftUI Sample")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var rollingTextLink: some View {
        NavigationLink {
            RollingText(currentText: "100", nextText: "1000", textHeight: 24, minWidth: 30, font: .systemFont(ofSize: 16))
        } label: {
            Text("RollingText")
        }
    }
    
    private var marqueeTextLink: some View {
        NavigationLink {
            MarqueeText(text: "scrolling animation.", font: .systemFont(ofSize: 16))
        } label: {
            Text("MarqueeText")
        }
    }
    
    private var segmentPickerView: some View {
        NavigationLink {
            SegmentedPickerView()
        } label: {
            Text("SegmentPickerView")
        }
    }

}

#Preview {
    ContentView()
}
