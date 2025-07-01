//
//  EventAnnotation.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    let event: Event
    
    var coordinate: CLLocationCoordinate2D {
        return event.location.coordinate
    }
    
    var title: String? {
        return event.title
    }
    
    var subtitle: String? {
        return event.location.venue
    }
    
    init(event: Event) {
        self.event = event
        super.init()
    }
}