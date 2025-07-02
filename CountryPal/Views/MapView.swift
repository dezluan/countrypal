//
//  MapView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    let events: [Event]
    @Binding var region: MKCoordinateRegion
    let userLocation: CLLocationCoordinate2D?
    let onEventSelected: (Event) -> Void
    
    @State private var cameraPosition: MapCameraPosition
    
    init(events: [Event], region: Binding<MKCoordinateRegion>, userLocation: CLLocationCoordinate2D?, onEventSelected: @escaping (Event) -> Void) {
        self.events = events
        self._region = region
        self.userLocation = userLocation
        self.onEventSelected = onEventSelected
        self._cameraPosition = State(initialValue: MapCameraPosition.region(region.wrappedValue))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(events) { event in
                Annotation("", coordinate: event.location.coordinate) {
                    Button(action: {
                        onEventSelected(event)
                    }) {
                        EventAnnotationView(event: event)
                    }
                }
            }
            
            // User location annotation
            if let userLocation = userLocation {
                Annotation("Your Location", coordinate: userLocation) {
                    ZStack {
                        Circle()
                            .fill(Color.countryOrange.opacity(0.3))
                            .frame(width: 32, height: 32)
                        Circle()
                            .fill(Color.countryOrange)
                            .frame(width: 16, height: 16)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
                .mapControlVisibility(.hidden) // Hide default, we use our custom button
        }
        .onChange(of: region.center.latitude) { _, _ in
            cameraPosition = MapCameraPosition.region(region)
        }
        .onChange(of: region.center.longitude) { _, _ in
            cameraPosition = MapCameraPosition.region(region)
        }
        .onChange(of: region.span.latitudeDelta) { _, _ in
            cameraPosition = MapCameraPosition.region(region)
        }
        .onChange(of: region.span.longitudeDelta) { _, _ in
            cameraPosition = MapCameraPosition.region(region)
        }
        .onMapCameraChange { context in
            region = context.region
        }
    }
}

#Preview {
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.0044, longitude: -0.1021),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    return MapView(
        events: [],
        region: $region,
        userLocation: nil,
        onEventSelected: { _ in }
    )
}