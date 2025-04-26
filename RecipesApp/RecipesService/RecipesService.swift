//
//  RecipesService.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Foundation

protocol RecipesService {
    func fetchRecipes() async -> [Recipe]
}

struct RecipesServiceImpl: RecipesService {
    func fetchRecipes() async -> [Recipe] {
        //TODO
        return []
    }
}
