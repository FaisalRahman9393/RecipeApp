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
    @Published var recipeSections: [RecipeSection] = []
    
    private var favouriteRecipes: [Recipe] = []
    private var fetchedRecipes: [Recipe] = []

    private let recipesService: RecipesService
    private let persistenceService: PersistenceService
    private var cancellables: Set<AnyCancellable> = []

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
            // ignore for now
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
         return persistenceService.isFavourite(recipe)
    }

    private func updateSections() {
        recipeSections = [
            RecipeSection(type: .favourited, recipes: favouriteRecipes),
            RecipeSection(type: .other, recipes: fetchedRecipes.filter { !favouriteRecipes.contains($0) })
        ]
    }
}

struct RecipeSection {
    let type: RecipeSectionType
    let recipes: [Recipe]
}

enum RecipeSectionType {
    case favourited
    case other

    var title: String {
        switch self {
        case .favourited: return "Favourites"
        case .other: return "Other Recipes"
        }
    }
}

struct Recipe: Codable, Equatable {
    let id: Int
    let name: String
    let image: String?
    let description: String?
    let instructions: [String]
    let calories: Int?
    let fat: Int?
    let protein: Int?
    let carbs: Int?
}
