//
//  DesignSystem.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

// MARK: - Typography
extension Font {
    static let countryPalTitle = Font.custom("Georgia", size: 28).weight(.bold)
    static let countryPalLargeTitle = Font.custom("Georgia", size: 34).weight(.bold)
    static let countryPalHeadline = Font.custom("Georgia", size: 20).weight(.semibold)
    static let countryPalSubheadline = Font.custom("Georgia", size: 18).weight(.medium)
    static let countryPalBody = Font.system(size: 16, weight: .regular, design: .rounded)
    static let countryPalCaption = Font.system(size: 14, weight: .medium, design: .rounded)
    static let countryPalSmall = Font.system(size: 12, weight: .medium, design: .rounded)
}

// MARK: - Colors
extension Color {
    // Primary palette - earthy greens and warm oranges
    static let countryGreen = Color(red: 0.3, green: 0.5, blue: 0.3)           // Deep forest green
    static let countryLightGreen = Color(red: 0.5, green: 0.7, blue: 0.4)      // Sage green
    static let countryOrange = Color(red: 0.9, green: 0.6, blue: 0.3)          // Warm pumpkin orange
    static let countryLightOrange = Color(red: 0.95, green: 0.8, blue: 0.6)    // Soft peach
    
    // Supporting colors
    static let countryCream = Color(red: 0.98, green: 0.95, blue: 0.9)         // Warm cream
    static let countryBrown = Color(red: 0.6, green: 0.4, blue: 0.3)           // Rich earth brown
    static let countryGold = Color(red: 0.85, green: 0.7, blue: 0.4)           // Harvest gold
    
    // Text colors
    static let countryTextPrimary = Color(red: 0.2, green: 0.2, blue: 0.15)    // Dark brown-black
    static let countryTextSecondary = Color(red: 0.5, green: 0.4, blue: 0.3)   // Muted brown
    
    // Background colors
    static let countryBackground = Color(red: 0.99, green: 0.97, blue: 0.94)   // Very light cream
    static let countryCardBackground = Color.white
}

// MARK: - Custom Modifiers
struct CountryButtonStyle: ButtonStyle {
    let isPrimary: Bool
    let size: ButtonSize
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 25
            case .large: return 30
            }
        }
    }
    
    init(isPrimary: Bool = true, size: ButtonSize = .medium) {
        self.isPrimary = isPrimary
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.countryPalCaption)
            .foregroundColor(isPrimary ? .white : .countryGreen)
            .padding(size.padding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(isPrimary ? Color.countryGreen : Color.countryCream)
                    .overlay(
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .stroke(Color.countryGreen.opacity(0.3), lineWidth: isPrimary ? 0 : 2)
                    )
                    .shadow(
                        color: Color.countryGreen.opacity(0.2),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CountryCardStyle: ViewModifier {
    let elevation: CGFloat
    
    init(elevation: CGFloat = 1) {
        self.elevation = elevation
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.countryCardBackground)
                    .shadow(
                        color: Color.countryBrown.opacity(0.15),
                        radius: 8 * elevation,
                        x: 0,
                        y: 4 * elevation
                    )
                    .shadow(
                        color: Color.countryBrown.opacity(0.08),
                        radius: 2 * elevation,
                        x: 0,
                        y: 1 * elevation
                    )
            )
    }
}

struct CountryTagStyle: ViewModifier {
    let color: Color
    
    init(color: Color = .countryOrange) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .font(.countryPalSmall)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: color.opacity(0.3),
                        radius: 3,
                        x: 0,
                        y: 2
                    )
            )
    }
}

// MARK: - View Extensions
extension View {
    func countryButtonStyle(isPrimary: Bool = true, size: CountryButtonStyle.ButtonSize = .medium) -> some View {
        self.buttonStyle(CountryButtonStyle(isPrimary: isPrimary, size: size))
    }
    
    func countryCard(elevation: CGFloat = 1) -> some View {
        self.modifier(CountryCardStyle(elevation: elevation))
    }
    
    func countryTag(color: Color = .countryOrange) -> some View {
        self.modifier(CountryTagStyle(color: color))
    }
}

// MARK: - Category Color Extensions
extension EventCategory {
    var countryColor: Color {
        switch self {
        case .villageFete:
            return .countryGreen
        case .farmersMarket:
            return .countryOrange
        case .bookSale:
            return .countryBrown
        case .craftFair:
            return .countryGold
        case .community:
            return .countryLightGreen
        case .seasonal:
            return .countryLightOrange
        }
    }
}