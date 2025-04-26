//
//  PagingListViewModel2.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

import SwiftUIWorkshop
import Foundation
import Observation

@MainActor
@Observable
class PagingListViewModel2 {
    var pagingState: PagingServiceObservation<SampleUser>.State = .isFirstLoading
    var showToastMessage: String? = nil

    private let pagingService: PagingServiceObservation<SampleUser>

    init(repository: any SampleUserRepositoryProtocol) {
        pagingService = PagingServiceObservation<SampleUser>(fetchTask: { pagination in
            try await repository.getList(offset: pagination.offset)
        })
    }

    func fetchList() async {
        await pagingService.fetchList()
        await updateState()
    }

    func refreshList() async {
        await pagingService.resetPagination()
        await updateState()
    }

    private func updateState() async {
        // ObservationによってpagingService.stateが更新されるのでそれを反映
        pagingState = pagingService.state

        if let error = pagingService.fetchError {
            showToastMessage = error.localizedDescription
        }
    }
}
