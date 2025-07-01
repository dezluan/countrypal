//
//  Event.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let category: EventCategory
    let startDate: Date
    let endDate: Date
    let location: EventLocation
    let contactInfo: String
    let imageURL: String?
    let isSponsored: Bool
    
    init(
        title: String,
        description: String,
        category: EventCategory,
        startDate: Date,
        endDate: Date,
        location: EventLocation,
        contactInfo: String,
        imageURL: String? = nil,
        isSponsored: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.contactInfo = contactInfo
        self.imageURL = imageURL
        self.isSponsored = isSponsored
    }
    
    var isUpcoming: Bool {
        return startDate > Date()
    }
    
    var isOngoing: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    var isPast: Bool {
        return endDate < Date()
    }
    
    var durationText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            return "\(formatter.string(from: startDate)) - \(timeFormatter.string(from: endDate))"
        } else {
            return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        }
    }
    
    enum CodingKeys: CodingKey {
        case id, title, description, category, startDate, endDate, location, contactInfo, imageURL, isSponsored
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(EventCategory.self, forKey: .category)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        location = try container.decode(EventLocation.self, forKey: .location)
        contactInfo = try container.decode(String.self, forKey: .contactInfo)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        isSponsored = try container.decode(Bool.self, forKey: .isSponsored)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(location, forKey: .location)
        try container.encode(contactInfo, forKey: .contactInfo)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encode(isSponsored, forKey: .isSponsored)
    }
}