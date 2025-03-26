//
//  PagingService.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import Combine

public class PagingService<Item: Identifiable, PageInfo: PagingInfo> {
    public enum State {
        case isFirstLoading
        case loaded(items: [Item], footerID: PageInfo?)
        case empty
    }

    public let state = CurrentValueSubject<State, Never>(.isFirstLoading)
    public let fetchError = PassthroughSubject<Error, Never>()

    private var currentPage: PageInfo?
    private var listItems: [Item] = []

    private let fetchTask: (PageInfo?) async throws -> (items: [Item], pagination: PageInfo)

    public init(fetchTask: @escaping (PageInfo?) async throws -> (items: [Item], pagination: PageInfo)) {
        self.fetchTask = fetchTask
    }

    public func fetchList() async {
        do {
            guard let page = currentPage else {
                // TODO: currentPageがnilの場合の処理を追加
                return
            }
            
            let (items, pagination) = try await fetchTask(page)
            currentPage = pagination
            // paging分を足し重複は削除(IDが重複した場合新しい要素を優先)
            // listItems = listItems.merging(items) { new, _ in new }
            for item in items {
                if let index = listItems.firstIndex(where: { $0.id == item.id }) {
                    // 既存のアイテムを更新
                    listItems[index] = item
                } else {
                    // 新しいアイテムを追加
                    listItems.append(item)
                }
            }

            if listItems.isEmpty {
                state.send(.empty)
            } else {
                state.send(.loaded(items: listItems, footerID: pagination.hasNext ? pagination : nil))
            }
        } catch {
            fetchError.send(error)
        }
    }

    public func resetPagination() async {
        currentPage = nil
        state.send(.isFirstLoading)
        listItems = []

        await fetchList()
    }
}
