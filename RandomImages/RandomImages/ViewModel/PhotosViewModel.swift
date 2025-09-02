//
//  PhotosViewModel.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PhotosViewModel: ObservableObject {
    @Published var savedImages: [Photos] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: NetworkServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        setupBindings()
    }
    
    private func setupBindings() {
        persistenceService.savedImages
            .receive(on: DispatchQueue.main)
            .assign(to: \.savedImages, on: self)
            .store(in: &cancellables)
    }
    
    func fetchAndSaveRandomImage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let entries = try await networkService.fetchImageEntries()
            guard let randomEntry = entries.randomElement() else {
                errorMessage = "No images available"
                isLoading = false
                return
            }
            
            await persistenceService.saveImage(randomEntry)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteImage(withId id: String) async {
        await persistenceService.deleteImage(withId: id)
    }
    
    func reorderImages(from source: IndexSet, to destination: Int) async {
        await persistenceService.reorderImages(from: source, to: destination)
    }
}
