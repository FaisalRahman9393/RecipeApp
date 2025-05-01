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
        let sut = makeSUT(mockData: emptyRecipesJSON, expectedURL: expectedURL)

        // When
        _ = try await sut.fetchRecipes()

        // Then
        guard let capturedRequest = fetcher.capturedRequest else {
            XCTFail()
            return
        }

        XCTAssertEqual(capturedRequest.url, expectedURL)
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
        let expectedURL = URL(string: "https://example.com/recipes")!
        let sut = makeSUT(mockData: invalidRecipesJSON, expectedURL: expectedURL)

        // When
        do {
            _ = try await sut.fetchRecipes()
            XCTFail()
        } catch {
            // Then error is thrown
        }
    }

    func test_GivenValidResponse_WhenFetchingRecipes_ThenServiceReturnsDecodedRecipes() async throws {
        // Given
        let expectedURL = URL(string: "https://example.com/recipes")!
        let sut = makeSUT(mockData: sampleRecipesJSON, expectedURL: expectedURL)

        // When
        let recipes = try await sut.fetchRecipes()

        // Then
        XCTAssertEqual(recipes.count, 2)
        let pizza = recipes[0]
        XCTAssertEqual(pizza.id, 1)
        XCTAssertEqual(pizza.name, "pizza")
        XCTAssertEqual(pizza.image, "https://example.com/pizza.jpg")
        XCTAssertEqual(pizza.description, "test description pizza")
        XCTAssertEqual(pizza.instructions, ["test display test pizza"])
        XCTAssertEqual(pizza.calories, "111 kcal")
        XCTAssertEqual(pizza.fat, "222 g")
        XCTAssertEqual(pizza.protein, "333 g")
        XCTAssertEqual(pizza.carbs, "555 g")

        let burger = recipes[1]
        XCTAssertEqual(burger.id, 2)
        XCTAssertEqual(burger.name, "burger")
        XCTAssertEqual(burger.image, "https://example.com/burger.jpg")
        XCTAssertEqual(burger.description, "test description burger")
        XCTAssertEqual(burger.instructions, ["test display test burger"])
        XCTAssertEqual(burger.calories, "777 kcal")
        XCTAssertEqual(burger.fat, "888 g")
        XCTAssertEqual(burger.protein, "999 g")
        XCTAssertEqual(burger.carbs, "122 g")
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
