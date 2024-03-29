//
//  Location.swift
//  BucketList
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable, Codable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Location(id: UUID(), name: "Example Location", description: "Description of an Example Location", latitude: 50, longitude: 30)
    
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
