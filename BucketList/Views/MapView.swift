//
//  MapView.swift
//  BucketList
//
//  Created by Maks Winters on 08.01.2024.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: MapView.ViewModel.startingRegion) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "bookmark.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.blue)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .onTapGesture { place in
                    if let coordinate = proxy.convert(place, from: .local) {
                        viewModel.saveLocation(coordinate: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    LocationEditorSheet(location: place, onSave: { newLocation in
                        viewModel.updateLocation(place: place, newLocation: newLocation)
                    })
                    .presentationBackground(.ultraThinMaterial)
                    .presentationDetents([.medium, .large])
                }
            }
        } else {
            PinView(viewModel: viewModel)
            Button("Authenticate", action: viewModel.authenticate)
                .font(.system(size: 20))
                .buttonStyle(.bordered)
                .padding(.vertical)
        }
    }
}

#Preview {
    MapView()
}
