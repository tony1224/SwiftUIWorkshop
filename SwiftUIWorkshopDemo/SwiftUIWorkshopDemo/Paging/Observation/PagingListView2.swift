//
//  PagingListView2.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import Combine
import Foundation
import SwiftUI
import SwiftUIWorkshop

struct PagingListView2: View {
    @State private var vm = PagingListViewModel2(repository: SampleUserRepository(showList: true))

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
        .alert(vm.showToastMessage ?? "", isPresented: .constant(vm.showToastMessage != nil)) {
            Button("OK", role: .cancel) { }
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
