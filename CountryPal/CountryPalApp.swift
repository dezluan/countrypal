//
//  CountryPalApp.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import Auth0

@main
struct CountryPalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Auth0 URL callback handling for v2.13.0
                    // The URL scheme handling for authentication callbacks
                    print("Auth0 URL callback received: \(url)")
                }
        }
    }
}
