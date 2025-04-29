//
//  File.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Combine
import Foundation

class RecipesViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    let recipesService: RecipesService
    
    init(recipesService: RecipesService = RecipesServiceImpl()) {
        self.recipesService = recipesService
    }
    
    func fetchRecipes() async {
        
        do {
            recipes = try await self.recipesService.fetchRecipes()
        } catch {
            // ignore for now
        }
    }
}

struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}
