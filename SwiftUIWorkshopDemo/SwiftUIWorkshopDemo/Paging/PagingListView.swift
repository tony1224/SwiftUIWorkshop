//
//  PagingListView.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import Combine
import Foundation
import SwiftUI
import SwiftUIWorkshop

struct PagingListView: View {
    @ObservedObject private var vm: PagingListViewModel

    init(repository: SampleUserRepositoryProtocol) {
        _vm = ObservedObject(wrappedValue: .init(repository: repository))
    }

    var body: some View {
        List {
            switch vm.pagingState {
            case .isFirstLoading:
                loadingView
            case .loaded(let users, let footerID):
                ForEach(users) { user in
                    Text(user.username)
                }
                if let footerID {
                    ListFooterView {
                        await vm.fetchList()
                    }
                    .id(footerID)
                }
            case .empty:
                emptyView
            }
        }
        .listStyle(.plain)
        .task {
            await vm.fetchList()
        }
        .refreshable {
            await vm.refreshList()
        }
        .navigationTitle("Paging")
    }

    private var loadingView: some View {
        ProgressView()
            .listRowSeparator(.hidden)
            .padding(.vertical, 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        Text("responseはemptyです")
            .listRowSeparator(.hidden)
            // 画面上下中央表示が難しいため画面上部から120pxの位置にloadingを表示
            .padding(.vertical, 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
