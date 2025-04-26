//
//  RecipesRequestBuilderTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 26/04/2025.
//
import XCTest
@testable import RecipesApp

final class RecipesRequestBuilderTests: XCTestCase {
    
    func test_GivenNothing_WhenBuildingRecipesURL_ThenReturnsCorrectURL() {
        // Given
        let url = RecipesRequestBuilder().buildRecipesURL()
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "tasty.p.rapidapi.com")
        XCTAssertEqual(url?.path, "/recipes/list")
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "from", value: "0")) ?? false)
        XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "size", value: "20")) ?? false)
        XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "tags", value: "under_30_minutes")) ?? false)
    }
    
    func test_GivenURL_WhenBuildingRequest_ThenReturnsRequestWithCorrectHeaders() {
        // Given
        let url = URL(string: "https://tasty.p.rapidapi.com/recipes/list")!
        
        // When
        let request = RecipesRequestBuilder().buildRequest(using: url)
        
        // Then
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "x-rapidapi-host"), "tasty.p.rapidapi.com")
        XCTAssertEqual(request.value(forHTTPHeaderField: "x-rapidapi-key"), "your-rapidapi-key")
    }
}
