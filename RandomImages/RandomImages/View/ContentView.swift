//
//  ContentView.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PhotosViewModel
    
    //Dependency injection for ViewModel
    init(viewModel: PhotosViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                imageListSection
            }
            .navigationTitle("Random Images")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    //Button and error view
    private var headerSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.fetchAndSaveRandomImage()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView() //spinner when loading
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "photo.badge.plus") //icon when not loading
                    }
                    Text("Add Random Image")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(viewModel.isLoading)
            
            //Error message display
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    viewModel.errorMessage = nil
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    //Main content area = either empty state || image list
    private var imageListSection: some View {
        Group {
            if viewModel.savedImages.isEmpty {
                emptyStateView
            } else {
                imageList
            }
        }
    }
    
    //when no Photo model objects are saved
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Images Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Tap the button above to add your first random image")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    //List of saved images with drag-to-reorder functionality
    private var imageList: some View {
        List {
            ForEach(viewModel.savedImages) { photo in
                PhotoView(photo: photo) {
                    Task {
                        await viewModel.deleteImage(withId: photo.id)
                    }
                }
            }
            .onMove { source, destination in
                //Drag-to-reorder action
                Task {
                    await viewModel.reorderImages(from: source, to: destination)
                }
            }
        }
        .listStyle(.insetGrouped)
        .environment(\.editMode, .constant(.active))
    }
}

#Preview {
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var persistenceService: PersistenceServiceProtocol = PersistenceService()
    ContentView(viewModel: PhotosViewModel(networkService: networkService, persistenceService: persistenceService))
}
