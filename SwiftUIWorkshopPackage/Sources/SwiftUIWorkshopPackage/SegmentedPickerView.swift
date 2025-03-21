//
//  SegmentedPickerView.swift
//  SwiftUIWorkshopPackage
//
//  Created by Jun Morita on 2025/03/21.
//

import SwiftUI

struct Book: Hashable, Identifiable {
    var id: UUID { UUID() }
    var title: String
    var author: String
}

struct SegmentedPickerView: View {
    
    @State var books: [Book] = [
        Book(title: "1984年", author: "ジョージ・オーウェル"),
        Book(title: "夏への扉", author: "ロバート・A・ハインライン"),
        Book(title: "地底旅行", author: "ジュール・ヴェルヌ"),
        Book(title: "WOOL", author: "ヒュー・ハウイー"),
        Book(title: "know", author: "野崎まど")
    ]
    @State var selectionBook: Book?
    
    var body: some View {
        VStack {
            SegmentedPicker(selection: $selectionBook, items: $books, selectionColor: .cyan, type: .scrollable) { book in
                Text(book.title)
                // NOTE: ここで画像を差し込むことも可
            }
            if let selectionBook {
                HStack {
                    Text("\(selectionBook.title) by ")
                    +
                    Text("\(selectionBook.author)").bold()
                }.padding()
            }
        }
    }
}

#Preview {
    SegmentedPickerView()
}
