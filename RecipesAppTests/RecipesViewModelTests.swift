//
//  RecipesViewModelTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 30/04/2025.
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

    func testGivenServiceSucceeds_WhenFetchRecipesIsCalled_ThenRecipesArePopulatedCorrectly() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [
            makeRecipe(name: "pizza"),
            makeRecipe(name: "burger")
        ]
        let sut = RecipesViewModel(recipesService: mockService)
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(sut.recipes.count, 2)
        XCTAssertEqual(sut.recipes.first?.name, "pizza")
        XCTAssertFalse(sut.isLoading)
    }

    func testGivenServiceFails_WhenFetchRecipesIsCalled_ThenRecipesAreEmptyAndLoadingIsFalse() async {
        // Given
        let mockService = MockRecipesService()
        mockService.shouldThrowError = true
        let sut = RecipesViewModel(recipesService: mockService)

        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func testGivenInitialState_WhenFetchRecipesIsCalled_ThenIsLoadingTransitionsFromTrueToFalse() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [makeRecipe(name: "pizza")]
        let sut = RecipesViewModel(recipesService: mockService)
        
        var didObserveLoadingState: [Bool] = []
        
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                didObserveLoadingState.append(isLoading)
            }.store(in: &cancellables)
        
        // When
        await sut.fetchRecipes()

        // Then
        XCTAssertEqual(didObserveLoadingState, [true, false])
    }
}

// MARK: - Persistence Tests
extension RecipesViewModelTests {

    func testWhenFavouriteIsCalled_ThenRecipeIsAddedToFavourites() {
        // Given
        let mockPersistence = MockPersistenceService()
        let recipe = makeRecipe(name: "pizza")
        let sut = RecipesViewModel(
            recipesService: MockRecipesService(),
            persistenceService: mockPersistence
        )

        // When
        sut.favourite(recipe)

        // Then
        XCTAssertTrue(mockPersistence.isFavourite(recipe))
        XCTAssertEqual(sut.favouriteRecipes, [recipe])
    }

    func testGivenRecipeIsFavourited_WhenUnfavouriteIsCalled_ThenRecipeIsRemovedFromFavourites() {
        // Given
        let mockPersistence = MockPersistenceService()
        let recipe = makeRecipe(name: "pizza")
        mockPersistence.addFavourite(recipe)
        let sut = RecipesViewModel(
            recipesService: MockRecipesService(),
            persistenceService: mockPersistence
        )

        // When
        sut.unfavourite(recipe)

        // Then
        XCTAssertFalse(mockPersistence.isFavourite(recipe))
        XCTAssertTrue(sut.favouriteRecipes.isEmpty)
    }

    func testGivenARecipesIsFavourited_WhenIsFavouriteIsCalled_ThenCorrectBooleanIsReturned() {
        // Given
        let mockPersistence = MockPersistenceService()
        let favouritedRecipe = makeRecipe(name: "burger")
        mockPersistence.addFavourite(favouritedRecipe)
        let sut = RecipesViewModel(
            recipesService: MockRecipesService(),
            persistenceService: mockPersistence
        )

        // When / Then
        XCTAssertTrue(sut.isFavourite(favouritedRecipe))
    }
    
    func testGivenARecipesIsNOTFavourited_WhenIsFavouriteIsCalled_ThenCorrectBooleanIsReturned() {
        // Given
        let mockPersistence = MockPersistenceService()
        let sut = RecipesViewModel(
            recipesService: MockRecipesService(),
            persistenceService: mockPersistence
        )

        // When / Then
        XCTAssertFalse(sut.isFavourite(makeRecipe(name: "burger")))
        XCTAssertTrue(mockPersistence.storedFavourites.isEmpty)
    }
}
