import SwiftUI

struct ContentView: View {
    
    @State var showPickAlert: Bool = false
    @State var lastPickedItem: Item? = nil
    
    @ObservedObject var dataSource =  DataSource(items: ItemList.data)
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(colors: [.blue.opacity(0.2), .green.opacity(0.1)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    WheelView(dataSource.items) { item in
                        lastPickedItem = item
                        showPickAlert = true
                    }
                    .padding()
                    Spacer()
                }
                .navigationTitle("轉盤")
                .font(.title2)
                .alert("結果", isPresented: $showPickAlert, presenting: lastPickedItem) { _ in
                    Button("OK") { 
                        showPickAlert = false
                    }
                } message: { item in
                    Text("抽中編號 \(item.id)")
                }
                
            }
        }
    }
}
