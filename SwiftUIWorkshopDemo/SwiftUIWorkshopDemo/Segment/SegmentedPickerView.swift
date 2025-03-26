//
//  SegmentedPickerView.swift
//  SwiftUIWorkshopDemo
//
//  Created by Jun Morita on 2025/03/24.
//

import SwiftUI
import SwiftUIWorkshop

struct VTuber: Hashable, Identifiable {
    var id: UUID { UUID() }
    var name: String
    var affiliation: String? = nil
}

struct SegmentedPickerView: View {
    
    @State var vtuber: [VTuber] = [
        .init(name: "月ノ美兎", affiliation: "にじさんじ"),
        .init(name: "兎田ぺこら", affiliation: "ホロライブ"),
        .init(name: "天開司"),
        .init(name: "小森めと", affiliation: "ぶいすぽ")
    ]
    @State var selectionVTuber: VTuber?
    
    var body: some View {
        VStack {
            SegmentedPicker(selection: $selectionVTuber, items: $vtuber, selectionColor: .cyan, type: .scrollable) { vtuber in
                Text(vtuber.name)
                // NOTE: ここで画像を差し込むことも可
            }
            if let selectionVTuber {
                HStack {
                    Text("\(selectionVTuber.name)").bold()
                    if let affiliation = selectionVTuber.affiliation {
                        Text("by \(affiliation)")
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    SegmentedPickerView()
}
