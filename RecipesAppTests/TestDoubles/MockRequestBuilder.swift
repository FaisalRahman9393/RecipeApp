//
//  MockRequestBuilder.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 26/04/2025.
//

import Foundation
@testable import RecipesApp

final class MockRequestBuilder: RequestBuilder {
    
    var urlToReturn: URL?
    var requestToReturn: URLRequest?
    
    func buildRecipesURL() -> URL? {
        return urlToReturn
    }
    
    func buildRequest(using url: URL) -> URLRequest {
        return requestToReturn ?? URLRequest(url: url)
    }
}
