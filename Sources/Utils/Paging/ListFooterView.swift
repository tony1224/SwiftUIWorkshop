//
//  ListFooterView.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import SwiftUI

public struct ListFooterView: View {
    private let fetch: () async -> Void

    public init(fetch: @escaping () async -> Void) {
        self.fetch = fetch
    }

    public var body: some View {
        SwiftUI.ProgressView()
            .frame(maxWidth: .infinity)
            .padding(16)
            .listRowBackground(Color(.systemBackground))
            .listRowSeparator(.hidden)
            .onAppear {
                Task {
                    await fetch()
                }
            }
    }
}
