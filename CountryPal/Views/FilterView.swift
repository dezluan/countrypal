//
//  FilterView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var eventDataService: EventDataService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Show upcoming events only", isOn: $eventDataService.showUpcomingOnly)
                } header: {
                    Text("Time Filter")
                }
                
                Section {
                    ForEach(EventCategory.allCases) { category in
                        HStack {
                            Button(action: {
                                eventDataService.toggleCategory(category)
                            }) {
                                HStack {
                                    Image(systemName: category.systemImage)
                                        .foregroundColor(category.color)
                                        .frame(width: 20)
                                    
                                    Text(category.rawValue)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if eventDataService.selectedCategories.contains(category) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(category.color)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                } header: {
                    Text("Event Categories")
                } footer: {
                    Text("Select the types of events you want to see")
                }
                
                Section {
                    Button("Select All Categories") {
                        eventDataService.selectedCategories = Set(EventCategory.allCases)
                    }
                    
                    Button("Clear All Categories") {
                        eventDataService.selectedCategories.removeAll()
                    }
                    .foregroundColor(.red)
                } header: {
                    Text("Quick Actions")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Showing \(eventDataService.filteredEvents.count) of \(eventDataService.events.count) events")
                            .font(.headline)
                        
                        if !eventDataService.searchText.isEmpty {
                            Text("Search: \"\(eventDataService.searchText)\"")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if eventDataService.selectedCategories.count != EventCategory.allCases.count {
                            Text("Categories: \(eventDataService.selectedCategories.count) of \(EventCategory.allCases.count) selected")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Filter Summary")
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView(eventDataService: EventDataService())
}