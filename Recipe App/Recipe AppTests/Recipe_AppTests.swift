//
//  Recipe_AppTests.swift
//  Recipe AppTests
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

import XCTest
@testable import Recipe_App

@MainActor
final class Recipe_AppTests: RecipeTestCase {
    var viewModel: RecipeViewModel?
    
    override func setUpWithError() throws {
        viewModel = RecipeViewModel()
    }
    
    func test_model_data_is_loaded_returns_true() async throws {
        GIVEN("User logged into the app")
        do {
            WHEN("api call for the fetch data should be called")
            try await viewModel?.fetchData(repository: MockRecipeRepositoryImpl())
            
            THEN("data should be available in the model")
            XCTAssertNotNil(viewModel?.model,"model should not be nil")
            XCTAssertGreaterThan(viewModel?.model?.recipes?.count ?? 0, 1,"the model should have more than 1 recipes")
        } catch(let error) {
            XCTFail("failed to load data \(error)")
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

}
