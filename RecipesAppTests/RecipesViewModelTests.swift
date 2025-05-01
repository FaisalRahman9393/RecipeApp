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

    func testGivenServiceSucceeds_WhenFetchRecipesIsCalled_ThenSectionsArePopulatedCorrectly() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [
            makeRecipe(name: "pizza"),
            makeRecipe(name: "burger")
        ]
        let sut = RecipesViewModel(recipesService: mockService, persistenceService: MockPersistenceService())

        // When
        await sut.fetchRecipes()

        // Then
        let favourited = sut.recipeSections.first(where: { $0.type == .favourited})
        let others =  sut.recipeSections.first(where: { $0.type == .other})

        XCTAssertEqual(favourited?.recipes.count, 0)
        XCTAssertEqual(others?.recipes.count, 2)
    }

    func testGivenServiceFails_WhenFetchRecipesIsCalled_ThenSectionsAreEmptyAndLoadingIsFalse() async {
        // Given
        let mockService = MockRecipesService()
        mockService.shouldThrowError = true
        let sut = RecipesViewModel(recipesService: mockService, persistenceService: MockPersistenceService())

        // When
        await sut.fetchRecipes()

        // Then
        let favourited = sut.recipeSections.first(where: { $0.type == .favourited})
        let other = sut.recipeSections.first(where: { $0.type == .other})

        XCTAssert(favourited?.recipes.isEmpty == true)
        XCTAssert(other?.recipes.isEmpty == true)
        XCTAssertEqual(sut.networkFetchFailure, "Failed to fetch new recipes :(")
    }

    func testGivenInitialState_WhenFetchRecipesIsCalled_ThenIsLoadingTransitionsFromTrueToFalse() async {
        // Given
        let mockService = MockRecipesService()
        mockService.recipesToReturn = [makeRecipe(name: "pizza")]
        let sut = RecipesViewModel(recipesService: mockService, persistenceService: MockPersistenceService())

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

    func testWhenFavouriteIsCalled_ThenRecipeAppearsInFavouritesSection() {
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
        let favourited = sut.recipeSections.first(where: { $0.type == .favourited})
        XCTAssertTrue(mockPersistence.isFavourite(recipe))
        XCTAssertEqual(favourited?.recipes, [recipe])
    }

    func testGivenRecipeIsFavourited_WhenUnfavouriteIsCalled_ThenRecipeIsRemovedFromFavouritesSection() {
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
        let favourited = sut.recipeSections.first(where: { $0.type == .favourited})
        XCTAssertFalse(mockPersistence.isFavourite(recipe))
        XCTAssertTrue(favourited?.recipes.isEmpty ?? false)
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
