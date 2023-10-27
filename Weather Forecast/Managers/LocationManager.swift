//
//  LocationManager.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    private var hasProcessedLocation: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var errorMessage: String? // To propagate error messages
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus // Check initial authorization status
    }
    
    func requestLocation() {
        hasProcessedLocation = false // Reset the flag when requesting new location data
        isLoading = true
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Location access denied. Please enable it in settings."
            isLoading = false
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            errorMessage = "Unknown location authorization status."
            isLoading = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hasProcessedLocation { return }
        
        if let location = locations.last {
            self.location = location.coordinate
            isLoading = false
            manager.stopUpdatingLocation()
            hasProcessedLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
        errorMessage = "Failed to get location: \(error.localizedDescription)"
        isLoading = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
