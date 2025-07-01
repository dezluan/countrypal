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
                            .font(.system(size: 12, weight: .semibold))
                        Text(event.category.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [event.category.color, event.category.color.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
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
                
                // Event title
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                // Date and time
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.accentColor)
                    Text(event.durationText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Location
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.accentColor)
                    
                    Text(event.location.venue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    if let distance = distanceText {
                        Text("•")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(distance)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.accentColor)
                    }
                }
                
                // Description preview
                Text(event.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
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
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
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