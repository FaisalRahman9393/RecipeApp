//
//  RecipesService.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Foundation

struct RecipesServiceImpl: RecipesService {
    
    let fetcher: NetworkFetcher
    let requestBuilder: RequestBuilder
    
    init(fetcher: NetworkFetcher = NetworkFetcherImp(), requestBuilder: RequestBuilder = RecipesRequestBuilder()) {
        self.fetcher = fetcher
        self.requestBuilder = requestBuilder
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = requestBuilder.buildRecipesURL() else {
            throw NetworkError.failedToBuildURL
        }
        let request = requestBuilder.buildRequest(using: url)
        let data = try await fetcher.fetch(request: request)
        
        let results = try JSONDecoder().decode(RecipesResponse.self, from: data).results
        
        return results.compactMap {
            Recipe(id: $0.id,
                   name: $0.name,
                   image: $0.thumbnailURL,
                   description: $0.description,
                   instructions: $0.instructions.map { $0.displayText },
                   calories: $0.nutrition?.calories.map { "\($0) kcal" } ?? "",
                   fat: $0.nutrition?.fat.map { "\($0) g" } ?? "",
                   protein: $0.nutrition?.protein.map { "\($0) g" } ?? "",
                   carbs: $0.nutrition?.carbohydrates.map { "\($0) g" } ?? "")
        }
    }
}

protocol RecipesService {
    func fetchRecipes() async throws -> [Recipe]
}


struct RecipesResponse: Decodable {
    let results: [Recipe]
    
    struct Recipe: Decodable, Identifiable {
        let id: Int
        let name: String
        let description: String?
        let thumbnailURL: String?
        let instructions: [Instruction]
        let nutrition: Nutrition?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case description
            case thumbnailURL = "thumbnail_url"
            case instructions
            case nutrition
        }
    }
    
    struct Instruction: Decodable {
        let displayText: String
        
        enum CodingKeys: String, CodingKey {
            case displayText = "display_text"
        }
    }
    
    struct Nutrition: Decodable {
        let calories: Int?
        let fat: Int?
        let protein: Int?
        let sugar: Int?
        let carbohydrates: Int?
        let fiber: Int?
    }
}
