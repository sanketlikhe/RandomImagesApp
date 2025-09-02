//
//  PersistenceService.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/1/25.
//

import Foundation
import Combine

protocol PersistenceServiceProtocol {
    var savedImages: CurrentValueSubject<[Photos], Never> { get }
    func saveImage(_ image: Photos) async
    func deleteImage(withId id: String) async
    func reorderImages(from source: IndexSet, to destination: Int) async
    func loadSavedImages() async
}


actor PersistenceService: PersistenceServiceProtocol {
    //Reactive publisher that emits current list of saved images. UI automatically updates when this changes
    nonisolated let savedImages = CurrentValueSubject<[Photos], Never>([])
    
    //As Dataset is small and simple, using UserDefaults to persist. UserDefaults is quick to implement
    //TODO: Use SwiftData instead of UserDefaults.
    private let userDefaults: UserDefaults
    private let key = "SavedPhotoEntries"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        Task {
            await loadSavedImages()
        }
    }
    
    func saveImage(_ image: Photos) async {
        var currentImages = savedImages.value
        //To avoid duplicates
        guard !currentImages.contains(where: { $0.id == image.id }) else { return }
        currentImages.append(image)
        await updateStorage(with: currentImages)
    }
    
    func deleteImage(withId id: String) async {
        let updatedImages = savedImages.value.filter { $0.id != id }
        await updateStorage(with: updatedImages)
    }
    
    func reorderImages(from source: IndexSet, to destination: Int) async {
        var currentImages = savedImages.value
        currentImages.move(fromOffsets: source, toOffset: destination)
        await updateStorage(with: currentImages)
    }
    
    //Load existing data on startup
    func loadSavedImages() async {
        guard let data = userDefaults.data(forKey: key),
              let images = try? JSONDecoder().decode([Photos].self, from: data) else {
            return
        }
        savedImages.send(images)
    }
    
    //Update UI after data manipulation
    private func updateStorage(with images: [Photos]) async {
        if let encoded = try? JSONEncoder().encode(images) {
            userDefaults.set(encoded, forKey: key)
        }
        savedImages.send(images)
    }
}
