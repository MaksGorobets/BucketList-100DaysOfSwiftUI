//
//  LocationEditorSheet.swift
//  BucketList
//
//  Created by Maks Winters on 08.01.2024.
//

import SwiftUI

struct StrokeTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay (
                RoundedRectangle(cornerRadius: 25)
                    .stroke()
                    .foregroundStyle(.primary)
            )
    }
}

extension View {
    func strokeTextField() -> some View {
        modifier(StrokeTextField())
    }
}

struct LocationEditorSheet: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    
    let onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $name)
                    .strokeTextField()
                TextField("Description", text: $description)
                    .strokeTextField()
            }
            .padding()
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .navigationTitle("Edit landmark")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
        
        self.onSave = onSave
    }
}

#Preview {
    LocationEditorSheet(location: .example, onSave: { _ in })
}
