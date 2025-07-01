//
//  SplashScreenView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var farmElementsOpacity: Double = 0
    @State private var farmElementsOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var backgroundGradientOpacity: Double = 0
    @State private var showMainApp = false
    
    var body: some View {
        if showMainApp {
            MainTabView()
                .transition(.opacity.combined(with: .scale))
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.countryBackground,
                        Color.countryCream,
                        Color.countryLightOrange.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .opacity(backgroundGradientOpacity)
                
                // Farm scene illustration
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main farm scene
                    FarmSceneView()
                        .opacity(farmElementsOpacity)
                        .offset(y: farmElementsOffset)
                    
                    Spacer()
                    
                    // App branding
                    VStack(spacing: 16) {
                        // App logo/title
                        Text("CountryPal")
                            .font(.countryPalLargeTitle)
                            .foregroundColor(.countryGreen)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                        
                        // Tagline
                        Text("Discover Local Community Events")
                            .font(.countryPalSubheadline)
                            .foregroundColor(.countryTextSecondary)
                            .opacity(textOpacity)
                        
                        // Loading indicator
                        if isLoading {
                            HStack(spacing: 8) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .fill(Color.countryOrange)
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(logoScale)
                                        .animation(
                                            .easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                            value: logoScale
                                        )
                                }
                            }
                            .padding(.top, 20)
                            .opacity(textOpacity)
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            .onAppear {
                startSplashAnimation()
            }
        }
    }
    
    private func startSplashAnimation() {
        // Background appears first
        withAnimation(.easeOut(duration: 0.8)) {
            backgroundGradientOpacity = 1.0
        }
        
        // Logo animation
        withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Farm scene animation
        withAnimation(.easeOut(duration: 1.2).delay(0.6)) {
            farmElementsOpacity = 1.0
            farmElementsOffset = 0
        }
        
        // Text animation
        withAnimation(.easeOut(duration: 0.8).delay(1.0)) {
            textOpacity = 1.0
        }
        
        // Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showMainApp = true
            }
        }
    }
}

struct FarmSceneView: View {
    @State private var basketBounce: CGFloat = 0
    @State private var leafSway: Double = 0
    @State private var sunGlow: Double = 0.5
    
    var body: some View {
        ZStack {
            // Background hills
            HStack(spacing: -20) {
                // Rolling hills
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 50)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.countryLightGreen.opacity(0.6),
                                    Color.countryGreen.opacity(0.3)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 120, height: 60 + CGFloat(index * 10))
                        .offset(y: CGFloat(index * 5))
                }
            }
            .offset(y: 40)
            
            // Sun
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.countryGold,
                            Color.countryOrange.opacity(0.8)
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 30
                    )
                )
                .frame(width: 50, height: 50)
                .offset(x: 80, y: -80)
                .scaleEffect(1.0 + sunGlow * 0.1)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: sunGlow)
            
            // Farm elements
            HStack(spacing: 30) {
                // Market stall
                VStack(spacing: 8) {
                    // Stall roof
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.countryBrown)
                        .frame(width: 70, height: 12)
                    
                    // Stall structure
                    Rectangle()
                        .fill(Color.countryCream)
                        .frame(width: 60, height: 40)
                        .overlay(
                            // Produce display
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.countryOrange)
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(Color.red.opacity(0.7))
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(Color.countryGold)
                                    .frame(width: 8, height: 8)
                            }
                            .offset(y: -8)
                        )
                }
                
                // Produce basket
                VStack(spacing: 2) {
                    // Vegetables/fruits
                    HStack(spacing: 2) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.countryLightGreen)
                            .font(.system(size: 12))
                            .rotationEffect(.degrees(leafSway))
                        Image(systemName: "carrot.fill")
                            .foregroundColor(.countryOrange)
                            .font(.system(size: 10))
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.countryGreen)
                            .font(.system(size: 12))
                            .rotationEffect(.degrees(-leafSway))
                    }
                    
                    // Basket
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.countryBrown.opacity(0.8))
                        .frame(width: 40, height: 20)
                        .overlay(
                            // Basket weave pattern
                            VStack(spacing: 2) {
                                ForEach(0..<3) { _ in
                                    Rectangle()
                                        .fill(Color.countryBrown)
                                        .frame(height: 1)
                                }
                            }
                            .opacity(0.6)
                        )
                }
                .offset(y: basketBounce)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: basketBounce)
                
                // Farm truck/cart
                VStack(spacing: 4) {
                    // Truck bed with produce
                    Rectangle()
                        .fill(Color.countryGreen.opacity(0.8))
                        .frame(width: 50, height: 20)
                        .overlay(
                            HStack(spacing: 3) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.countryOrange)
                                    .font(.system(size: 6))
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red.opacity(0.7))
                                    .font(.system(size: 6))
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.countryGold)
                                    .font(.system(size: 6))
                            }
                            .offset(y: -6)
                        )
                    
                    // Wheels
                    HStack(spacing: 20) {
                        Circle()
                            .fill(Color.countryBrown)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.countryBrown)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .offset(y: 10)
        }
        .frame(width: 300, height: 200)
        .onAppear {
            // Start gentle animations
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                basketBounce = -3
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                leafSway = 10
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                sunGlow = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}