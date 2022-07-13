import SwiftUI

struct WheelView: View {
    
    @State var startingRotation: Double = 0
    @State var translation: Double = 0
    
    private var slizeSize: Angle {
        return .degrees(360 / Double(items.count))
    }
    
    let items: [Item]
    let action: ((Item) -> Void)?
    
    init(_ items: [Item], action: ((Item) -> Void)?) {
        self.items = items
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(.gray)
                    .shadow(color: Color.black.opacity(0.3), radius: geometry.size.height, x: 0, y: 0)
                ForEach(items) { item in
                    
                    let isOverlap = !(item.id == items.count)
                    
                    WheelSliceView(size: slizeSize, color: item.color, isOverlap: isOverlap) { 
                        Text("\(item.id)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .rotationEffect(slizeSize * Double(item.id - 1))
                    
                }
                .rotationEffect(.degrees(startingRotation) + .degrees(translation / geometry.size.height * 180))
                
                WheelPointerShape()
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: geometry.size.height / 50, x: 0, y: 0)
                    .frame(width: geometry.size.width / 12, height: geometry.size.height / 6, alignment: .center)
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        startingRotation = startingRotation.truncatingRemainder(dividingBy: 360)
                        translation = value.translation.height
                    })
                    .onEnded({ value in
                        wheelOnEnded(value: value, geometry: geometry)
                    })
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func wheelOnEnded(value: DragGesture.Value, geometry: GeometryProxy) {
        let velocity = abs(value.predictedEndTranslation.height - value.translation.height) / 400
        let angularTranslation = (value.predictedEndTranslation.height / geometry.size.height) * CGFloat(180)
        let desiredEndRotation = startingRotation + angularTranslation * (1 + velocity)
        let nearestStop = round(desiredEndRotation / slizeSize.degrees) * slizeSize.degrees
        let ratio = round(desiredEndRotation.truncatingRemainder(dividingBy: 360) / slizeSize.degrees)
        let sliceIndex = (items.count - Int(ratio)) % items.count
        let (animation, duration) = animation(for: velocity)
        withAnimation(animation) { 
            startingRotation = nearestStop
            translation = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { 
            let index = items.index(items.startIndex, offsetBy: sliceIndex)
            action?(items[index])
        }
    }
    
    private func animation(for velocity: Double) -> (Animation, Double) {
        let duration = max(velocity, 0.2)
        return (Animation.easeOut(duration: duration), duration)
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        
        WheelView(ItemList.data) { item in
            print(item.id)
        }
    }
}
