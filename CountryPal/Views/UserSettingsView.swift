//
//  UserSettingsView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var authService: Auth0AuthenticationService
    @State var user: User
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditProfile = false
    @State private var tempPreferences: UserPreferences
    
    init(authService: Auth0AuthenticationService, user: User) {
        self.authService = authService
        self._user = State(initialValue: user)
        self._tempPreferences = State(initialValue: user.preferences)
    }
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.countryPalTitle)
                .foregroundColor(.countryTextPrimary)
            Text("Settings coming soon...")
                .font(.countryPalBody)
                .foregroundColor(.countryTextSecondary)
        }
        .background(Color.countryBackground)
        /* NavigationStack {
            List {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
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
                                .frame(width: 60, height: 60)
                            
                            Text(user.displayName.prefix(2).uppercased())
                                .font(.countryPalHeadline)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.displayName)
                                .font(.countryPalSubheadline)
                                .foregroundColor(.countryTextPrimary)
                            
                            Text(user.email)
                                .font(.countryPalCaption)
                                .foregroundColor(.countryTextSecondary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: user.authProvider.iconName)
                                    .font(.system(size: 12))
                                Text(user.authProvider.displayName)
                                    .font(.countryPalCaption)
                            }
                            .foregroundColor(.countryGreen)
                        }
                        
                        Spacer()
                        
                        Button("Edit") {
                            showingEditProfile = true
                        }
                        .font(.countryPalCaption)
                        .foregroundColor(.countryOrange)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Profile")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // Notifications Section
                Section {
                    Toggle("Push Notifications", isOn: $tempPreferences.pushNotifications)
                        .font(.countryPalBody)
                    
                    Toggle("Email Notifications", isOn: $tempPreferences.emailNotifications)
                        .font(.countryPalBody)
                        .disabled(!tempPreferences.notificationsEnabled)
                    
                    Toggle("All Notifications", isOn: $tempPreferences.notificationsEnabled)
                        .font(.countryPalBody)
                } header: {
                    Text("Notifications")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                } footer: {
                    Text("Manage how you receive updates about new events and community activities.")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // Location Section
                Section {
                    Toggle("Auto Location Updates", isOn: $tempPreferences.autoLocationUpdates)
                        .font(.countryPalBody)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Search Radius")
                                .font(.countryPalBody)
                            Spacer()
                            Text("\(Int(tempPreferences.searchRadius)) km")
                                .font(.countryPalCaption)
                                .foregroundColor(.countryTextSecondary)
                        }
                        
                        Slider(
                            value: $tempPreferences.searchRadius,
                            in: 5...100,
                            step: 5
                        )
                        .accentColor(.countryOrange)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Location & Search")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                } footer: {
                    Text("Control how we use your location to find nearby events.")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // Event Preferences Section
                Section {
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        HStack {
                            Image(systemName: category.systemImage)
                                .foregroundColor(category.countryColor)
                                .frame(width: 24)
                            
                            Text(category.rawValue)
                                .font(.countryPalBody)
                            
                            Spacer()
                            
                            if tempPreferences.eventCategories.contains(category) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.countryGreen)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if tempPreferences.eventCategories.contains(category) {
                                tempPreferences.eventCategories.removeAll { $0 == category }
                            } else {
                                tempPreferences.eventCategories.append(category)
                            }
                        }
                    }
                } header: {
                    Text("Event Categories")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                } footer: {
                    Text("Select the types of events you're most interested in.")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // App Theme Section
                Section {
                    Picker("Theme", selection: $tempPreferences.theme) {
                        ForEach(UserPreferences.AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Appearance")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                } footer: {
                    Text("Choose your preferred app appearance.")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                // Account Actions Section
                Section {
                    Button("Sign Out") {
                        authService.signOut()
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .font(.countryPalBody)
                } header: {
                    Text("Account")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        user.preferences = tempPreferences
                        authService.updateUserPreferences(tempPreferences)
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
            }
            .background(Color.countryBackground)
            .tint(.countryOrange)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(authService: authService, user: $user)
        }
    }
}

struct EditProfileView: View {
    @ObservedObject var authService: AuthenticationService
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Display Name")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                        TextField("Display Name", text: $displayName)
                            .font(.countryPalBody)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                        TextField("First Name", text: $firstName)
                            .font(.countryPalBody)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                        TextField("Last Name", text: $lastName)
                            .font(.countryPalBody)
                    }
                } header: {
                    Text("Personal Information")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
                
                Section {
                    HStack {
                        Text("Email Address")
                            .font(.countryPalBody)
                        Spacer()
                        Text(user.email)
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                    }
                    
                    HStack {
                        Text("Sign In Method")
                            .font(.countryPalBody)
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: user.authProvider.iconName)
                                .font(.system(size: 14))
                            Text(user.authProvider.displayName)
                                .font(.countryPalCaption)
                        }
                        .foregroundColor(.countryGreen)
                    }
                } header: {
                    Text("Account Information")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                } footer: {
                    Text("Email and sign-in method cannot be changed.")
                        .font(.countryPalCaption)
                        .foregroundColor(.countryTextSecondary)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        authService.updateUserProfile(
                            displayName: displayName.isEmpty ? nil : displayName,
                            firstName: firstName.isEmpty ? nil : firstName,
                            lastName: lastName.isEmpty ? nil : lastName
                        )
                        
                        // Update local user object
                        if !displayName.isEmpty {
                            user.displayName = displayName
                        }
                        if !firstName.isEmpty {
                            user.firstName = firstName
                        }
                        if !lastName.isEmpty {
                            user.lastName = lastName
                        }
                        
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
            }
            .background(Color.countryBackground)
        }
        .onAppear {
            displayName = user.displayName
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
        } */
    }
}

#Preview {
    UserSettingsView(
        authService: Auth0AuthenticationService(),
        user: User(
            email: "test@example.com",
            displayName: "Test User",
            authProvider: .manual
        )
    )
}