//
//  EventDataService.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import Foundation
import CoreLocation
import Combine

class EventDataService: ObservableObject {
    @Published var events: [Event] = []
    @Published var filteredEvents: [Event] = []
    @Published var searchText = ""
    @Published var selectedCategories: Set<EventCategory> = Set(EventCategory.allCases)
    @Published var showUpcomingOnly = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSampleEvents()
        setupFiltering()
    }
    
    private func setupFiltering() {
        Publishers.CombineLatest3($events, $searchText, $selectedCategories)
            .combineLatest($showUpcomingOnly)
            .map { eventsAndFilters, upcomingOnly in
                let (events, searchText, categories) = eventsAndFilters
                return self.filterEvents(events: events, searchText: searchText, categories: categories, upcomingOnly: upcomingOnly)
            }
            .assign(to: \.filteredEvents, on: self)
            .store(in: &cancellables)
    }
    
    private func filterEvents(events: [Event], searchText: String, categories: Set<EventCategory>, upcomingOnly: Bool) -> [Event] {
        var filtered = events
        
        if upcomingOnly {
            filtered = filtered.filter { !$0.isPast }
        }
        
        filtered = filtered.filter { categories.contains($0.category) }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.location.venue.localizedCaseInsensitiveContains(searchText) ||
                event.location.address.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.startDate < $1.startDate }
    }
    
    func toggleCategory(_ category: EventCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    private func loadSampleEvents() {
        let calendar = Calendar.current
        let now = Date()
        
        events = [
            Event(
                title: "Haywards Heath Summer Fete",
                description: "A traditional village fete with stalls, games, local produce, live music, and activities for all the family. Enjoy homemade cakes, craft stalls, and traditional games.",
                category: .villageFete,
                startDate: calendar.date(byAdding: .day, value: 7, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 7, to: calendar.date(byAdding: .hour, value: 6, to: now)!)!,
                location: EventLocation(
                    address: "Victoria Park, Haywards Heath, RH16 3AZ",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0044, longitude: -0.1021),
                    venue: "Victoria Park"
                ),
                contactInfo: "haywardsheath.fete@gmail.com | 01444 458291",
                isSponsored: true
            ),
            
            Event(
                title: "Burgess Hill Farmers Market",
                description: "Fresh local produce from Sussex farms including vegetables, meat, dairy, bread, and artisan foods. Supporting local farmers and producers.",
                category: .farmersMarket,
                startDate: calendar.date(byAdding: .day, value: 3, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 3, to: calendar.date(byAdding: .hour, value: 4, to: now)!)!,
                location: EventLocation(
                    address: "Cyprus Road, Burgess Hill, RH15 8DX",
                    coordinate: CLLocationCoordinate2D(latitude: 50.9578, longitude: -0.1290),
                    venue: "Burgess Hill Town Centre"
                ),
                contactInfo: "info@burgesshillmarket.co.uk | 01444 247726"
            ),
            
            Event(
                title: "East Grinstead Book Fair",
                description: "Large indoor book sale with thousands of books including rare finds, children's books, fiction, non-fiction, and local history. Proceeds to local charities.",
                category: .bookSale,
                startDate: calendar.date(byAdding: .day, value: 10, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 10, to: calendar.date(byAdding: .hour, value: 5, to: now)!)!,
                location: EventLocation(
                    address: "Chequer Mead Theatre, De La Warr Road, East Grinstead, RH19 3BS",
                    coordinate: CLLocationCoordinate2D(latitude: 51.1240, longitude: 0.0074),
                    venue: "Chequer Mead Theatre"
                ),
                contactInfo: "eastgrinstead.books@gmail.com | 01342 328616"
            ),
            
            Event(
                title: "Horsted Keynes Craft Fair",
                description: "Handmade crafts by local artisans including pottery, woodwork, textiles, jewelry, and artwork. Perfect for unique gifts and supporting local makers.",
                category: .craftFair,
                startDate: calendar.date(byAdding: .day, value: 14, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 14, to: calendar.date(byAdding: .hour, value: 6, to: now)!)!,
                location: EventLocation(
                    address: "Horsted Keynes Village Hall, Church Lane, Horsted Keynes, RH17 7DF",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0428, longitude: -0.0395),
                    venue: "Village Hall"
                ),
                contactInfo: "crafts@horstedkeynes.org | 01825 790314"
            ),
            
            Event(
                title: "Cuckfield Community Day",
                description: "Annual community celebration with local history displays, live entertainment, food stalls, children's activities, and demonstrations by local groups.",
                category: .community,
                startDate: calendar.date(byAdding: .day, value: 21, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 21, to: calendar.date(byAdding: .hour, value: 7, to: now)!)!,
                location: EventLocation(
                    address: "Cuckfield Recreation Ground, High Street, Cuckfield, RH17 5JZ",
                    coordinate: CLLocationCoordinate2D(latitude: 50.9978, longitude: -0.1421),
                    venue: "Recreation Ground"
                ),
                contactInfo: "info@cuckfieldcommunity.org | 01444 413747"
            ),
            
            Event(
                title: "Lindfield Bonfire Night",
                description: "Traditional Guy Fawkes celebration with bonfire, fireworks display, hot food, mulled wine, and torchlight procession through the village.",
                category: .seasonal,
                startDate: calendar.date(byAdding: .day, value: 35, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 35, to: calendar.date(byAdding: .hour, value: 4, to: now)!)!,
                location: EventLocation(
                    address: "Lindfield Common, Lewes Road, Lindfield, RH16 2LH",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0131, longitude: -0.0759),
                    venue: "Lindfield Common"
                ),
                contactInfo: "bonfire@lindfield.org | 01444 482701"
            ),
            
            Event(
                title: "Ardingly Antiques Fair",
                description: "One of the UK's largest outdoor antiques fairs with over 1,500 stalls selling furniture, collectibles, vintage items, and curiosities.",
                category: .craftFair,
                startDate: calendar.date(byAdding: .day, value: 28, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 28, to: calendar.date(byAdding: .hour, value: 8, to: now)!)!,
                location: EventLocation(
                    address: "South of England Showground, Ardingly, RH17 6TL",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0234, longitude: -0.0856),
                    venue: "South of England Showground"
                ),
                contactInfo: "info@iacf.co.uk | 01444 482514",
                isSponsored: true
            ),
            
            Event(
                title: "Turners Hill Village Market",
                description: "Monthly village market with local produce, plants, homemade goods, and community stalls. Perfect for meeting neighbors and supporting local businesses.",
                category: .farmersMarket,
                startDate: calendar.date(byAdding: .day, value: 12, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 12, to: calendar.date(byAdding: .hour, value: 3, to: now)!)!,
                location: EventLocation(
                    address: "Turners Hill Village Green, East Street, Turners Hill, RH10 4QQ",
                    coordinate: CLLocationCoordinate2D(latitude: 51.1087, longitude: -0.0642),
                    venue: "Village Green"
                ),
                contactInfo: "market@turnershill.org | 01342 715337"
            ),
            
            Event(
                title: "Balcombe Harvest Festival",
                description: "Traditional harvest celebration with church service, harvest supper, live music, and displays of local produce and flowers.",
                category: .seasonal,
                startDate: calendar.date(byAdding: .day, value: 42, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 42, to: calendar.date(byAdding: .hour, value: 5, to: now)!)!,
                location: EventLocation(
                    address: "St Mary's Church, Bramble Hill, Balcombe, RH17 6HR",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0531, longitude: -0.1289),
                    venue: "St Mary's Church"
                ),
                contactInfo: "harvest@balcombe.org | 01444 811264"
            ),
            
            Event(
                title: "Handcross Christmas Market",
                description: "Festive market with Christmas gifts, decorations, seasonal food, mulled wine, and visits from Father Christmas for the children.",
                category: .seasonal,
                startDate: calendar.date(byAdding: .day, value: 85, to: now)!,
                endDate: calendar.date(byAdding: .day, value: 85, to: calendar.date(byAdding: .hour, value: 6, to: now)!)!,
                location: EventLocation(
                    address: "Handcross Village Hall, Brighton Road, Handcross, RH17 6BJ",
                    coordinate: CLLocationCoordinate2D(latitude: 51.0787, longitude: -0.1687),
                    venue: "Village Hall"
                ),
                contactInfo: "christmas@handcross.org | 01444 400928"
            )
        ]
    }
}