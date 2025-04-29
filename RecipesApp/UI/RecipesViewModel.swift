//
//  File.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Combine
import Foundation

@MainActor
class RecipesViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var recipes: [Recipe] = []
    let recipesService: RecipesService
    
    init(recipesService: RecipesService = RecipesServiceImpl()) {
        self.recipesService = recipesService
    }
    
    func fetchRecipes() async {
        isLoading = true
        do {
            recipes = try await self.recipesService.fetchRecipes()
        } catch {
            // ignore for now
        }
        isLoading = false
    }
}

struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}
