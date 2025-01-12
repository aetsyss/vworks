//
//  DynamicColumnSizeReader.swift
//  ResearchRoot
//
//  Created by Aleksei Tsyss on 1/11/25.
//

import SwiftUI

struct DynamicColumnSizeReader<T: Identifiable, V: View, K>: ViewModifier {
    @Binding private var storage: [PartialKeyPath<T>: CGFloat]
    
    let items: [T]
    let keyPath: KeyPath<T, K>
    let viewBuilder: (_ value: K) -> V
    
    init(
        items: [T],
        keyPath: KeyPath<T, K>,
        storage: Binding<[PartialKeyPath<T>: CGFloat]>,
        viewBuilder: @escaping (K) -> V
    ) {
        self.items = items
        self.keyPath = keyPath
        self._storage = storage
        self.viewBuilder = viewBuilder
    }
    
    @State private var lastWidth: CGFloat = 0 {
        didSet {
            storage[keyPath] = lastWidth
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(items) { item in
                viewBuilder(item[keyPath: keyPath])
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: TextWidthPreferenceKey.self,
                                            value: geometry.size.width)
                        }
                    )
            }
            .onPreferenceChange(TextWidthPreferenceKey.self) { width in
                lastWidth = max(width, lastWidth)
            }
            .hidden()
            
            content
        }
    }
}

extension View {
    func dynamicColumnSize<T: Identifiable, V: View, K>(
        items: [T],
        keyPath: KeyPath<T, K>,
        storage: Binding<[PartialKeyPath<T>: CGFloat]>,
        viewBuilder: @escaping (_ value: K) -> V
    ) -> some View {
        modifier(
            DynamicColumnSizeReader(items: items, keyPath: keyPath, storage: storage, viewBuilder: viewBuilder)
        )
    }
}

// Custom Preference Key for Text Width
struct TextWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

