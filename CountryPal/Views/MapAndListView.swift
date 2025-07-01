//
//  MapAndListView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import MapKit

struct MapAndListView: View {
    @ObservedObject var eventDataService: EventDataService
    @ObservedObject var locationService: LocationService
    @State private var selectedEvent: Event?
    @State private var showingEventDetail = false
    @State private var thisWeekendSelected = false
    @State private var nearMeSelected = false
    @State private var familyFriendlySelected = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Quick filters at the top
                QuickFiltersView(
                    thisWeekendSelected: $thisWeekendSelected,
                    nearMeSelected: $nearMeSelected,
                    familyFriendlySelected: $familyFriendlySelected
                )
                .padding(.vertical, 12)
                .background(Color.countryBackground)
                
                // Ads section
                AdBannerView()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                
                // Split view: Map on top, List on bottom
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Map view (top half)
                        MapView(
                            events: filteredEvents,
                            region: $locationService.region,
                            userLocation: locationService.userLocation,
                            onEventSelected: { event in
                                selectedEvent = event
                                showingEventDetail = true
                            }
                        )
                        .frame(height: geometry.size.height * 0.5)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // Divider
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        
                        // List view (bottom half)
                        EventListView(
                            events: filteredEvents,
                            userLocation: locationService.userLocation,
                            onEventSelected: { event in
                                selectedEvent = event
                                showingEventDetail = true
                            }
                        )
                        .frame(height: geometry.size.height * 0.5)
                    }
                }
            }
            .navigationTitle("CountryPal")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.countryBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FilterView(eventDataService: eventDataService)) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.countryOrange)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        locationService.requestLocationPermission()
                    }) {
                        Image(systemName: locationService.locationPermission == .authorizedWhenInUse || locationService.locationPermission == .authorizedAlways ? "location.fill" : "location")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(locationService.locationPermission == .authorizedWhenInUse || locationService.locationPermission == .authorizedAlways ? .countryOrange : .countryTextSecondary)
                    }
                }
            }
            .searchable(text: $eventDataService.searchText, prompt: "Search events...")
            .sheet(isPresented: $showingEventDetail) {
                if let event = selectedEvent {
                    EventDetailView(event: event, userLocation: locationService.userLocation)
                }
            }
        }
    }
    
    private var filteredEvents: [Event] {
        var events = eventDataService.filteredEvents
        
        if thisWeekendSelected {
            let calendar = Calendar.current
            let now = Date()
            let startOfWeekend = calendar.dateInterval(of: .weekOfYear, for: now)?.end.addingTimeInterval(-2*24*60*60) ?? now
            let endOfWeekend = startOfWeekend.addingTimeInterval(2*24*60*60)
            
            events = events.filter { event in
                event.startDate >= startOfWeekend && event.startDate <= endOfWeekend
            }
        }
        
        if nearMeSelected, let userLocation = locationService.userLocation {
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            events = events.filter { event in
                let eventLocation = CLLocation(latitude: event.location.coordinate.latitude, longitude: event.location.coordinate.longitude)
                let distance = userCLLocation.distance(from: eventLocation)
                return distance <= 10000 // 10km radius
            }
        }
        
        if familyFriendlySelected {
            events = events.filter { event in
                event.category == .villageFete || 
                event.category == .farmersMarket || 
                event.category == .craftFair || 
                event.category == .community ||
                event.title.localizedCaseInsensitiveContains("family") || 
                event.description.localizedCaseInsensitiveContains("family") ||
                event.description.localizedCaseInsensitiveContains("child")
            }
        }
        
        return events
    }
}

struct AdBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "heart.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.countryOrange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Community Partners")
                    .font(.countryPalSmall)
                    .foregroundColor(.countryTextSecondary)
                
                Text("Support local businesses in your area")
                    .font(.countryPalCaption)
                    .foregroundColor(.countryTextPrimary)
            }
            
            Spacer()
            
            Button("Explore") {
                // Handle ad tap
            }
            .countryButtonStyle(isPrimary: false, size: .small)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.countryCream, Color.countryLightOrange.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.countryOrange.opacity(0.2), lineWidth: 1)
                )
                .shadow(
                    color: Color.countryOrange.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

#Preview {
    MapAndListView(
        eventDataService: EventDataService(),
        locationService: LocationService()
    )
}