//
//  RequestBuilder.swift
//  RecipesApp
//
//  Created by Faisal Rahman on 26/04/2025.
//
import Foundation

struct RecipesRequestBuilder: RequestBuilder {
    
    //TODO: store this safely
    private let rapidAPIKey = "af40cd5728msh9b20903038b29aep1adcd2jsn63bfdfa76c67"
    
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
        request.setValue(rapidAPIKey, forHTTPHeaderField: "x-rapidapi-key")
        request.timeoutInterval = 5
        return request
    }
}

protocol RequestBuilder {
    func buildRequest(using url: URL) -> URLRequest
    func buildRecipesURL() -> URL?
}
