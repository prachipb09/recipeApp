//
//  RecipeImageLoader.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 15/10/24.
//

import SwiftUI

@MainActor
class RecipeImageLoader: ObservableObject {

    private var recipeImageKey: String?
    @Published var uiImage: UIImage?
    
    init(recipeImageKey: String? = nil, uiImage: UIImage? = nil) {
        self.recipeImageKey = recipeImageKey
        self.uiImage = uiImage
    }
    
    func fetchRecipeImage(recipeImageKey: String) async throws {
        self.recipeImageKey = recipeImageKey

        if let cachedImage = CacheUtility.shared.getImage(forKey: recipeImageKey) {
            uiImage = cachedImage
        } else {
            guard let url = URL(string: recipeImageKey) else {
                throw RecipeError.NetworkError
            }
            
            let urlRequest = URLRequest(url: url, timeoutInterval: 10.0)
            
            let (response,_) = try await URLSession.shared.data(for: urlRequest)

            guard let image = UIImage(data: response) else {
                throw NSError(domain: "DataDecodingFailed",
                              code: 500,
                              userInfo: [NSLocalizedDescriptionKey: "Cannot decode response to image"])
            }
            // store it in the cache
            CacheUtility.shared.saveImage(image, forKey: recipeImageKey)
            uiImage = image
        }
    }
}
