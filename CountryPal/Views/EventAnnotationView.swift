//
//  EventAnnotationView.swift
//  CountryPal
//
//  Created by Dez-Luan Pieterse on 29/06/2025.
//

import SwiftUI
import MapKit

struct EventAnnotationView: View {
    let event: Event
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: event.category.systemImage)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(event.category.color)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            
            // Pointer triangle
            Triangle()
                .fill(event.category.color)
                .frame(width: 8, height: 4)
                .overlay(
                    Triangle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 8, height: 4)
                )
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}