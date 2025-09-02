//
//  PersistenceServiceTests.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import Testing
import Foundation
@testable import RandomImages

final class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]
    
    override func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
}

struct PersistenceServiceTests {
    
    @Test("Persistence service saves and loads images")
    func testSaveAndLoadImages() async {
        // Given
        let mockUserDefaults = MockUserDefaults()
        let persistenceService = PersistenceService(userDefaults: mockUserDefaults)
        
        let testImage = Photos(
            id: "1",
            author: "Test Author",
            width: 300,
            height: 200,
            url: "https://test.com",
            downloadUrl: "https://test.com/download"
        )
        
        // When
        await persistenceService.saveImage(testImage)
        
        // Then
        let savedImages = persistenceService.savedImages.value
        #expect(savedImages.count == 1)
        #expect(savedImages.first?.id == "1")
    }
    
    @Test("Persistence service prevents duplicate saves")
    func testPreventDuplicateSaves() async {
        // Given
        let mockUserDefaults = MockUserDefaults()
        let persistenceService = PersistenceService(userDefaults: mockUserDefaults)
        
        let testImage = Photos(
            id: "1",
            author: "Test Author",
            width: 300,
            height: 200,
            url: "https://test.com",
            downloadUrl: "https://test.com/download"
        )
        
        // When
        await persistenceService.saveImage(testImage)
        await persistenceService.saveImage(testImage) // Save again
        
        // Then
        let savedImages = persistenceService.savedImages.value
        #expect(savedImages.count == 1)
    }
    
    @Test("Persistence service deletes images")
    func testDeleteImage() async {
        // Given
        let mockUserDefaults = MockUserDefaults()
        let persistenceService = PersistenceService(userDefaults: mockUserDefaults)
        
        let testImage = Photos(
            id: "1",
            author: "Test Author",
            width: 300,
            height: 200,
            url: "https://test.com",
            downloadUrl: "https://test.com/download"
        )
        
        await persistenceService.saveImage(testImage)
        
        // When
        await persistenceService.deleteImage(withId: "1")
        
        // Then
        let savedImages = persistenceService.savedImages.value
        #expect(savedImages.isEmpty)
    }
}
