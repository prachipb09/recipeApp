//
//  RecipeViewModel.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var model: RecipeModel?
    
    init(model: RecipeModel? = nil) {
        self.model = model
    }
    
    var sortedRecipes: [RecipeElementModel] {
        model?.recipes?.sorted(by: {$0.name ?? "" < $1.name ?? ""}) ?? []
    }
    
    func fetchData(repository: RecipeRepository = RecipeRepositoryImpl()) async throws {
        do {
            model = try await repository.getRecipeData()
        } catch {
            throw error
        }
    }
}
