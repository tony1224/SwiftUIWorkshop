//
//  SegmentPicker.swift
//  SwiftUIWorkshopPackage
//
//  Created by Jun Morita on 2025/03/21.
//

import SwiftUI

public enum SegmentedType {
    case scrollable
    case fixed
}

public struct SegmentedPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    
    @Binding var selection: SelectionValue?
    @Binding var items: [SelectionValue]
    @Namespace private var pickerTransition
    private var selectionColor: Color = .blue
    private var content: (SelectionValue) -> Content
    private var type: SegmentedType
    
    public init(selection: Binding<SelectionValue?>,
         items: Binding<[SelectionValue]>,
         selectionColor: Color = .blue,
         type: SegmentedType,
         @ViewBuilder content: @escaping (SelectionValue) -> Content) {
        _selection = selection
        _items = items
        self.type = type
        self.selectionColor = selectionColor
        self.content = content
    }
    
    public var body: some View {
        switch type {
        case .scrollable:
            scrollableButtons
        case .fixed:
            Text("todo")
        }
    }
    
    private var scrollableButtons: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        let selected = selection == item
                        
                        ZStack {
                            if selected {
                                Capsule()
                                    .foregroundStyle(selectionColor)
                                    .matchedGeometryEffect(id: "picker", in: pickerTransition)
                                    .frame(height: 32)
                                
                                content(item).id(item)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .lineLimit(1)
                                    .clipShape(Capsule())
                                
                            } else {
                                Capsule()
                                    .foregroundStyle(.clear)
                                    .frame(height: 32)

                                content(item).id(item)
                                    .foregroundStyle(.black)
                                    .bold()
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .lineLimit(1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray, lineWidth: 1)
                                            .frame(height: 32)
                                    )
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = item
                            }
                        }
                        .onSegmentedChange(selection: selection, proxy: proxy)
                   }
                    .onAppear {
                        if selection == nil, let first = items.first {
                            selection = first
                        }
                    }
                    
                }
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
}

extension View {
    @ViewBuilder
    func onSegmentedChange<SelectionValue>(selection: SelectionValue?, proxy: ScrollViewProxy) -> some View where SelectionValue: Hashable {
        if #available(iOS 17, *) {
            onChange(of: selection) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    proxy.scrollTo(selection)
                }
            }
        } else {
            onChange(of: selection) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    proxy.scrollTo(selection)
                }
            }
        }
        
    }
}
