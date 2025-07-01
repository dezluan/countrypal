//
//  EventCategory.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import SwiftUI

enum EventCategory: String, CaseIterable, Identifiable, Codable {
    case villageFete = "Village Fete"
    case farmersMarket = "Farmers Market"
    case bookSale = "Book Sale"
    case craftFair = "Craft Fair"
    case community = "Community Event"
    case seasonal = "Seasonal Event"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .villageFete:
            return .green
        case .farmersMarket:
            return .orange
        case .bookSale:
            return .blue
        case .craftFair:
            return .purple
        case .community:
            return .red
        case .seasonal:
            return .brown
        }
    }
    
    var systemImage: String {
        switch self {
        case .villageFete:
            return "house.fill"
        case .farmersMarket:
            return "leaf.fill"
        case .bookSale:
            return "book.fill"
        case .craftFair:
            return "paintbrush.fill"
        case .community:
            return "person.3.fill"
        case .seasonal:
            return "star.fill"
        }
    }
}