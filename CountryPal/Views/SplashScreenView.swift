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
                // Background gradient - sunrise inspired
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 1.0, green: 0.95, blue: 0.8), location: 0.0), // Warm sunrise yellow
                        .init(color: Color(red: 0.95, green: 0.98, blue: 0.9), location: 0.3), // Soft morning sky
                        .init(color: Color(red: 0.85, green: 0.95, blue: 0.85), location: 0.7), // Gentle green
                        .init(color: Color.countryLightGreen.opacity(0.6), location: 1.0) // Rolling hills base
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .opacity(backgroundGradientOpacity)
                
                // Countryside scene illustration
                VStack(spacing: 0) {
                    // Colorful bunting at top
                    BuntingView()
                        .opacity(farmElementsOpacity)
                        .offset(y: farmElementsOffset)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // Main countryside scene
                    CountrysideSceneView()
                        .opacity(farmElementsOpacity)
                        .offset(y: farmElementsOffset)
                    
                    Spacer()
                    
                    // Clean UI space for logo
                    VStack(spacing: 20) {
                        // App logo/title in clean space
                        VStack(spacing: 8) {
                            Text("CountryPal")
                                .font(.system(size: 36, weight: .light, design: .serif))
                                .foregroundColor(.countryGreen.opacity(0.9))
                                .scaleEffect(logoScale)
                                .opacity(logoOpacity)
                            
                            Text("Discover Local Community Events")
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.countryTextSecondary.opacity(0.8))
                                .opacity(textOpacity)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .opacity(0.6)
                        )
                        
                        // Subtle loading indicator
                        if isLoading {
                            HStack(spacing: 6) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .fill(Color.countryGreen.opacity(0.6))
                                        .frame(width: 6, height: 6)
                                        .scaleEffect(logoScale)
                                        .animation(
                                            .easeInOut(duration: 0.8)
                                            .repeatForever()
                                            .delay(Double(index) * 0.3),
                                            value: logoScale
                                        )
                                }
                            }
                            .padding(.top, 16)
                            .opacity(textOpacity)
                        }
                    }
                    .padding(.bottom, 100)
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

// MARK: - Colorful Bunting View
struct BuntingView: View {
    @State private var bunting1Sway: Double = 0
    @State private var bunting2Sway: Double = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // Left bunting string
            BuntingString(colors: [.red, .blue, .green, .yellow, .orange], sway: bunting1Sway)
                .rotationEffect(.degrees(bunting1Sway * 0.5))
            
            Spacer()
            
            // Right bunting string
            BuntingString(colors: [.purple, .pink, .cyan, .mint, .indigo], sway: bunting2Sway)
                .rotationEffect(.degrees(-bunting2Sway * 0.5))
        }
        .frame(height: 40)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                bunting1Sway = 2
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                bunting2Sway = 1.5
            }
        }
    }
}

struct BuntingString: View {
    let colors: [Color]
    let sway: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<colors.count, id: \.self) { index in
                BuntingFlag(color: colors[index])
                    .offset(y: sin(sway + Double(index) * 0.5) * 2)
            }
        }
    }
}

struct BuntingFlag: View {
    let color: Color
    
    var body: some View {
        VStack(spacing: 1) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 8)
            
            // Triangle flag
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 16, y: 0))
                path.addLine(to: CGPoint(x: 8, y: 12))
                path.closeSubpath()
            }
            .fill(color.opacity(0.8))
            .frame(width: 16, height: 12)
        }
    }
}

// MARK: - Modern Countryside Scene
struct CountrysideSceneView: View {
    @State private var sunGlow: Double = 0.5
    @State private var cloudDrift: CGFloat = 0
    @State private var iconFloat: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Rolling green hills in background
            RollingHillsView()
            
            // Gentle sunrise
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.8),
                            Color.orange.opacity(0.4),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 40
                    )
                )
                .frame(width: 60, height: 60)
                .offset(x: 100, y: -60)
                .scaleEffect(1.0 + sunGlow * 0.1)
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: sunGlow)
            
            // Small village with stone church
            VillageView()
                .offset(y: 20)
            
            // Minimalist embedded icons
            MinimalistIconsView()
                .offset(y: iconFloat)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: iconFloat)
            
            // Soft clouds
            CloudsView(drift: cloudDrift)
        }
        .frame(width: 350, height: 200)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                sunGlow = 1.0
            }
            withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                cloudDrift = 50
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                iconFloat = -2
            }
        }
    }
}

struct RollingHillsView: View {
    var body: some View {
        ZStack {
            // Background hills (furthest)
            HStack(spacing: -30) {
                ForEach(0..<4) { index in
                    Ellipse()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green.opacity(0.3),
                                    Color.green.opacity(0.5)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 100 + CGFloat(index * 15), height: 40 + CGFloat(index * 8))
                        .offset(y: 50 + CGFloat(index * 3))
                }
            }
            
            // Foreground hills
            HStack(spacing: -40) {
                ForEach(0..<3) { index in
                    Ellipse()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.countryLightGreen.opacity(0.7),
                                    Color.countryGreen.opacity(0.8)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 120 + CGFloat(index * 20), height: 60 + CGFloat(index * 10))
                        .offset(y: 60 + CGFloat(index * 5))
                }
            }
        }
    }
}

struct VillageView: View {
    var body: some View {
        HStack(spacing: 20) {
            // Stone church
            VStack(spacing: 2) {
                // Church spire
                SplashTriangle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 16, height: 20)
                
                // Church tower
                Rectangle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 20, height: 35)
                    .overlay(
                        // Church window
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 8, height: 12)
                            .offset(y: -5)
                    )
                
                // Church base
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 40, height: 25)
                    .overlay(
                        // Door
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.brown.opacity(0.8))
                            .frame(width: 10, height: 15)
                            .offset(y: 5)
                    )
            }
            
            // Small cottages
            HStack(spacing: 8) {
                ForEach(0..<2) { _ in
                    VStack(spacing: 1) {
                        // Roof
                        SplashTriangle()
                            .fill(Color.red.opacity(0.7))
                            .frame(width: 25, height: 15)
                        
                        // House
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 25, height: 20)
                            .overlay(
                                HStack(spacing: 3) {
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.5))
                                        .frame(width: 5, height: 5)
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.5))
                                        .frame(width: 5, height: 5)
                                }
                                .offset(y: -3)
                            )
                    }
                }
            }
        }
    }
}

struct MinimalistIconsView: View {
    var body: some View {
        HStack(spacing: 60) {
            // Book icon (subtly embedded)
            Image(systemName: "book.fill")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.countryGreen.opacity(0.6))
                .padding(8)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                )
            
            // Market stall icon
            Image(systemName: "storefront.fill")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.countryOrange.opacity(0.6))
                .padding(8)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                )
            
            // Tent icon
            Image(systemName: "tent.fill")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.countryBrown.opacity(0.6))
                .padding(8)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                )
        }
        .offset(y: 30)
    }
}

struct CloudsView: View {
    let drift: CGFloat
    
    var body: some View {
        ZStack {
            // Soft white clouds
            ForEach(0..<3) { index in
                Ellipse()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 40 + CGFloat(index * 10), height: 15 + CGFloat(index * 3))
                    .offset(
                        x: -100 + CGFloat(index * 80) + drift,
                        y: -40 - CGFloat(index * 15)
                    )
            }
        }
    }
}

// Helper shape for triangles
struct SplashTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SplashScreenView()
}