//
//  PersistenceService.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 30/04/2025.
//

import Foundation

import Foundation

class UserDefaultsPersistenceService: PersistenceService {
    private let key = "favouriteRecipes"
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func addFavourite(_ recipe: Recipe) {
        var currentFavourites = getFavourites()
        guard !currentFavourites.contains(where: { $0.id == recipe.id }) else { return }

        currentFavourites.append(recipe)
        saveFavourites(currentFavourites)
    }

    func removeFavourite(_ recipe: Recipe) {
        var currentFavourites = getFavourites()
        currentFavourites.removeAll { $0.id == recipe.id }
        saveFavourites(currentFavourites)
    }

    func isFavourite(_ recipe: Recipe) -> Bool {
        return getFavourites().contains(where: { $0.id == recipe.id })
    }

    func getFavourites() -> [Recipe] {
        guard let data = userDefaults.data(forKey: key),
              let recipes = try? decoder.decode([Recipe].self, from: data) else {
            return []
        }
        return recipes
    }

    private func saveFavourites(_ recipes: [Recipe]) {
        if let data = try? encoder.encode(recipes) {
            userDefaults.set(data, forKey: key)
        }
    }
}

protocol PersistenceService {
    func addFavourite(_ recipe: Recipe)
    func removeFavourite(_ recipe: Recipe)
    func isFavourite(_ recipe: Recipe) -> Bool
    func getFavourites() -> [Recipe]
}
