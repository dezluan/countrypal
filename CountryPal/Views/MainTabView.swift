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
    @StateObject private var authService = Auth0AuthenticationService()
    
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
            
            ProfileView(authService: authService)
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
    @ObservedObject var authService: Auth0AuthenticationService
    @State private var showingAuthentication = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            Group {
                if authService.authenticationState == .authenticated {
                    AuthenticatedProfileView(authService: authService, showingSettings: $showingSettings)
                } else {
                    UnauthenticatedProfileView(showingAuthentication: $showingAuthentication)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.countryBackground)
        }
        .sheet(isPresented: $showingAuthentication) {
            AuthenticationView(authService: authService)
        }
        .sheet(isPresented: $showingSettings) {
            if let user = authService.currentUser {
                UserSettingsView(authService: authService, user: user)
            }
        }
    }
}

struct AuthenticatedProfileView: View {
    @ObservedObject var authService: Auth0AuthenticationService
    @Binding var showingSettings: Bool
    
    var user: User? {
        authService.currentUser
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // User header
                VStack(spacing: 16) {
                    // Profile image
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.countryOrange, Color.countryLightOrange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Text(user?.displayName.prefix(2).uppercased() ?? "CP")
                            .font(.countryPalTitle)
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text(user?.displayName ?? "User")
                            .font(.countryPalTitle)
                            .foregroundColor(.countryTextPrimary)
                        
                        Text(user?.email ?? "")
                            .font(.countryPalBody)
                            .foregroundColor(.countryTextSecondary)
                        
                        HStack(spacing: 8) {
                            Image(systemName: user?.authProvider.iconName ?? "envelope.fill")
                                .font(.system(size: 12))
                            Text("Signed in with \(user?.authProvider.displayName ?? "Email")")
                                .font(.countryPalCaption)
                        }
                        .foregroundColor(.countryTextSecondary)
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 20)
                
                // Profile actions
                VStack(spacing: 16) {
                    ProfileActionRow(
                        icon: "gearshape.fill",
                        title: "Settings & Preferences",
                        subtitle: "Customize your CountryPal experience"
                    ) {
                        showingSettings = true
                    }
                    
                    ProfileActionRow(
                        icon: "bookmark.fill",
                        title: "Saved Events",
                        subtitle: "View your saved events"
                    ) {
                        // Navigate to saved events
                    }
                    
                    ProfileActionRow(
                        icon: "clock.fill",
                        title: "Event History",
                        subtitle: "See events you've attended"
                    ) {
                        // Navigate to event history
                    }
                    
                    ProfileActionRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Manage your notification preferences"
                    ) {
                        showingSettings = true
                    }
                    
                    ProfileActionRow(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help or contact us"
                    ) {
                        // Show help
                    }
                }
                .padding(.horizontal, 20)
                
                // Sign out button
                Button("Sign Out") {
                    authService.signOut()
                }
                .countryButtonStyle(isPrimary: false)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .padding(.bottom, 40)
        }
    }
}

struct UnauthenticatedProfileView: View {
    @Binding var showingAuthentication: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.countryGreen)
                
                VStack(spacing: 12) {
                    Text("Welcome to CountryPal")
                        .font(.countryPalTitle)
                        .foregroundColor(.countryTextPrimary)
                    
                    Text("Sign in to save events, get personalized recommendations, and connect with your community.")
                        .font(.countryPalBody)
                        .foregroundColor(.countryTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Button("Sign In or Create Account") {
                    showingAuthentication = true
                }
                .countryButtonStyle(isPrimary: true, size: .large)
                .padding(.top, 20)
            }
            
            Spacer()
            
            // Features preview
            VStack(alignment: .leading, spacing: 12) {
                Text("With an account you can:")
                    .font(.countryPalHeadline)
                    .foregroundColor(.countryTextPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "bookmark.heart", text: "Save your favorite events")
                    FeatureRow(icon: "bell.badge", text: "Get notifications for new events")
                    FeatureRow(icon: "person.3.fill", text: "Connect with your community")
                    FeatureRow(icon: "gearshape.2.fill", text: "Customize your preferences")
                }
            }
            .padding(20)
            .countryCard(elevation: 0.8)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

struct ProfileActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.countryOrange)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.countryPalSubheadline)
                        .foregroundColor(.countryTextPrimary)
                    
                    Text(subtitle)
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.countryTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .countryCard(elevation: 0.5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.countryGreen)
                .frame(width: 20)
            
            Text(text)
                .font(.countryPalBody)
                .foregroundColor(.countryTextSecondary)
            
            Spacer()
        }
    }
}

#Preview {
    MainTabView()
}