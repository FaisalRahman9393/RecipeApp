//
//  RecipesViewModel.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//
import Combine
import Foundation

@MainActor
class RecipesViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var recipeSections: [RecipeSection] = []
    
    private var favouriteRecipes: [Recipe] = []
    private var fetchedRecipes: [Recipe] = []
    
    private let recipesService: RecipesService
    private let persistenceService: PersistenceService
    private let errorText = "It looks like we failed to fetch new recipes. Feel free to view the favourited recipes or tap here to try again!"
    
    init(recipesService: RecipesService = RecipesServiceImpl(),
         persistenceService: PersistenceService = UserDefaultsPersistenceService()) {
        self.recipesService = recipesService
        self.persistenceService = persistenceService
    }
    
    func fetchRecipes() async {
        isLoading = true
        
        do {
            self.fetchedRecipes = try await recipesService.fetchRecipes()
            self.favouriteRecipes = persistenceService.getFavourites()
            updateSections()
        } catch {
            self.fetchedRecipes = []
            self.favouriteRecipes = persistenceService.getFavourites()
            
            recipeSections = [
                RecipeSection(type: .favourited, recipes: favouriteRecipes),
                RecipeSection(type: .error(errorText), recipes: [])
            ]
        }
        
        isLoading = false
    }
    
    func favourite(_ recipe: Recipe) {
        persistenceService.addFavourite(recipe)
        favouriteRecipes = persistenceService.getFavourites()
        updateSections()
    }
    
    func unfavourite(_ recipe: Recipe) {
        persistenceService.removeFavourite(recipe)
        favouriteRecipes = persistenceService.getFavourites()
        updateSections()
    }
    
    func isFavourite(_ recipe: Recipe) -> Bool {
        persistenceService.isFavourite(recipe)
    }
    
    private func updateSections() {
        let otherRecipes = fetchedRecipes.filter { !favouriteRecipes.contains($0) }
        recipeSections = [
            RecipeSection(type: .favourited, recipes: favouriteRecipes),
            RecipeSection(type: .other, recipes: otherRecipes)
        ]
    }
}

struct RecipeSection: Equatable {
    let type: RecipeSectionType
    let recipes: [Recipe]
}

enum RecipeSectionType: Equatable {
    case favourited
    case other
    case error(String)
    
    var title: String? {
        switch self {
        case .favourited: return "Favourites"
        case .other: return "Other Recipes"
        case .error: return nil
        }
    }
}

struct Recipe: Codable, Equatable {
    let id: Int
    let name: String
    let image: String?
    let description: String?
    let instructions: [String]
    let calories: String
    let fat: String
    let protein: String
    let carbs: String
}
