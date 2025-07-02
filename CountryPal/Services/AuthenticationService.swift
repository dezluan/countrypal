//
//  AuthenticationService.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthenticationService: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "countrypal_current_user"
    
    init() {
        loadCurrentUser()
    }
    
    // MARK: - User Session Management
    
    private func loadCurrentUser() {
        guard let userData = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            authenticationState = .unauthenticated
            return
        }
        
        currentUser = user
        authenticationState = .authenticated
    }
    
    private func saveCurrentUser(_ user: User) {
        guard let userData = try? JSONEncoder().encode(user) else { return }
        userDefaults.set(userData, forKey: userKey)
        currentUser = user
        authenticationState = .authenticated
    }
    
    private func clearCurrentUser() {
        userDefaults.removeObject(forKey: userKey)
        currentUser = nil
        authenticationState = .unauthenticated
    }
    
    // MARK: - Manual Registration/Login
    
    func registerWithEmail(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws {
        guard isValidEmail(email) else {
            throw AuthenticationError.invalidCredentials
        }
        
        guard password.count >= 6 else {
            throw AuthenticationError.weakPassword
        }
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Check if user already exists (in real app, this would be server-side)
        if await userExists(email: email) {
            isLoading = false
            authenticationState = .unauthenticated
            throw AuthenticationError.emailAlreadyInUse
        }
        
        // Create new user
        let user = User(
            email: email,
            displayName: "\(firstName) \(lastName)",
            firstName: firstName,
            lastName: lastName,
            authProvider: .manual
        )
        
        saveCurrentUser(user)
        isLoading = false
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        guard isValidEmail(email) else {
            throw AuthenticationError.invalidCredentials
        }
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // In a real app, this would validate against a server
        // For demo purposes, we'll create a user if they don't exist
        if await !userExists(email: email) {
            isLoading = false
            authenticationState = .unauthenticated
            throw AuthenticationError.userNotFound
        }
        
        // Simulate successful login
        let user = User(
            email: email,
            displayName: email.components(separatedBy: "@").first?.capitalized ?? "User",
            authProvider: .manual
        )
        
        saveCurrentUser(user)
        isLoading = false
    }
    
    // MARK: - Social Authentication (Mock Implementation)
    
    func signInWithApple() async throws {
        isLoading = true
        authenticationState = .authenticating
        
        // Simulate Apple Sign In
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(
            email: "user@privaterelay.appleid.com",
            displayName: "Apple User",
            authProvider: .apple
        )
        
        saveCurrentUser(user)
        isLoading = false
    }
    
    func signInWithGoogle() async throws {
        isLoading = true
        authenticationState = .authenticating
        
        // Simulate Google Sign In
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(
            email: "user@gmail.com",
            displayName: "Google User",
            authProvider: .google
        )
        
        saveCurrentUser(user)
        isLoading = false
    }
    
    func signInWithFacebook() async throws {
        isLoading = true
        authenticationState = .authenticating
        
        // Simulate Facebook Sign In
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(
            email: "user@facebook.com",
            displayName: "Facebook User",
            authProvider: .facebook
        )
        
        saveCurrentUser(user)
        isLoading = false
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        clearCurrentUser()
        errorMessage = nil
    }
    
    // MARK: - User Profile Updates
    
    func updateUserProfile(
        displayName: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil
    ) {
        guard var user = currentUser else { return }
        
        if let displayName = displayName {
            user.displayName = displayName
        }
        if let firstName = firstName {
            user.firstName = firstName
        }
        if let lastName = lastName {
            user.lastName = lastName
        }
        
        saveCurrentUser(user)
    }
    
    func updateUserPreferences(_ preferences: UserPreferences) {
        guard var user = currentUser else { return }
        user.preferences = preferences
        saveCurrentUser(user)
    }
    
    // MARK: - Helper Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func userExists(email: String) async -> Bool {
        // In a real app, this would check against your backend
        // For demo purposes, we'll simulate that some users exist
        let existingEmails = ["test@example.com", "demo@countrypal.com"]
        return existingEmails.contains(email.lowercased())
    }
    
    // MARK: - Error Handling
    
    func handleAuthenticationError(_ error: Error) {
        isLoading = false
        authenticationState = .unauthenticated
        
        if let authError = error as? AuthenticationError {
            errorMessage = authError.errorDescription
        } else {
            errorMessage = "An unexpected error occurred. Please try again."
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}