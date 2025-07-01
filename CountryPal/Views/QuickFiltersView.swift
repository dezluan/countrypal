//
//  QuickFiltersView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct QuickFiltersView: View {
    @Binding var thisWeekendSelected: Bool
    @Binding var nearMeSelected: Bool
    @Binding var familyFriendlySelected: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                QuickFilterButton(
                    title: "This Weekend",
                    icon: "calendar.badge.plus",
                    isSelected: thisWeekendSelected
                ) {
                    thisWeekendSelected.toggle()
                }
                
                QuickFilterButton(
                    title: "Near Me",
                    icon: "location.circle.fill",
                    isSelected: nearMeSelected
                ) {
                    nearMeSelected.toggle()
                }
                
                QuickFilterButton(
                    title: "Family Friendly",
                    icon: "figure.and.child.holdinghands",
                    isSelected: familyFriendlySelected
                ) {
                    familyFriendlySelected.toggle()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuickFilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.countryPalSmall)
                Text(title)
                    .font(.countryPalSmall)
            }
            .foregroundColor(isSelected ? .white : .countryGreen)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isSelected ? Color.countryGreen : Color.countryCream)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.countryGreen.opacity(0.3), lineWidth: isSelected ? 0 : 2)
                    )
                    .shadow(
                        color: Color.countryGreen.opacity(isSelected ? 0.3 : 0.15),
                        radius: isSelected ? 6 : 4,
                        x: 0,
                        y: isSelected ? 3 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuickFiltersView(
        thisWeekendSelected: .constant(true),
        nearMeSelected: .constant(false),
        familyFriendlySelected: .constant(false)
    )
}