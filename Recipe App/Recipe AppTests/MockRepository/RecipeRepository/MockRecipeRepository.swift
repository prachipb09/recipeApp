//
//  MockRecipeRepository.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 15/10/24.
//
import Foundation
@testable import Recipe_App

class MockRecipeRepositoryImpl: RecipeRepository {
    func getRecipeData() async throws -> RecipeModel {
        do {
            return try MockJsonManager().perform(fileName: "RecipeMockJson", responseType: RecipeModel.self)
        } catch {
            throw error
        }
    }
}
