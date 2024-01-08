//
//  Location.swift
//  BucketList
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Location(id: UUID(), name: "Example Location", description: "Description of an Example Location", latitude: 50, longtitude: 30)
    
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longtitude: Double
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
}
