//
//  LocationService.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationPermission: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.0044, longitude: -0.1021), // Haywards Heath as default
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Set default region to Mid Sussex area
        setDefaultRegion()
    }
    
    func requestLocationPermission() {
        switch locationPermission {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Handle case where user needs to go to settings
            print("Location access denied. User needs to enable in Settings.")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            // This handles the "When I Share" case and other unknown states
            print("Location permission: \(locationPermission.rawValue)")
            // Try to request location anyway for "When I Share" mode
            locationManager.requestLocation()
            break
        }
    }
    
    private func startLocationUpdates() {
        guard locationPermission == .authorizedWhenInUse || locationPermission == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    private func setDefaultRegion() {
        // Default to Mid Sussex area (Haywards Heath)
        let midSussexCoordinate = CLLocationCoordinate2D(latitude: 51.0044, longitude: -0.1021)
        region = MKCoordinateRegion(
            center: midSussexCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    }
    
    func updateRegionForUserLocation() {
        guard let userLocation = userLocation else {
            setDefaultRegion()
            return
        }
        
        region = MKCoordinateRegion(
            center: userLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
    func distanceFromUser(to coordinate: CLLocationCoordinate2D) -> Double? {
        guard let userLocation = userLocation else { return nil }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let eventLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return userCLLocation.distance(from: eventLocation) / 1000 // Return distance in kilometers
    }
    
    func centerMapOnUserLocation() {
        guard let userLocation = userLocation else {
            // If no user location, try to get current location
            switch locationPermission {
            case .notDetermined:
                requestLocationPermission()
            case .authorizedWhenInUse, .authorizedAlways:
                startLocationUpdates()
            default:
                // For "When I Share" and other states, try to request one-time location
                locationManager.requestLocation()
            }
            return
        }
        
        withAnimation(.easeInOut(duration: 1.0)) {
            region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Closer zoom when manually centering
            )
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            let isFirstLocationUpdate = self.userLocation == nil
            self.userLocation = location.coordinate
            
            // Auto-center on first location update
            if isFirstLocationUpdate {
                self.centerMapOnUserLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        // Keep default region on error
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationPermission = status
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.startLocationUpdates()
            case .denied, .restricted:
                // Stay with default region
                self.setDefaultRegion()
            case .notDetermined:
                break
            @unknown default:
                // Handle "When I Share" and other new permission states
                print("Location authorization status: \(status.rawValue)")
                // Don't automatically start continuous updates for "When I Share"
                // User will need to tap location button to request one-time location
                break
            }
        }
    }
}