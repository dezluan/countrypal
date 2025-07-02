//
//  AuthenticationView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authService: Auth0AuthenticationService
    @State private var showingRegistration = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with app branding
                VStack(spacing: 20) {
                    Spacer()
                    
                    // App icon/logo area
                    VStack(spacing: 16) {
                        Image(systemName: "map.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.countryOrange)
                        
                        Text("CountryPal")
                            .font(.countryPalLargeTitle)
                            .foregroundColor(.countryTextPrimary)
                        
                        Text("Discover Local Community Events")
                            .font(.countryPalBody)
                            .foregroundColor(.countryTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                // Authentication options
                VStack(spacing: 20) {
                    // Social authentication buttons
                    VStack(spacing: 16) {
                        SocialAuthButton(
                            provider: .apple,
                            isLoading: authService.isLoading
                        ) {
                            Task {
                                do {
                                    try await authService.signInWithApple()
                                } catch {
                                    authService.handleAuthenticationError(error)
                                }
                            }
                        }
                        
                        SocialAuthButton(
                            provider: .google,
                            isLoading: authService.isLoading
                        ) {
                            Task {
                                do {
                                    try await authService.signInWithGoogle()
                                } catch {
                                    authService.handleAuthenticationError(error)
                                }
                            }
                        }
                        
                        SocialAuthButton(
                            provider: .facebook,
                            isLoading: authService.isLoading
                        ) {
                            Task {
                                do {
                                    try await authService.signInWithFacebook()
                                } catch {
                                    authService.handleAuthenticationError(error)
                                }
                            }
                        }
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.countryTextSecondary.opacity(0.3))
                            .frame(height: 1)
                        Text("or")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                            .padding(.horizontal, 16)
                        Rectangle()
                            .fill(Color.countryTextSecondary.opacity(0.3))
                            .frame(height: 1)
                    }
                    
                    // Email authentication buttons
                    VStack(spacing: 12) {
                        Button("Sign In with Email") {
                            showingRegistration = false
                        }
                        .countryButtonStyle(isPrimary: false)
                        
                        Button("Create Account") {
                            showingRegistration = true
                        }
                        .countryButtonStyle(isPrimary: true)
                    }
                    
                    // Error message
                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .font(.countryPalCaption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.countryBackground,
                        Color.countryCream
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .sheet(isPresented: $showingRegistration) {
                if showingRegistration {
                    RegistrationView(authService: authService)
                } else {
                    LoginView(authService: authService)
                }
            }
            .onTapGesture {
                authService.clearError()
            }
        }
    }
}

struct SocialAuthButton: View {
    let provider: AuthProvider
    let isLoading: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        switch provider {
        case .apple:
            return .black
        case .google:
            return .white
        case .facebook:
            return Color(red: 0.26, green: 0.40, blue: 0.70)
        case .manual:
            return .countryGreen
        }
    }
    
    var textColor: Color {
        switch provider {
        case .apple, .facebook:
            return .white
        case .google:
            return .black
        case .manual:
            return .white
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: provider.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(textColor)
                
                Text("Continue with \(provider.displayName)")
                    .font(.countryPalCaption)
                    .foregroundColor(textColor)
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(textColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.countryTextSecondary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(
                        color: backgroundColor.opacity(0.2),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
        }
        .disabled(isLoading)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AuthenticationView(authService: Auth0AuthenticationService())
}