//
//  NetworkFetcher.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Foundation

struct NetworkFetcherImp: NetworkFetcher {
    func fetch(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.failedFailedToFetchData
            }
            
            return data
        } catch {
            throw NetworkError.failedFailedToFetchData
        }
    }
}

protocol NetworkFetcher {
    func fetch(request: URLRequest) async throws -> Data
}

enum NetworkError: Error {
    case failedToBuildURL
    case failedFailedToFetchData
}

