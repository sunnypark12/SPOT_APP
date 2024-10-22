//
//  RadarView.swift
//  SPOT_F
//
//  Created by 선호 on 7/13/24.
//


import SwiftUI

struct RadarSweep: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        path.move(to: center)
        path.addArc(center: center, radius: rect.width / 2, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}


struct RadarView: View {
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    private var markers: [Marker] = []
    private var scannerTailColor: AngularGradient = AngularGradient(
        gradient: Gradient(colors: [Color.blue]),
        center: .center
    )
    
    init() {
        self.markers = randomMarkersList()
        self.scannerTailColor = AngularGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0), Color.gray.opacity(0.75)]),
            center: .center
        )
    }
    
    var body: some View {
        ZStack {
            Circle()
                 .frame(width: 20, height: 20)
                 .foregroundStyle(.white)
            
            Circle()
                .frame(width: 12, height: 12)
                .foregroundStyle(.blue)
            
//            // Markers
//            ForEach(markers, id: \.self) { m in
//                Circle()
//                    .opacity(self.opacity)
//                    .frame(width: self.markerSize, height: self.markerSize)
//                    .foregroundColor(self.color)
//                    .offset(x: m.offset, y: 0)
//                    .rotationEffect(.degrees(m.degrees))
//                    .blur(radius: 2)
//                    .animation(
//                        .linear(duration: self.scannerSpeed)
//                            .repeatForever(autoreverses: false)
//                            .delay((self.scannerSpeed / 360) * (90 + self.rotation)),
//                        value: self.rotation
//                    )
//            }
            
            // Scanner tail
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(lineWidth: self.scannerSize / 2)
                .fill(scannerTailColor)
                .frame(width: self.scannerSize / 2, height: self.scannerSize / 2)
                .rotationEffect(.degrees(135 + self.rotation))
            
            // Scanner line
//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 2, height: self.scannerSize / 2)
//                .offset(y: -self.scannerSize / 4)
//                .rotationEffect(.degrees(self.rotation))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                self.rotation = -360
            }
        }
    }
    
    // Dummy values and functions for compilation
    private var scannerSize: CGFloat { 300 }
    private var scannerSpeed: Double { 3 }
    private var markerSize: CGFloat { 10 }
    private var color: Color { .blue }
    
    private func randomMarkersList() -> [Marker] {
        // Replace this with your actual randomMarkersList function
        return [Marker(offset: 50, degrees: 45)]
    }
}

struct Marker: Hashable {
    var offset: CGFloat
    var degrees: Double
}

extension Color {
    static let offWhite = Color(UIColor.systemGray6)
}


#Preview {
    RadarView()
}
