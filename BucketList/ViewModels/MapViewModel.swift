//
//  MapViewModel.swift
//  BucketList
//
//  Created by Maks Winters on 11.01.2024.
//

import Foundation
import MapKit
import SwiftUI
import LocalAuthentication

extension MapView {
    @Observable
    final class ViewModel {
        static let startingRegion = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 50.4504, longitude: 30.5245),
                span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        )
        
        let fileManager = FileManagerStatic.fileManager
        
        private(set) var locations = [Location]()
        var selectedPlace: Location?
        
        var isUnlocked = false
        var isShowingAlert = false
        var alertMessage = ""
        var alertAdditionalInfo = ""
        
        private(set) var mapStyle: MapStyle = .standard
        
//        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            authenticate()
            do {
                locations = try fileManager.read(from: "SavedPlaces", as: [Location].self)
            } catch {
                print("Read error \(error)")
            }
//            do {
//                let data = try Data(contentsOf: savePath)
//                let decodedData = try JSONDecoder().decode([Location].self, from: data)
//                locations = decodedData
//            } catch {
//                print("Failed to read data: \(error)")
//            }
        }
        
        func setMapStyle(style: MapStyle) {
            mapStyle = style
        }
        
        func alertUser(_ message: String, additionalInfo: String?) {
            alertMessage = message
            if let info = additionalInfo {
                alertAdditionalInfo = info
            }
            isShowingAlert = true
        }
        
        func save() {
            fileManager.write(object: locations, to: "SavedPlaces")
//            do {
//                let json = try JSONEncoder().encode(locations)
//                try json.write(to: savePath, options: [.atomic, .completeFileProtection])
//            } catch {
//                print("Failed to save data: \(error)")
//            }
        }
        
        func saveLocation(coordinate: CLLocationCoordinate2D) {
            let locationToSave = Location(id: UUID(), name: "New locaiton", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
            locations.append(locationToSave)
            save()
        }
        
        func updateLocation(place: Location, newLocation: Location) {
            if let index = locations.firstIndex(of: place) {
                locations[index] = newLocation
                save()
            }
        }
        
        func deleteLocation(place: Location) {
            if let index = locations.firstIndex(of: place) {
                print("Removing...")
                locations.remove(at: index)
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need to access your places.") { success, error in
                    if success {
                        self.isUnlocked = true
                    } else {
                        print("Showing alert...")
                        self.alertUser("Error during authentication", additionalInfo: error?.localizedDescription)
                    }
                }
            }
        }
        
    }
}
