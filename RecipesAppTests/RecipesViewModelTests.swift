//
//  RecipesViewModelTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 29/04/2025.
//

import XCTest
import Combine
@testable import RecipesApp

@MainActor
final class RecipesViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
        super.tearDown()
    }

    func testGivenServiceIsSetToLoadWithSuccess_thenViewModelLoadsWithCorrectRecipes() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [
            Recipe(name: "Tomato sauce", image: ""),
            Recipe(name: "Mac and Cheese", image: "")
        ]
        let viewModel = RecipesViewModel(recipesService: mockService)
        
        // When
        await viewModel.fetchRecipes()
        
        // Then
        XCTAssertEqual(viewModel.recipes.count, 2)
        XCTAssertEqual(viewModel.recipes.first?.name, "Tomato sauce")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testGivenServiceFailsToLoad_thenViewModelReturnsEmptyRecipes() async {
        // Given
        let mockService = MockRecipesService()
        mockService.shouldThrowError = true
        let viewModel = RecipesViewModel(recipesService: mockService)

        // When
        await viewModel.fetchRecipes()

        // Then
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testGivenServiceLoadsSuccessfully_thenIsLoadingTogglesFromTrueToFalse() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [Recipe(name: "Tomato sauce", image: "")]
        let viewModel = RecipesViewModel(recipesService: mockService)
        
        var didObserveLoadingState: [Bool] = []
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
            didObserveLoadingState.append(isLoading)
        }.store(in: &cancellables)
        
        // When
        await viewModel.fetchRecipes()

        // Then
        XCTAssert(didObserveLoadingState == [true, false])
        
    }
}
