//
//  EventLocation.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import CoreLocation

struct EventLocation: Identifiable, Codable, Equatable {
    let id: UUID
    let address: String
    let coordinate: CLLocationCoordinate2D
    let venue: String
    
    init(address: String, coordinate: CLLocationCoordinate2D, venue: String) {
        self.id = UUID()
        self.address = address
        self.coordinate = coordinate
        self.venue = venue
    }
    
    enum CodingKeys: CodingKey {
        case id, address, latitude, longitude, venue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        address = try container.decode(String.self, forKey: .address)
        venue = try container.decode(String.self, forKey: .venue)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(address, forKey: .address)
        try container.encode(venue, forKey: .venue)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    static func == (lhs: EventLocation, rhs: EventLocation) -> Bool {
        return lhs.id == rhs.id &&
               lhs.address == rhs.address &&
               lhs.venue == rhs.venue &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}