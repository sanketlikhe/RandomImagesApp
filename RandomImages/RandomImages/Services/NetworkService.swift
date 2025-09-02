//
//  NetworkService.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/1/25.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchImageEntries() async throws -> [Photos]
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}

actor NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func fetchImageEntries() async throws -> [Photos] {
        guard let url = URL(string: "https://picsum.photos/v2/list") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode([Photos].self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}



