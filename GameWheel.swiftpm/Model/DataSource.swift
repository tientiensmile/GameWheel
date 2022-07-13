import SwiftUI

class DataSource: ObservableObject {
    
    @Published var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}
