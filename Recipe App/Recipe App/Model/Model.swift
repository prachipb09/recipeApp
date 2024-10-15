//
//  Recipe.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

import Foundation

// MARK: - Recipe
struct RecipeModel: Codable {
    let recipes: [RecipeElementModel]?
}

// MARK: - RecipeElement
struct RecipeElementModel: Codable {
    let cuisine, name: String?
    let photoURLLarge, photoURLSmall: String?
    let sourceURL: String?
    let uuid: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
