//
//  RequestBuilder.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//
import Foundation

struct RecipesRequestBuilder: RequestBuilder {
    
    func buildRecipesURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "tasty.p.rapidapi.com"
        urlComponents.path = "/recipes/list"
        urlComponents.queryItems = [
            URLQueryItem(name: "from", value: "0"),
            URLQueryItem(name: "size", value: "20"),
            URLQueryItem(name: "tags", value: "under_30_minutes")
        ]
        return urlComponents.url
    }
    
    func buildRequest(using url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("tasty.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("your-rapidapi-key", forHTTPHeaderField: "x-rapidapi-key")
        return request
    }
}

protocol RequestBuilder {
    func buildRequest(using url: URL) -> URLRequest
    func buildRecipesURL() -> URL?
}
