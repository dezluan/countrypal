//
//  EventListView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import CoreLocation

struct EventListView: View {
    let events: [Event]
    let userLocation: CLLocationCoordinate2D?
    let onEventSelected: (Event) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(events) { event in
                    EventCardView(
                        event: event,
                        userLocation: userLocation,
                        onTap: {
                            onEventSelected(event)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

struct EventCardView: View {
    let event: Event
    let userLocation: CLLocationCoordinate2D?
    let onTap: () -> Void
    
    private var distanceText: String? {
        guard let userLocation = userLocation else { return nil }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let eventLocation = CLLocation(latitude: event.location.coordinate.latitude, longitude: event.location.coordinate.longitude)
        let distance = userCLLocation.distance(from: eventLocation) / 1000 // Convert to km
        
        return String(format: "%.1f km away", distance)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Category badge
                    HStack(spacing: 6) {
                        Image(systemName: event.category.systemImage)
                            .font(.countryPalSmall)
                        Text(event.category.rawValue)
                            .font(.countryPalSmall)
                    }
                    .countryTag(color: event.category.countryColor)
                    
                    Spacer()
                    
                    if event.isSponsored {
                        Text("Sponsored")
                            .countryTag(color: .countryGold)
                    }
                }
                
                // Event title
                Text(event.title)
                    .font(.countryPalHeadline)
                    .foregroundColor(.countryTextPrimary)
                    .multilineTextAlignment(.leading)
                
                // Date and time
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryOrange)
                    Text(event.durationText)
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // Location
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryOrange)
                    
                    Text(event.location.venue)
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                    
                    if let distance = distanceText {
                        Text("•")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                        
                        Text(distance)
                            .font(.countryPalCaption)
                            .foregroundColor(.countryGreen)
                    }
                }
                
                // Description preview
                Text(event.description)
                    .font(.countryPalBody)
                    .foregroundColor(.countryTextSecondary)
                    .lineLimit(2)
            }
            .padding(20)
            .countryCard(elevation: 1.2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EventListView(
        events: [],
        userLocation: nil,
        onEventSelected: { _ in }
    )
}