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
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: events) { event in
            MapAnnotation(coordinate: event.location.coordinate) {
                Button(action: {
                    onEventSelected(event)
                }) {
                    EventAnnotationView(event: event)
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
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