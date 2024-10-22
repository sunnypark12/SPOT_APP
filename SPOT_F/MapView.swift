import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @State private var isExpand: Bool = false
    
    @State private var selectedPlace: Restaurant?
    
    @State private var showSheet: Bool = false
    @State private var showDetailView: Bool = false

    var body: some View {
        NavigationStack {
            // iOS 17 +
            Map(position: $locationManager.cameraPosition) {
                UserAnnotation {
                    RadarView()
                }
                
                ForEach(locationManager.nearbyRestaurants) { place in
                    Annotation(place.mapItem.name ?? "Unknown", coordinate: place.mapItem.placemark.coordinate) {
                        MarkerView(place: place, selectedPlace: $selectedPlace) { place in
                            selectedPlace = place
                            showSheet = true
                        }
                    }
                    .annotationTitles(.hidden)
                }
            }
            .sheet(isPresented: $showSheet) {
                if let selectedPlace = selectedPlace {
                    SheetView(place: selectedPlace, showDetailView: $showDetailView)
                        .presentationDetents([.height(200)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
                }
            }
            .navigationDestination(isPresented: $showDetailView) {
                MapDetailView()
            }
            
            .mapControls {
                MapUserLocationButton()
            }
            .onAppear {
                locationManager.requestLocation()
            }
//            .onMapCameraChange { context in
//                locationManager.visibleRegion = context.region
//            }
//            // nearbyRestaurants 값이 변경되면 camera position 업데이트
//            .onChange(of: locationManager.nearbyRestaurants.map { $0.mapItem }) {
//                locationManager.cameraPosition = .automatic
//            }
            .onChange(of: selectedPlace?.id) {
                if let newMapItem = selectedPlace?.mapItem {
                    withAnimation {
                        locationManager.cameraPosition = .item(newMapItem)
                    }
                }
            }
//            .onMapCameraChange { context in
//                locationManager.visibleRegion = context.region
//            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    RestaurantScrollBox(places: locationManager.nearbyRestaurants, selectedPlace: $selectedPlace) { place in
//                        withAnimation {
//                            locationManager.cameraPosition = .item(place.mapItem)
//                        }
                        selectedPlace = place
                        showSheet = true
                    }
                    .offset(y: (isExpand ? -60 : 0))
                    
                    ExpandableMenu(isExpanded: $isExpand)
                }
            }
        }
    }
}

// MARK: - RESTAURANT SCROLL VIEW

struct RestaurantScrollBox: View {
    let places: [Restaurant]
    @Binding var selectedPlace: Restaurant?

    var onSelect: (Restaurant) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(places) { place in
                    HStack(spacing: 10) {
                        Image("sampleImage-1")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading) {
                            Text(place.mapItem.name ?? "Unknown")
                                .font(.callout)
                            
                            Text(getFormattedAddress(from: place.mapItem.placemark))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .frame(width: 200, height: 50)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.adaptiveBackground)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.adaptiveBackground, lineWidth: 2)
                    )
                    .onTapGesture {
                        onSelect(place)
                        selectedPlace = place
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    private func getFormattedAddress(from placemark: MKPlacemark) -> String {
        let addressLines = [placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country]
        let address = addressLines.compactMap { $0 }.joined(separator: ", ")
        return address.isEmpty ? "No Address Available" : address
    }
}

// MARK: - MARKER VIEW

struct MarkerView: View {
    let place: Restaurant
    @Binding var selectedPlace: Restaurant?

    var onSelect: (Restaurant) -> Void

    var body: some View {
        ZStack(alignment: .center) {
            
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 30)
            
            Circle()
                .fill(Color.cyan)
                .frame(width: 10, height: 10)

            if selectedPlace?.id == place.id {
                PopupView(place: place)
            }
        }
        .shadow(radius: 10)
        .onTapGesture {
            onSelect(place)
            selectedPlace = place
        }
    }
}

struct PopupView: View {
    let place: Restaurant

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("sampleImage-1")
                .resizable()
                .scaledToFill()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
            
            Image(systemName: place.badge?.rawValue ?? "car.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 12, height: 12)
                .padding(8)
                .background(place.badge?.backgroundColor)
                .clipShape(Circle())
                .offset(x: 5)
        }
        .offset(y: -50)
    }
}
struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    let place: Restaurant
    @Binding var showDetailView: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.776, blue: 0.0), location: 0.3),
                    .init(color: Color(red: 0.835, green: 0.4, blue: 0.086), location: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                }
                Text(place.mapItem.name ?? "Unknown")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text(getFormattedAddress(from: place.mapItem.placemark))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                            
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        place.mapItem.openInMaps()
                    }) {
                        Label("Open Maps", systemImage: "map.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        dismiss()
                        showDetailView = true
                    }) {
                        Label("Detail", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private func getFormattedAddress(from placemark: MKPlacemark) -> String {
        let addressLines = [placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country]
        let address = addressLines.compactMap { $0 }.joined(separator: ", ")
        return address.isEmpty ? "No Address Available" : address
    }
}


#Preview {
    MapView()
}
