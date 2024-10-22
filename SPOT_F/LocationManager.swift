//
//  LocationManager.swift
//  SPOT_F
//
//  Created by 선호 on 7/1/24.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var cameraPosition: MapCameraPosition = .automatic
//    @Published var visibleRegion: MKCoordinateRegion?
    
    @Published var nearbyRestaurants: [Restaurant] = []

    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        Task {
            print("fetchNearbyRestaurants!")
            await fetchNearbyRestaurants(location: location, query: "restaurant")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        default:
            break
        }
    }
    
    private func fetchNearbyRestaurants(location: CLLocation, query: String) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        let search = MKLocalSearch(request: request)
        
        do {
            let response = try await search.start()
            // main thread
            DispatchQueue.main.async {
                self.nearbyRestaurants = response.mapItems.map { item in
                    Restaurant(mapItem: item, badge: .figureRoll)
                }
            }
        } catch {
            print("Error searching for places: \(error.localizedDescription)")
        }
    }
}
