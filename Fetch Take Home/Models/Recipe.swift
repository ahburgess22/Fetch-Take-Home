//
//  Recipe.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/12/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    var id: String { uuid }
    
    private enum CodingKeys: String, CodingKey {
        case uuid, name, cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
