import SwiftUI

struct Item: Identifiable, Hashable {
    let id: Int
    let color: Color
}

struct ItemList {
    static let data: [Item] = [
        Item(id: 1, color: .red),
        Item(id: 2, color: .orange),
        Item(id: 3, color: .yellow),
        Item(id: 4, color: .green),
        Item(id: 5, color: .blue),
        Item(id: 6, color: .indigo),
        Item(id: 7, color: .purple)
    ]
}
