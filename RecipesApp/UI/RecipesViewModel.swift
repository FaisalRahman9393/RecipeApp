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
    @Published private(set) var favouriteRecipes: [Recipe] = []

    private let recipesService: RecipesService
    private let persistenceService: PersistenceService

    init(recipesService: RecipesService = RecipesServiceImpl(),
         persistenceService: PersistenceService = UserDefaultsPersistenceService()) {
        self.recipesService = recipesService
        self.persistenceService = persistenceService
        self.favouriteRecipes = persistenceService.getFavourites()
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

    func favourite(_ recipe: Recipe) {
        persistenceService.addFavourite(recipe)
        self.favouriteRecipes = persistenceService.getFavourites()
    }
    
    func unfavourite(_ recipe: Recipe) {
        persistenceService.removeFavourite(recipe)
        self.favouriteRecipes = persistenceService.getFavourites()
    }
    
    func isFavourite(_ recipe: Recipe) -> Bool {
         return persistenceService.isFavourite(recipe)
     }
}

struct Recipe: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: String
}
