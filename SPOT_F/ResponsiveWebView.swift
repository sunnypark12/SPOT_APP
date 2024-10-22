import CoreLocation
import SwiftUI

struct ResponsiveWebView: View {
    let spots: [Spot] = [
        Spot(name: "Spot 1", position: CGPoint(x: -90, y: -90), pictures: ["1", "2", "3", "4"]),
        Spot(name: "Spot 2", position: CGPoint(x: 95, y: -120), pictures: ["5", "6", "7", "8"]),
        Spot(name: "Spot 3", position: CGPoint(x: -90, y: 100), pictures: ["9", "10", "11", "12"]),
        Spot(name: "Spot 4", position: CGPoint(x: 95, y: 130), pictures: ["13", "14", "15", "16"]),
    ]
    
    @Binding var isProfilePressed: Bool
    @State private var currentZoom: CGFloat = 0.0
    @State private var totalZoom: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var selectedPicture: IdentifiableString?
    @State private var selectedSpot: Spot?

    var body: some View {
        ZStack {
            ForEach(spots) { spot in
                SpotView(spot: spot, selectedPicture: $selectedPicture, selectedSpot: $selectedSpot)
            }
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .position(x: 200, y: 400)
                .onTapGesture {
                    isProfilePressed = true
                }
        }
        .scaleEffect(totalZoom + currentZoom)
        .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    currentZoom = value - 1
                }
                .onEnded { value in
                    totalZoom += currentZoom
                    currentZoom = 0
                }
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    offset.width += value.translation.width
                    offset.height += value.translation.height
                    dragOffset = .zero
                }
        )
        .sheet(item: $selectedPicture) { identifiableString in
            SpotDetailView(picture: identifiableString.value)
        }
        .sheet(item: $selectedSpot) { spot in
            CollectionsView()
        }
        .frame(width: 400, height: 400)
    }
}

struct SpotView: View {
    let spot: Spot
    @Binding var selectedPicture: IdentifiableString?
    @Binding var selectedSpot: Spot?

    var body: some View {
        ZStack {
            ForEach(spot.pictures.indices, id: \.self) { index in
                let picPosition = self.fixedPosition(for: spot.pictures[index], center: CGPoint(x: spot.position.x + 200, y: spot.position.y + 400))
                Line(start: CGPoint(x: spot.position.x + 200, y: spot.position.y + 400), end: picPosition)
                    .stroke(Color.white, lineWidth: 2)
                
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Text(spot.pictures[index]).foregroundColor(.black))
                    .position(picPosition)
                    .onTapGesture {
                        selectedPicture = IdentifiableString(value: spot.pictures[index])
                    }
            }
            
            Circle()
                .fill(Color.gray)
                .frame(width: 75, height: 75)
                .overlay(Text(spot.name).foregroundColor(.black))
                .position(x: spot.position.x + 200, y: spot.position.y + 400)
                .onTapGesture {
                    selectedSpot = spot
                }
            
            let endPoint = edgePoint(from: CGPoint(x: 200, y: 400), to: CGPoint(x: spot.position.x + 200, y: spot.position.y + 400), radius: 37.5)
            Line(start: CGPoint(x: 200, y: 400), end: endPoint)
                .stroke(Color.white, lineWidth: 2)
        }
    }
    
    private func fixedPosition(for picture: String, center: CGPoint) -> CGPoint {
        // Define fixed positions for each picture
        switch picture {
        case "1":
            return CGPoint(x: center.x - 70, y: center.y - 50)
        case "2":
            return CGPoint(x: center.x, y: center.y - 90)
        case "3":
            return CGPoint(x: center.x - 70, y: center.y + 40)
        case "4":
            return CGPoint(x: center.x + 70, y: center.y - 50)
        case "5":
            return CGPoint(x: center.x + 50, y: center.y - 70)
        case "6":
            return CGPoint(x: center.x + 75, y: center.y + 20)
        case "7":
            return CGPoint(x: center.x - 40, y: center.y - 80)
        case "8":
            return CGPoint(x: center.x + 20, y: center.y + 80)
        case "9":
            return CGPoint(x: center.x - 60, y: center.y + 60)
        case "10":
            return CGPoint(x: center.x + 20, y: center.y + 110)
        case "11":
            return CGPoint(x: center.x - 60, y: center.y - 50)
        case "12":
            return CGPoint(x: center.x + 70, y: center.y + 50)
        case "13":
            return CGPoint(x: center.x + 10, y: center.y + 110)
        case "14":
            return CGPoint(x: center.x + 70, y: center.y + 50)
        case "15":
            return CGPoint(x: center.x - 60, y: center.y + 60)
        case "16":
            return CGPoint(x: center.x + 60, y: center.y - 50)
        default:
            return center
        }
    }
    
    private func edgePoint(from start: CGPoint, to end: CGPoint, radius: CGFloat) -> CGPoint {
        let angle = atan2(end.y - start.y, end.x - start.x)
        return CGPoint(x: end.x - cos(angle) * radius, y: end.y - sin(angle) * radius)
    }
}

struct SpotDetailView: View {
    let picture: String
    @State private var showBack = false

    var body: some View {
        VStack {
            ZStack {
                if showBack {
                    // Video view
                    Color.black
                        .overlay(
                            Text("Video \(picture)")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                } else {
                    // Image view
                    AsyncImage(url: URL(string: "https://via.placeholder.com/320x320?text=Spot+\(picture)")) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    showBack.toggle()
                }
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


struct Line: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct Spot: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let position: CGPoint
    let pictures: [String]

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(position.x)
        hasher.combine(position.y)
    }

    static func == (lhs: Spot, rhs: Spot) -> Bool {
        lhs.name == rhs.name && lhs.position == rhs.position
    }
}

struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}

struct ResponsiveWebView_Preview: PreviewProvider {
    static var previews: some View {
        ResponsiveWebView(isProfilePressed: .constant(false))
    }
}
