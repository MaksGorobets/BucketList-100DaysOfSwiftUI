//
//  LocationEditorSheetViewModel.swift
//  BucketList
//
//  Created by Maks Winters on 11.01.2024.
//

import Foundation

extension LocationEditorSheet {
    @Observable
    final class ViewModel {
        var location: Location
        
        var name: String
        var description: String
        
        let onSave: (Location) -> Void
        
        var loadingState = LoadingState.loading
        var pages = [Page]()
        
        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            name = location.name
            description = location.description
            
            self.onSave = onSave
        }
        
        func saveChanges() {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            
            onSave(newLocation)
        }
        
        func fetchData() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Broken URL \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(Result.self, from: data)
                
                pages = decoded.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
                print(error)
            }
        }
    }
}
