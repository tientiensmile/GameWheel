import SwiftUI

struct WheelSliceView<Label>: View where Label: View {
    
    let size: Angle
    let color: Color
    let isOverlap: Bool
    let label: ()->Label
    
    init(size: Angle, color: Color, isOverlap: Bool, @ViewBuilder label: @escaping () ->
         Label) {
        self.size = size
        self.color = color
        self.isOverlap = isOverlap
        self.label = label
    }
    
    var body: some View {
        ZStack(alignment: .top) { 
            WheelSliceShape(sliceSize: size, isOverlap: isOverlap)
                .fill(color)
            label()
                .offset(x: 0, y: 12)
        }
    }
}

fileprivate struct WheelSliceShape: Shape {
    let sliceSize: Angle
    let isOverlap: Bool
    
    init(sliceSize: Angle, isOverlap: Bool) {
        self.sliceSize = sliceSize
        self.isOverlap = isOverlap
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.height / 2, startAngle: .degrees(-90) - (sliceSize / 2), endAngle: .degrees(-90) + (sliceSize / 2) + (isOverlap ? (sliceSize / 4) : .degrees(0)), clockwise: false)
        }
    }
}

struct WheelPointerShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width / 2, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.midX, y: 0))
        }
    }
}


