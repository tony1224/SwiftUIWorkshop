//
//  PagingServiceObservation.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/04/26.
//

import Observation

@Observable
public class PagingServiceObservation<Item: Identifiable> {
    public enum State {
        case isFirstLoading
        case loaded(items: [Item], footerID: Int?)
        case empty
    }

    public var state: State = .isFirstLoading
    public var fetchError: Error? = nil

    private var currentPage: OffsetPaging = .beforeFirst()
    private var listItems: [Item] = []

    private let fetchTask: (OffsetPaging) async throws -> (items: [Item], pagination: OffsetPaging)

    public init(fetchTask: @escaping (OffsetPaging) async throws -> (items: [Item], pagination: OffsetPaging)) {
        self.fetchTask = fetchTask
    }

    public func fetchList() async {
        do {
            let (items, pagination) = try await fetchTask(currentPage)
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
                state = .empty
            } else {
                state = .loaded(items: listItems, footerID: pagination.hasNext ? pagination.offset : nil)
            }
        } catch {
            fetchError = error
        }
    }

    public func resetPagination() async {
        currentPage = .beforeFirst()
        state = .isFirstLoading
        listItems = []

        await fetchList()
    }
}
