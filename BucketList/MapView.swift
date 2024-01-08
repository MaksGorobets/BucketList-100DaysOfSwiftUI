//
//  MapView.swift
//  BucketList
//
//  Created by Maks Winters on 08.01.2024.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    let startingRegion = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50.4504, longitude: 30.5245),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    )
    
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startingRegion) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "bookmark.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture {
                                selectedPlace = location
                            }
                    }
                }
            }
            .onTapGesture { place in
                if let coordinate = proxy.convert(place, from: .local) {
                    let locationToSave = Location(id: UUID(), name: "New locaiton", description: "", latitude: coordinate.latitude, longtitude: coordinate.longitude)
                    locations.append(locationToSave)
                }
            }
            .sheet(item: $selectedPlace) { place in
                LocationEditorSheet(location: place, onSave: { newLocation in
                    if let index = locations.firstIndex(of: place) {
                        locations[index] = newLocation
                    }
                })
                    .presentationBackground(.ultraThinMaterial)
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    MapView()
}
