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

struct CustomDevider: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .foregroundStyle(.white)
    }
}

struct LocationEditorSheet: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    
    let onSave: (Location) -> Void
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $name)
                    .strokeTextField()
                TextField("Description", text: $description)
                    .strokeTextField()
                Text("Nearby:")
                    .bold()
                    .padding()
                switch loadingState {
                case .loading:
                    ProgressView()
                case .loaded:
                    ScrollView(.vertical) {
                        ForEach(pages, id: \.pageid) { page in
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .padding(.horizontal, 5)
                                VStack(alignment: .leading) {
                                    Text(page.title)
                                    CustomDevider()
                                    Text(page.description)
                                }
                                Spacer()
                            }
                            .strokeTextField()
                        }
                    }
                case .failed:
                    ContentUnavailableView("Couldn't load the data", systemImage: "exclamationmark.triangle", description: Text("Try again later."))
                }
                Spacer()
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
            .task {
                await fetchData()
            }
            .navigationTitle("Edit landmark")
            .navigationBarTitleDisplayMode(.inline)
        }
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
