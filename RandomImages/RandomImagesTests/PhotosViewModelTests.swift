//
//  PhotosViewModelTests.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import Testing
import Foundation
import Combine
@testable import RandomImages

final class MockNetworkService: NetworkServiceProtocol {
    private let shouldThrowError: Bool
    
    init(shouldThrowError: Bool = false) {
        self.shouldThrowError = shouldThrowError
    }
    
    func fetchImageEntries() async throws -> [Photos] {
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }
        
        return [
            Photos(
                id: "1",
                author: "Mock Author",
                width: 300,
                height: 200,
                url: "https://mock.com",
                downloadUrl: "https://mock.com/download"
            )
        ]
    }
}

final class MockPersistenceService: PersistenceServiceProtocol {
    let savedImages = CurrentValueSubject<[Photos], Never>([])
    
    private(set) var saveImageCallCount = 0
    private(set) var deleteImageCallCount = 0
    private(set) var reorderImagesCallCount = 0
    private(set) var loadSavedImagesCallCount = 0
    
    func saveImage(_ image: Photos) async {
        saveImageCallCount += 1
        var current = savedImages.value
        current.append(image)
        savedImages.send(current)
    }
    
    func deleteImage(withId id: String) async {
        deleteImageCallCount += 1
        let filtered = savedImages.value.filter { $0.id != id }
        savedImages.send(filtered)
    }
    
    func reorderImages(from source: IndexSet, to destination: Int) async {
        reorderImagesCallCount += 1
    }
    
    func loadSavedImages() async {
        loadSavedImagesCallCount += 1
    }
}


@MainActor
struct PhotosViewModelTests {
    
    @Test("ViewModel fetches and saves random image")
    func testFetchAndSaveRandomImage() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let mockPersistenceService = MockPersistenceService()
        let viewModel = PhotosViewModel(
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // When
        await viewModel.fetchAndSaveRandomImage()
        
        // Then
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(mockPersistenceService.saveImageCallCount == 1)
    }
    
    @Test("ViewModel handles network errors")
    func testHandleNetworkError() async {
        // Given
        let mockNetworkService = MockNetworkService(shouldThrowError: true)
        let mockPersistenceService = MockPersistenceService()
        let viewModel = PhotosViewModel(
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // When
        await viewModel.fetchAndSaveRandomImage()
        
        // Then
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage != nil)
        #expect(mockPersistenceService.saveImageCallCount == 0)
    }
    
    @Test("ViewModel deletes image")
    func testDeleteImage() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let mockPersistenceService = MockPersistenceService()
        let viewModel = PhotosViewModel(
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // When
        await viewModel.deleteImage(withId: "1")
        
        // Then
        #expect(mockPersistenceService.deleteImageCallCount == 1)
    }
}
