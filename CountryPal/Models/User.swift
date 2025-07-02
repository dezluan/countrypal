//
//  User.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation

enum AuthProvider: String, CaseIterable, Codable {
    case manual = "manual"
    case apple = "apple"
    case google = "google"
    case facebook = "facebook"
    
    var displayName: String {
        switch self {
        case .manual:
            return "Email"
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        }
    }
    
    var iconName: String {
        switch self {
        case .manual:
            return "envelope.fill"
        case .apple:
            return "apple.logo"
        case .google:
            return "globe"
        case .facebook:
            return "f.circle.fill"
        }
    }
}

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

struct User: Identifiable, Codable {
    let id: String
    var email: String
    var displayName: String
    var firstName: String?
    var lastName: String?
    var profileImageURL: String?
    var authProvider: AuthProvider
    var preferences: UserPreferences
    var createdAt: Date
    var lastLoginAt: Date
    
    init(
        id: String = UUID().uuidString,
        email: String,
        displayName: String,
        firstName: String? = nil,
        lastName: String? = nil,
        profileImageURL: String? = nil,
        authProvider: AuthProvider,
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageURL = profileImageURL
        self.authProvider = authProvider
        self.preferences = preferences
        self.createdAt = Date()
        self.lastLoginAt = Date()
    }
}

struct UserPreferences: Codable {
    var notificationsEnabled: Bool = true
    var emailNotifications: Bool = true
    var pushNotifications: Bool = true
    var eventCategories: [EventCategory] = EventCategory.allCases
    var searchRadius: Double = 25.0 // kilometers
    var autoLocationUpdates: Bool = true
    var theme: AppTheme = .system
    
    enum AppTheme: String, CaseIterable, Codable {
        case light = "light"
        case dark = "dark"
        case system = "system"
        
        var displayName: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "System"
            }
        }
    }
}

// MARK: - Authentication Errors
enum AuthenticationError: LocalizedError, Identifiable {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknownError(String)
    
    var id: String {
        switch self {
        case .invalidCredentials:
            return "invalid_credentials"
        case .userNotFound:
            return "user_not_found"
        case .emailAlreadyInUse:
            return "email_already_in_use"
        case .weakPassword:
            return "weak_password"
        case .networkError:
            return "network_error"
        case .unknownError(let message):
            return "unknown_\(message)"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .userNotFound:
            return "No account found with this email address."
        case .emailAlreadyInUse:
            return "An account with this email already exists."
        case .weakPassword:
            return "Password must be at least 6 characters long."
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
}