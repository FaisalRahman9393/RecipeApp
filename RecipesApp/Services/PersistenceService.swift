//
//  PersistenceService.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 30/04/2025.
//

import Foundation

class UserDefaultsPersistenceService: PersistenceService {
    private let key = "favouriteRecipes"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func addFavourite(_ recipe: Recipe) {
        var savedNames = userDefaults.stringArray(forKey: key) ?? []
        if !savedNames.contains(recipe.name) {
            savedNames.append(recipe.name)
            userDefaults.set(savedNames, forKey: key)
        }
    }

    func removeFavourite(_ recipe: Recipe) {
        var savedNames = userDefaults.stringArray(forKey: key) ?? []
        savedNames.removeAll { $0 == recipe.name }
        userDefaults.set(savedNames, forKey: key)
    }

    func isFavourite(_ recipe: Recipe) -> Bool {
        let savedNames = userDefaults.stringArray(forKey: key) ?? []
        return savedNames.contains(recipe.name)
    }

    func getFavourites() -> [Recipe] {
        let savedNames = userDefaults.stringArray(forKey: key) ?? []
        return savedNames.map { Recipe(name: $0, image: "") }
    }
}

protocol PersistenceService {
    func addFavourite(_ recipe: Recipe)
    func removeFavourite(_ recipe: Recipe)
    func isFavourite(_ recipe: Recipe) -> Bool
    func getFavourites() -> [Recipe]
}
