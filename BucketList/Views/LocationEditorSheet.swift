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
    
    @Bindable private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $viewModel.name)
                    .strokeTextField()
                TextField("Description", text: $viewModel.description)
                    .strokeTextField()
                Text("Nearby:")
                    .bold()
                    .padding()
                switch viewModel.loadingState {
                case .loading:
                    ProgressView()
                case .loaded:
                    ScrollView(.vertical) {
                        ForEach(viewModel.pages, id: \.pageid) { page in
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveChanges()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Delete", role: .destructive) {
                        viewModel.alertUser("Are you sure you want to delete \"\(viewModel.location.name)\"?")
                    }
                    .foregroundStyle(.red)
                }
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteCurrentLocation()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchData()
            }
            .navigationTitle("Edit landmark")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(location: Location, onSave: @escaping (Location, Bool) -> Void) {
        self.viewModel = ViewModel(location: location, onSave: onSave)
    }
}

#Preview {
    LocationEditorSheet(location: .example, onSave: { _, _ in })
}
