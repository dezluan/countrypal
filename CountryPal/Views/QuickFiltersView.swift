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
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.accentColor : Color(.systemGray6))
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