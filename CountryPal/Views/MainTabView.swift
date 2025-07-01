//
//  MainTabView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var eventDataService = EventDataService()
    @StateObject private var locationService = LocationService()
    
    var body: some View {
        TabView {
            MapAndListView(
                eventDataService: eventDataService,
                locationService: locationService
            )
            .tabItem {
                Image(systemName: "map.fill")
                Text("Map")
            }
            
            SavedEventsView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.countryGreen)
        .background(Color.countryBackground)
        .onAppear {
            locationService.requestLocationPermission()
        }
    }
}

struct SavedEventsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "bookmark.heart")
                    .font(.system(size: 60))
                    .foregroundColor(.countryOrange)
                Text("Saved Events")
                    .font(.countryPalTitle)
                    .foregroundColor(.countryTextPrimary)
                Text("Your favorite local events will appear here")
                    .font(.countryPalBody)
                    .foregroundColor(.countryTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .background(Color.countryBackground)
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.countryGreen)
                Text("Profile")
                    .font(.countryPalTitle)
                    .foregroundColor(.countryTextPrimary)
                Text("Coming Soon!")
                    .font(.countryPalSubheadline)
                    .foregroundColor(.countryOrange)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's planned:")
                        .font(.countryPalHeadline)
                        .foregroundColor(.countryTextPrimary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.countryGreen)
                            Text("Personal preferences")
                        }
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.countryOrange)
                            Text("Event history")
                        }
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.countryGold)
                            Text("Notifications")
                        }
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.countryLightGreen)
                            Text("Community features")
                        }
                    }
                    .font(.countryPalBody)
                    .foregroundColor(.countryTextSecondary)
                }
                .padding(20)
                .countryCard(elevation: 0.8)
            }
            .padding()
            .background(Color.countryBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MainTabView()
}