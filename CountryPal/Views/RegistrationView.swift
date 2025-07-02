//
//  RegistrationView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var authService: Auth0AuthenticationService
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    @FocusState private var focusedField: RegistrationField?
    
    enum RegistrationField {
        case firstName, lastName, email, password, confirmPassword
    }
    
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreedToTerms
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Create Account")
                            .font(.countryPalTitle)
                            .foregroundColor(.countryTextPrimary)
                        
                        Text("Join the CountryPal community")
                            .font(.countryPalBody)
                            .foregroundColor(.countryTextSecondary)
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Name fields
                        HStack(spacing: 12) {
                            AuthTextField(
                                title: "First Name",
                                text: $firstName,
                                icon: "person.fill"
                            )
                            .focused($focusedField, equals: .firstName)
                            
                            AuthTextField(
                                title: "Last Name",
                                text: $lastName,
                                icon: "person.fill"
                            )
                            .focused($focusedField, equals: .lastName)
                        }
                        
                        // Email field
                        AuthTextField(
                            title: "Email Address",
                            text: $email,
                            icon: "envelope.fill"
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        
                        // Password field
                        AuthTextField(
                            title: "Password",
                            text: $password,
                            icon: "lock.fill",
                            isSecure: true
                        )
                        .focused($focusedField, equals: .password)
                        
                        // Confirm password field
                        AuthTextField(
                            title: "Confirm Password",
                            text: $confirmPassword,
                            icon: "lock.fill",
                            isSecure: true
                        )
                        .focused($focusedField, equals: .confirmPassword)
                        
                        // Password validation
                        if !password.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ValidationRow(
                                    text: "At least 6 characters",
                                    isValid: password.count >= 6
                                )
                                ValidationRow(
                                    text: "Passwords match",
                                    isValid: !confirmPassword.isEmpty && password == confirmPassword
                                )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Terms and conditions
                        Button(action: {
                            agreedToTerms.toggle()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 20))
                                    .foregroundColor(agreedToTerms ? .countryGreen : .countryTextSecondary)
                                
                                Text("I agree to the Terms of Service and Privacy Policy")
                                    .font(.countryPalCaption)
                                    .foregroundColor(.countryTextSecondary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Error message
                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .font(.countryPalCaption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Register button
                    Button("Create Account") {
                        Task {
                            do {
                                try await authService.registerWithEmail(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    lastName: lastName
                                )
                                dismiss()
                            } catch {
                                authService.handleAuthenticationError(error)
                            }
                        }
                    }
                    .countryButtonStyle(isPrimary: true, size: .large)
                    .disabled(!isFormValid || authService.isLoading)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    
                    if authService.isLoading {
                        ProgressView("Creating account...")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                    }
                    
                    // Sign in link
                    Button("Already have an account? Sign In") {
                        dismiss()
                        // Show login view instead
                    }
                    .font(.countryPalCaption)
                    .foregroundColor(.countryGreen)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.countryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
            }
            .onTapGesture {
                focusedField = nil
                authService.clearError()
            }
        }
    }
}

struct LoginView: View {
    @ObservedObject var authService: Auth0AuthenticationService
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingForgotPassword = false
    
    @FocusState private var focusedField: LoginField?
    
    enum LoginField {
        case email, password
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("Welcome Back")
                        .font(.countryPalTitle)
                        .foregroundColor(.countryTextPrimary)
                    
                    Text("Sign in to your CountryPal account")
                        .font(.countryPalBody)
                        .foregroundColor(.countryTextSecondary)
                }
                .padding(.top, 40)
                
                // Form
                VStack(spacing: 20) {
                    AuthTextField(
                        title: "Email Address",
                        text: $email,
                        icon: "envelope.fill"
                    )
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .email)
                    
                    AuthTextField(
                        title: "Password",
                        text: $password,
                        icon: "lock.fill",
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    
                    // Forgot password
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            showingForgotPassword = true
                        }
                        .font(.countryPalCaption)
                        .foregroundColor(.countryGreen)
                    }
                }
                
                // Error message
                if let errorMessage = authService.errorMessage {
                    Text(errorMessage)
                        .font(.countryPalCaption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                // Sign in button
                VStack(spacing: 16) {
                    Button("Sign In") {
                        Task {
                            do {
                                try await authService.loginWithEmail(
                                    email: email,
                                    password: password
                                )
                                dismiss()
                            } catch {
                                authService.handleAuthenticationError(error)
                            }
                        }
                    }
                    .countryButtonStyle(isPrimary: true, size: .large)
                    .disabled(!isFormValid || authService.isLoading)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    
                    if authService.isLoading {
                        ProgressView("Signing in...")
                            .font(.countryPalCaption)
                            .foregroundColor(.countryTextSecondary)
                    }
                }
                
                Spacer()
                
                // Create account link
                Button("Don't have an account? Create one") {
                    dismiss()
                    // Show registration view instead
                }
                .font(.countryPalCaption)
                .foregroundColor(.countryGreen)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
            .background(Color.countryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.countryGreen)
                }
            }
            .onTapGesture {
                focusedField = nil
                authService.clearError()
            }
            .alert("Reset Password", isPresented: $showingForgotPassword) {
                Button("Cancel", role: .cancel) { }
                Button("Send Reset Email") {
                    // Handle password reset
                }
            } message: {
                Text("Enter your email address and we'll send you a link to reset your password.")
            }
        }
    }
}

struct AuthTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.countryPalCaption)
                .foregroundColor(.countryTextSecondary)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.countryGreen)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField("", text: $text)
                        .font(.countryPalBody)
                } else {
                    TextField("", text: $text)
                        .font(.countryPalBody)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.countryCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.countryGreen.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

struct ValidationRow: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14))
                .foregroundColor(isValid ? .countryGreen : .countryTextSecondary)
            
            Text(text)
                .font(.countryPalCaption)
                .foregroundColor(isValid ? .countryGreen : .countryTextSecondary)
            
            Spacer()
        }
    }
}

#Preview {
    RegistrationView(authService: Auth0AuthenticationService())
}