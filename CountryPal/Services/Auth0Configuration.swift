//
//  Auth0Configuration.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation

struct Auth0Configuration {
    // MARK: - Configuration
    
    // Auth0 credentials for CountryPal
    static let domain = "dev-mwjy0e12niaz6e0k.uk.auth0.com"
    static let clientId = "6I5QAhmGVPob6TKFRCxbWWmTVPzcTlmV"
    static let audience = "https://\(domain)/userinfo"
    
    // URL Scheme - should match your bundle identifier
    static let scheme = "mad-llama.CountryPal"
    
    // MARK: - Auth0 URLs
    
    static var callbackURL: String {
        return "\(scheme)://\(domain)/ios/\(scheme)/callback"
    }
    
    static var logoutURL: String {
        return "\(scheme)://\(domain)/ios/\(scheme)/callback"
    }
    
    // Alternative simplified URLs if the above don't work
    static var simpleCallbackURL: String {
        return "\(scheme)://callback"
    }
    
    // MARK: - Validation
    
    static var isConfigured: Bool {
        return !domain.contains("YOUR_AUTH0") && !clientId.contains("YOUR_AUTH0")
    }
    
    static func validateConfiguration() throws {
        guard isConfigured else {
            throw Auth0ConfigurationError.missingConfiguration
        }
    }
}

enum Auth0ConfigurationError: LocalizedError {
    case missingConfiguration
    
    var errorDescription: String? {
        switch self {
        case .missingConfiguration:
            return "Auth0 configuration is missing. Please update Auth0Configuration.swift with your Auth0 domain and client ID."
        }
    }
}

// MARK: - Setup Instructions

/*
 📋 Auth0 Setup Instructions:
 
 1. Update this file with your Auth0 credentials:
    - Replace YOUR_AUTH0_DOMAIN with your actual Auth0 domain
    - Replace YOUR_AUTH0_CLIENT_ID with your actual client ID
    - Update the scheme if using a different bundle identifier
 
 2. Configure your Auth0 Application:
    - Allowed Callback URLs: com.countrypal://YOUR_DOMAIN.auth0.com/ios/com.countrypal/callback
    - Allowed Logout URLs: com.countrypal://YOUR_DOMAIN.auth0.com/ios/com.countrypal/callback
    - Allowed Web Origins: (leave empty for native apps)
 
 3. Enable Social Connections in Auth0 Dashboard:
    - Go to Authentication > Social
    - Enable Google, Facebook, Apple as needed
    - Configure each provider with their respective credentials
 
 4. Xcode Configuration:
    - Add URL Type in project settings:
      - Identifier: auth0
      - URL Schemes: com.countrypal (or your bundle identifier)
 
 5. Info.plist entries (add these manually in Xcode):
    - NSCameraUsageDescription (if using profile photos)
    - NSPhotoLibraryUsageDescription (if using profile photos)
 */