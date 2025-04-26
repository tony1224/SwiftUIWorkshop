//
//  ContentView.swift
//  SwiftUIWorkshopDemo
//
//  Created by Jun Morita on 2025/03/24.
//

import SwiftUI
import SwiftUIWorkshop

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                rollingTextLink
                marqueeTextLink
                segmentPickerView
                pagingListView
                pagingListViewForObservation
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

    private var pagingListView: some View {
        NavigationLink {
            PagingListView(repository: SampleUserRepository(showList: true))
        } label: {
            Text("PagingList")
        }
    }

    private var pagingListViewForObservation: some View {
        NavigationLink {
            PagingListView2()
        } label: {
            Text("PagingListForObservation")
        }
    }

}

#Preview {
    ContentView()
}
