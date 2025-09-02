//
//  AppDependency.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import Foundation

@MainActor
final class AppDependencies {
    //Dependency injection container for managing app services
    static let shared = AppDependencies()
    
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var persistenceService: PersistenceServiceProtocol = PersistenceService()
    
    lazy var photosViewModel: PhotosViewModel = {
        PhotosViewModel(
            networkService: networkService,
            persistenceService: persistenceService
        )
    }()
    
    private init() {}
}
