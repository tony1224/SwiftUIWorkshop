//
//  PagingListViewModel.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import Combine
import SwiftUIWorkshop
import Foundation

@MainActor
class PagingListViewModel: ObservableObject {
    @Published private(set) var pagingState: PagingService<SampleUser>.State = .isFirstLoading
    let showToast = PassthroughSubject<String, Never>()
    private let pagingService: PagingService<SampleUser>
    private var cancellables = Set<AnyCancellable>()
    private var repository: SampleUserRepositoryProtocol

    init(repository: any SampleUserRepositoryProtocol) {
        self.repository = repository

        pagingService = PagingService<SampleUser>(fetchTask: { pagination in
            try await repository.getList(offset: pagination.offset)
        })

        pagingService.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.pagingState = state
            }.store(in: &cancellables)

        pagingService.fetchError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.showToast.send(error.localizedDescription)
            }.store(in: &cancellables)
    }

    func fetchList() async {
        await pagingService.fetchList()
    }

    func refreshList() async {
        await pagingService.resetPagination()
    }
}

protocol SampleUserRepositoryProtocol {
    func getList(offset: Int) async throws -> (items: [SampleUser], pagination: OffsetPaging)
}

class SampleUserRepository: SampleUserRepositoryProtocol {
    private let showList: Bool

    init(showList: Bool) {
        self.showList = showList
    }

    func getList(offset: Int) async throws -> (items: [SampleUser], pagination: OffsetPaging) {
        try await Task.sleep(nanoseconds: 200_000_000)

        if showList {
            let itemsPerPage = 20
            let totalItems = 100

            let endIndex = min(offset + itemsPerPage, totalItems)
            let hasNextPage = endIndex < totalItems

            return (items: (offset..<endIndex).map { id in
                SampleUser(username: "user-\(id)", userIconURL: URL(string: ""))
            },
                    pagination: OffsetPaging(offset: offset + itemsPerPage, limit: itemsPerPage, hasNext: hasNextPage))
        } else {
            return (items: [], pagination: .init(limit: 0, hasNext: false))
        }
    }
}

struct SampleUser: Identifiable {
    var id: String { UUID().uuidString }
    let username: String
    let userIconURL: URL?

    init(username: String, userIconURL: URL?) {
        self.username = username
        self.userIconURL = userIconURL
    }
}
