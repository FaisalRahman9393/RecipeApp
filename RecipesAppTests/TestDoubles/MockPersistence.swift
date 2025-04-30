//
//  MockPersistence.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 30/04/2025.
//

import Foundation
@testable import RecipesApp

class MockPersistenceService: PersistenceService {
    private(set) var storedFavourites: [Recipe] = []

    func addFavourite(_ recipe: Recipe) {
        storedFavourites.append(recipe)
    }

    func removeFavourite(_ recipe: Recipe) {
        storedFavourites.removeAll { $0.id == recipe.id }
    }

    func isFavourite(_ recipe: Recipe) -> Bool {
        return storedFavourites.contains { $0.id == recipe.id }
    }

    func getFavourites() -> [Recipe] {
        return storedFavourites
    }
}
