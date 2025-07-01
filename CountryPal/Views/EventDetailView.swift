//
//  EventDetailView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct EventDetailView: View {
    let event: Event
    let userLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    @State private var region: MKCoordinateRegion
    
    init(event: Event, userLocation: CLLocationCoordinate2D?) {
        self.event = event
        self.userLocation = userLocation
        self._region = State(initialValue: MKCoordinateRegion(
            center: event.location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    private var distanceText: String? {
        guard let userLocation = userLocation else { return nil }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let eventLocation = CLLocation(latitude: event.location.coordinate.latitude, longitude: event.location.coordinate.longitude)
        let distance = userCLLocation.distance(from: eventLocation) / 1000
        
        return String(format: "%.1f km away", distance)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: event.category.systemImage)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(event.category.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [event.category.color, event.category.color.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: event.category.color.opacity(0.3), radius: 4, x: 0, y: 2)
                            )
                            
                            Spacer()
                            
                            if event.isSponsored {
                                Text("Sponsored")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                        
                        Text(event.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.primary, .primary.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    // Date and Time
                    VStack(alignment: .leading, spacing: 12) {
                        Text("When")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "calendar.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(event.category.color)
                            Text(event.durationText)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(event.category.color.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Where")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(event.category.color)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.location.venue)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(event.location.address)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if let distance = distanceText {
                                    Text(distance)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(event.category.color)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(event.category.color.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(event.category.color.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        // Mini map
                        Map(coordinateRegion: $region, annotationItems: [event]) { event in
                            MapAnnotation(coordinate: event.location.coordinate) {
                                EventAnnotationView(event: event)
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .disabled(true)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(event.description)
                            .font(.system(size: 16, weight: .regular))
                            .lineSpacing(4)
                            .foregroundColor(.primary)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                            )
                    )
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(event.category.color)
                            Text(event.contactInfo)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(event.category.color.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Get Directions Button
                    Button(action: openDirections) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Get Directions")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [event.category.color, event.category.color.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: event.category.color.opacity(0.4), radius: 8, x: 0, y: 4)
                        )
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer(minLength: 50)
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func openDirections() {
        let placemark = MKPlacemark(coordinate: event.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.location.venue
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

#Preview {
    let sampleEvent = Event(
        title: "Sample Event",
        description: "This is a sample event description.",
        category: .villageFete,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        location: EventLocation(
            address: "Sample Address",
            coordinate: CLLocationCoordinate2D(latitude: 51.0044, longitude: -0.1021),
            venue: "Sample Venue"
        ),
        contactInfo: "sample@email.com"
    )
    
    return EventDetailView(event: sampleEvent, userLocation: nil)
}