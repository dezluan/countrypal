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
        .accentColor(.accentColor)
        .onAppear {
            locationService.requestLocationPermission()
        }
    }
}

struct SavedEventsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "bookmark.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                Text("Saved Events")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Your saved events will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                Text("Profile")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Under Construction")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coming Soon:")
                        .font(.headline)
                    Text("• User preferences")
                    Text("• Event history")
                    Text("• Account settings")
                    Text("• Notification preferences")
                }
                .foregroundColor(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MainTabView()
}