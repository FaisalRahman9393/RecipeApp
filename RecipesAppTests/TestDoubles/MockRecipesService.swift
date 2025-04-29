//
//  MockRecipesService.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 29/04/2025.
//

import Foundation
@testable import RecipesApp

class MockRecipesService: RecipesService {
    var recipesToReturn: [Recipe] = []
    var shouldThrowError: Bool = false

    func fetchRecipes() async throws -> [Recipe] {
        if shouldThrowError {
            throw NSError()
        }
        return recipesToReturn
    }
}
