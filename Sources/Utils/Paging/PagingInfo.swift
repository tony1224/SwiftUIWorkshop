//
//  PagingInfo.swift
//  SwiftUIWorkshop
//
//  Created by Jun Morita on 2025/03/26.
//

//public protocol PagingInfo {
//    var hasNext: Bool { get }
//}

public struct OffsetPaging {
    public let offset: Int
    public let limit: Int
    public let hasNext: Bool

    public init(offset: Int = 0, limit: Int, hasNext: Bool) {
        self.offset = offset
        self.limit = limit
        self.hasNext = hasNext
    }

    public func nextPage() -> OffsetPaging? {
        hasNext ? OffsetPaging(offset: offset + limit, limit: limit, hasNext: hasNext) : nil
    }

    public static func beforeFirst() -> OffsetPaging {
        .init(limit: 0, hasNext: false)
    }

}

//public struct CursorPaging: PagingInfo {
//    public let nextCursor: String?
//    public var hasNext: Bool { nextCursor != nil }
//
//    public init(nextCursor: String?) {
//        self.nextCursor = nextCursor
//    }
//}
