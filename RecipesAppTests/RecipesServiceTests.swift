//
//  RecipesServiceTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 26/04/2025.
//
import XCTest
@testable import RecipesApp

final class RecipesServiceTests: XCTestCase {
    
    private var fetcher: MockNetworkFetcher!
    
    func test_GivenValidResponse_WhenFetchingRecipes_ThenServiceCallsCorrectURL() async throws {
        // Given
        let expectedURL = URL(string: "https://example.com/recipes")!
        let validJSON = """
        {
            "results": []
        }
        """.data(using: .utf8)!
        
        let sut = makeSUT(mockData: validJSON, expectedURL: expectedURL)
        
        // When
        _ = try await sut.fetchRecipes()
        
        // Then
        guard let capturedRequest = fetcher.capturedRequest else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(capturedRequest.url, expectedURL)
    }
    
    func test_GivenValidResponse_WhenFetchingRecipes_ThenServiceReturnsDecodedRecipes() async throws {
        // Given
        let sampleJSON = """
        {
            "results": [
                { "name": "Recipe One" },
                { "name": "Recipe Two" }
            ]
        }
        """.data(using: .utf8)!
        let expectedURL = URL(string: "https://example.com/recipes")!
        let sut = makeSUT(mockData: sampleJSON, expectedURL: expectedURL)
        
        // When
        let recipes = try await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].name, "Recipe One")
        XCTAssertEqual(recipes[1].name, "Recipe Two")
    }
    
    func test_GivenNetworkError_WhenFetchingRecipes_ThenServiceReturnsError() async {
        // Given
        let expectedURL = URL(string: "https://example.com/recipes")!
        let sut = makeSUT(expectedURL: expectedURL, shouldThrowError: true)
        
        // When
        do {
            _ = try await sut.fetchRecipes()
            XCTFail()
        } catch {
            // Then error is thrown
        }
    }
    
    func test_GivenInvalidJSON_WhenFetchingRecipes_ThenServiceReturnsDecodingError() async {
        // Given
        let invalidJSON = """
        {
            "invalid_key": []
        }
        """.data(using: .utf8)!
        let expectedURL = URL(string: "https://example.com/recipes")!
        let sut = makeSUT(mockData: invalidJSON, expectedURL: expectedURL)
        
        // When
        do {
            _ = try await sut.fetchRecipes()
            XCTFail()
        } catch {
            // Then error is thrown
        }
    }
}

// MARK: - Private Helpers
private extension RecipesServiceTests {
    
    func makeSUT(mockData: Data = Data(), expectedURL: URL, shouldThrowError: Bool = false) -> RecipesServiceImpl {
        fetcher = MockNetworkFetcher(dataToReturn: mockData, shouldThrowError: shouldThrowError)
        let builder = MockRequestBuilder()
        builder.urlToReturn = expectedURL
        builder.requestToReturn = URLRequest(url: expectedURL)
        
        return RecipesServiceImpl(fetcher: fetcher, requestBuilder: builder)
    }
}
