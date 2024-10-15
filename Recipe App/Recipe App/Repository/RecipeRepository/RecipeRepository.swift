//
//  RecipeRepository.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

protocol RecipeRepository {
    func getRecipeData() async throws -> RecipeModel
}

class RecipeRepositoryImpl: RecipeRepository {
    func getRecipeData() async throws -> RecipeModel {
        do {
            return try await NetworkLayer.shared.decode(modelType: RecipeModel.self, for: .RecipeLandingPage)
        } catch {
            throw error
        }
    }
}
