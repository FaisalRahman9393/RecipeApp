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
        
        print(results)
        return results.compactMap { Recipe(name: $0.name, image: "") }
    }
}

struct RecipesResponse: Decodable {
    let results: [Recipe]
    
    struct Recipe: Decodable {
        let name: String
    }
}

protocol RecipesService {
    func fetchRecipes() async throws -> [Recipe]
}
