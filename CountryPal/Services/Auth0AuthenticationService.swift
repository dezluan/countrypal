//
//  Auth0AuthenticationService.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import SwiftUI
import Auth0
import JWTDecode

@MainActor
class Auth0AuthenticationService: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "countrypal_current_user"
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain))
    
    init() {
        loadCurrentUser()
    }
    
    // MARK: - User Session Management
    
    private func loadCurrentUser() {
        // Check if we have stored credentials
        guard credentialsManager.hasValid() else {
            authenticationState = .unauthenticated
            return
        }
        
        // Load user data from UserDefaults
        guard let userData = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            authenticationState = .unauthenticated
            return
        }
        
        currentUser = user
        authenticationState = .authenticated
        
        // Optionally refresh the token in the background
        refreshTokenIfNeeded()
    }
    
    private func refreshTokenIfNeeded() {
        credentialsManager.renew { result in
            Task { @MainActor in
                switch result {
                case .success:
                    // Token refreshed successfully
                    break
                case .failure(let error):
                    print("Token refresh failed: \(error)")
                    // Don't automatically log out on refresh failure
                    // The user can continue with the current session
                }
            }
        }
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
        
        // Clear Auth0 credentials
        _ = credentialsManager.clear()
    }
    
    // MARK: - Auth0 Authentication
    
    func signInWithApple() async throws {
        try Auth0Configuration.validateConfiguration()
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth0
                .webAuth(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
                .connection("apple")
                .start { result in
                    Task { @MainActor in
                        self.isLoading = false
                        
                        switch result {
                        case .success(let credentials):
                            // Store credentials
                            _ = self.credentialsManager.store(credentials: credentials)
                            
                            // Get user profile
                            self.fetchUserProfile(from: credentials) { user in
                                if let user = user {
                                    self.saveCurrentUser(user)
                                    continuation.resume()
                                } else {
                                    let error = AuthenticationError.unknownError("Failed to fetch user profile")
                                    continuation.resume(throwing: error)
                                }
                            }
                            
                        case .failure(let error):
                            self.authenticationState = .unauthenticated
                            continuation.resume(throwing: self.mapAuth0Error(error))
                        }
                    }
                }
        }
    }
    
    func signInWithGoogle() async throws {
        try Auth0Configuration.validateConfiguration()
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth0
                .webAuth(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
                .connection("google-oauth2")
                .start { result in
                    Task { @MainActor in
                        self.isLoading = false
                        
                        switch result {
                        case .success(let credentials):
                            _ = self.credentialsManager.store(credentials: credentials)
                            
                            self.fetchUserProfile(from: credentials) { user in
                                if let user = user {
                                    self.saveCurrentUser(user)
                                    continuation.resume()
                                } else {
                                    let error = AuthenticationError.unknownError("Failed to fetch user profile")
                                    continuation.resume(throwing: error)
                                }
                            }
                            
                        case .failure(let error):
                            self.authenticationState = .unauthenticated
                            continuation.resume(throwing: self.mapAuth0Error(error))
                        }
                    }
                }
        }
    }
    
    func signInWithFacebook() async throws {
        try Auth0Configuration.validateConfiguration()
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth0
                .webAuth(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
                .connection("facebook")
                .start { result in
                    Task { @MainActor in
                        self.isLoading = false
                        
                        switch result {
                        case .success(let credentials):
                            _ = self.credentialsManager.store(credentials: credentials)
                            
                            self.fetchUserProfile(from: credentials) { user in
                                if let user = user {
                                    self.saveCurrentUser(user)
                                    continuation.resume()
                                } else {
                                    let error = AuthenticationError.unknownError("Failed to fetch user profile")
                                    continuation.resume(throwing: error)
                                }
                            }
                            
                        case .failure(let error):
                            self.authenticationState = .unauthenticated
                            continuation.resume(throwing: self.mapAuth0Error(error))
                        }
                    }
                }
        }
    }
    
    func registerWithEmail(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws {
        try Auth0Configuration.validateConfiguration()
        
        guard isValidEmail(email) else {
            throw AuthenticationError.invalidCredentials
        }
        
        guard password.count >= 6 else {
            throw AuthenticationError.weakPassword
        }
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        return try await withCheckedThrowingContinuation { continuation in
            // First create the user account
            Auth0
                .authentication(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
                .signup(
                    email: email,
                    password: password,
                    connection: "Username-Password-Authentication",
                    userMetadata: [
                        "given_name": firstName,
                        "family_name": lastName,
                        "name": "\(firstName) \(lastName)"
                    ]
                )
                .start { result in
                    Task { @MainActor in
                        switch result {
                        case .success:
                            // Now log them in
                            Task {
                                do {
                                    try await self.loginWithEmail(email: email, password: password)
                                    continuation.resume()
                                } catch {
                                    continuation.resume(throwing: error)
                                }
                            }
                            
                        case .failure(let error):
                            self.isLoading = false
                            self.authenticationState = .unauthenticated
                            continuation.resume(throwing: self.mapAuth0Error(error))
                        }
                    }
                }
        }
    }
    
    func loginWithEmail(email: String, password: String) async throws {
        try Auth0Configuration.validateConfiguration()
        
        guard isValidEmail(email) else {
            throw AuthenticationError.invalidCredentials
        }
        
        isLoading = true
        errorMessage = nil
        authenticationState = .authenticating
        
        return try await withCheckedThrowingContinuation { continuation in
            Auth0
                .authentication(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
                .login(
                    usernameOrEmail: email,
                    password: password,
                    realmOrConnection: "Username-Password-Authentication"
                )
                .start { result in
                    Task { @MainActor in
                        self.isLoading = false
                        
                        switch result {
                        case .success(let credentials):
                            _ = self.credentialsManager.store(credentials: credentials)
                            
                            self.fetchUserProfile(from: credentials) { user in
                                if let user = user {
                                    self.saveCurrentUser(user)
                                    continuation.resume()
                                } else {
                                    let error = AuthenticationError.unknownError("Failed to fetch user profile")
                                    continuation.resume(throwing: error)
                                }
                            }
                            
                        case .failure(let error):
                            self.authenticationState = .unauthenticated
                            continuation.resume(throwing: self.mapAuth0Error(error))
                        }
                    }
                }
        }
    }
    
    // MARK: - User Profile Management
    
    private func fetchUserProfile(from credentials: Credentials, completion: @escaping (User?) -> Void) {
        // Get user info from credentials idToken if available
        if !credentials.idToken.isEmpty,
           let jwt = try? decode(jwt: credentials.idToken) {
            let profile = jwt.body
            let user = createUser(from: profile, credentials: credentials)
            completion(user)
            return
        }
        
        // Fallback: fetch from Management API
        if !credentials.accessToken.isEmpty {
            // Extract user ID from access token or use a default approach
            let userId = extractUserIdFromCredentials(credentials)
            
            Auth0
                .users(token: credentials.accessToken, domain: Auth0Configuration.domain)
                .get(userId, fields: ["user_id", "email", "name", "given_name", "family_name", "picture"])
                .start { result in
                    Task { @MainActor in
                        switch result {
                        case .success(let profile):
                            let user = self.createUser(from: profile, credentials: credentials)
                            completion(user)
                            
                        case .failure(let error):
                            print("Failed to fetch user profile: \(error)")
                            // Create a basic user from credentials if profile fetch fails
                            let user = self.createBasicUser(from: credentials)
                            completion(user)
                        }
                    }
                }
        } else {
            completion(createBasicUser(from: credentials))
        }
    }
    
    private func extractUserIdFromCredentials(_ credentials: Credentials) -> String {
        // Try to extract user ID from ID token
        if !credentials.idToken.isEmpty,
           let jwt = try? decode(jwt: credentials.idToken),
           let sub = jwt.body["sub"] as? String {
            return sub
        }
        
        // Fallback to a default user ID pattern
        return "auth0|default"
    }
    
    private func createUser(from profile: [String: Any], credentials: Credentials) -> User {
        let email = profile["email"] as? String ?? ""
        let name = profile["name"] as? String ?? email
        let firstName = profile["given_name"] as? String
        let lastName = profile["family_name"] as? String
        let picture = profile["picture"] as? String
        let userId = profile["user_id"] as? String ?? profile["sub"] as? String ?? extractUserIdFromCredentials(credentials)
        
        // Determine auth provider based on user ID prefix
        let authProvider: AuthProvider
        if userId.hasPrefix("google") {
            authProvider = .google
        } else if userId.hasPrefix("facebook") {
            authProvider = .facebook
        } else if userId.hasPrefix("apple") {
            authProvider = .apple
        } else {
            authProvider = .manual
        }
        
        return User(
            id: userId,
            email: email,
            displayName: name,
            firstName: firstName,
            lastName: lastName,
            profileImageURL: picture,
            authProvider: authProvider
        )
    }
    
    private func createBasicUser(from credentials: Credentials) -> User {
        // Extract basic info from credentials
        let email = extractEmailFromCredentials(credentials)
        let name = extractNameFromCredentials(credentials) ?? email
        let userId = extractUserIdFromCredentials(credentials)
        
        return User(
            id: userId,
            email: email,
            displayName: name,
            authProvider: .manual
        )
    }
    
    private func extractEmailFromCredentials(_ credentials: Credentials) -> String {
        if !credentials.idToken.isEmpty,
           let jwt = try? decode(jwt: credentials.idToken),
           let email = jwt.body["email"] as? String {
            return email
        }
        return ""
    }
    
    private func extractNameFromCredentials(_ credentials: Credentials) -> String? {
        if !credentials.idToken.isEmpty,
           let jwt = try? decode(jwt: credentials.idToken),
           let name = jwt.body["name"] as? String {
            return name
        }
        return nil
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        Auth0
            .webAuth(clientId: Auth0Configuration.clientId, domain: Auth0Configuration.domain)
            .clearSession(federated: false) { [weak self] result in
                Task { @MainActor in
                    // Clear local session regardless of web logout result
                    self?.clearCurrentUser()
                    self?.errorMessage = nil
                }
            }
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
        
        // TODO: Update user profile on Auth0 server
        updateAuth0Profile(user: user)
    }
    
    private func updateAuth0Profile(user: User) {
        // Note: This requires async handling in v2.13.0
        Task {
            do {
                let accessToken = try await getValidAccessToken()
                
                let metadata: [String: Any] = [
                    "given_name": user.firstName ?? "",
                    "family_name": user.lastName ?? "",
                    "name": user.displayName
                ]
                
                Auth0
                    .users(token: accessToken, domain: Auth0Configuration.domain)
                    .patch(user.id, userMetadata: metadata)
                    .start { result in
                        switch result {
                        case .success:
                            print("User profile updated successfully")
                        case .failure(let error):
                            print("Failed to update user profile: \(error)")
                        }
                    }
            } catch {
                print("Failed to get access token for profile update: \(error)")
            }
        }
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
    
    private func mapAuth0Error(_ error: Error) -> AuthenticationError {
        if let webAuthError = error as? WebAuthError {
            switch webAuthError {
            case .userCancelled:
                return AuthenticationError.unknownError("Sign in was cancelled")
            case .noAuthorizationCode:
                return AuthenticationError.invalidCredentials
            case .pkceNotAllowed:
                return AuthenticationError.unknownError("Authentication method not allowed")
            default:
                return AuthenticationError.unknownError(webAuthError.localizedDescription)
            }
        }
        
        if let authError = error as? AuthenticationError {
            return authError
        }
        
        return AuthenticationError.networkError
    }
    
    // MARK: - Error Handling
    
    func handleAuthenticationError(_ error: Error) {
        isLoading = false
        authenticationState = .unauthenticated
        
        if let authError = error as? AuthenticationError {
            errorMessage = authError.errorDescription
        } else if let configError = error as? Auth0ConfigurationError {
            errorMessage = configError.errorDescription
        } else {
            errorMessage = "An unexpected error occurred. Please try again."
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Token Management

extension Auth0AuthenticationService {
    var isTokenValid: Bool {
        return credentialsManager.hasValid()
    }
    
    func getValidAccessToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            credentialsManager.credentials { result in
                switch result {
                case .success(let credentials):
                    continuation.resume(returning: credentials.accessToken)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}