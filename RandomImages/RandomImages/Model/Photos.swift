//
//  Photos.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/1/25.
//

import Foundation

struct Photos: Codable, Identifiable, Equatable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
    
    // Computed property to generate consistent 300x200 thumbnail using Picsum's sizing API
    var thumbnailUrl: String {
        "https://picsum.photos/id/\(id)/300/200"
    }
}
