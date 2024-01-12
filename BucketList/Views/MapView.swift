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
            ZStack(alignment: .bottomTrailing) {
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
                    .mapStyle(viewModel.mapStyle)
                    .onTapGesture { place in
                        if let coordinate = proxy.convert(place, from: .local) {
                            viewModel.saveLocation(coordinate: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        LocationEditorSheet(location: place, onSave: { newLocation, isDeleting in
                            print("Got a request for \(isDeleting ? "deletion" : "update").")
                            if isDeleting {
                                viewModel.deleteLocation(place: newLocation)
                            } else {
                                viewModel.updateLocation(place: place, newLocation: newLocation)
                            }
                        })
                        .presentationBackground(.ultraThinMaterial)
                        .presentationDetents([.medium, .large])
                    }
                    .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
                        Text(viewModel.alertAdditionalInfo)
                        Button("OK") { }
                    }
                }
// BUTTONS
                Menu {
                    Button("Hybrid") { viewModel.setMapStyle(style: .hybrid) }
                    Button("Standard") { viewModel.setMapStyle(style: .standard) }
                } label: {
                    RoundedRectangle(cornerRadius: 20.0)
                        .frame(width: 75, height: 75)
                        .foregroundStyle(.thinMaterial)
                        .overlay (
                            Image(systemName: "square.2.layers.3d")
                                .font(.system(size: 30))
                        )
                }
                .padding()
            }
        } else {
            PinView(viewModel: viewModel)
            Button("Use biometrics", action: viewModel.authenticate)
                .font(.system(size: 20))
                .buttonStyle(.bordered)
                .padding(.vertical)
        }
    }
}

#Preview {
    MapView()
}
