//
//  UserDefaultsPersistenceServiceTests.swift
//  RecipesAppTests
//
//  Created by Faisal Rahman on 30/04/2025.
//
import Foundation
@testable import RecipesApp
import XCTest

final class UserDefaultsPersistenceServiceTests: XCTestCase {

    private var sut: UserDefaultsPersistenceService!
    private var mockDefaults: UserDefaults!
    private let suiteName = "test.favourites"

    override func setUp() {
        super.setUp()
        mockDefaults = UserDefaults(suiteName: suiteName)
        mockDefaults.removePersistentDomain(forName: suiteName)
        sut = UserDefaultsPersistenceService(userDefaults: mockDefaults)
    }

    override func tearDown() {
        mockDefaults.removePersistentDomain(forName: suiteName)
        mockDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testGivenEmptyFavourites_WhenAddFavouriteIsCalled_ThenRecipeIsStored() {
        // Given
        let recipe = makeRecipe(name: "pizza")
        // When
        sut.addFavourite(recipe)
        // Then
        let result = sut.getFavourites()
        XCTAssertTrue(result.contains(where: { $0.name == "pizza" }))
    }

    func testGivenStoredFavourites_WhenRemoveFavouriteIsCalled_ThenRecipeIsRemoved() {
        // Given
        let recipe = makeRecipe(name: "pizza")
        sut.addFavourite(recipe)
        // When
        sut.removeFavourite(recipe)
        // Then
        let result = sut.getFavourites()
        XCTAssertFalse(result.contains(where: { $0.name == "pizza" }))
    }

    func testGivenStoredRecipe_WhenIsFavouriteIsCalled_ThenReturnsTrue() {
        // Given
        let recipe = makeRecipe(name: "pizza")
        sut.addFavourite(recipe)
        // When
        let isFav = sut.isFavourite(recipe)
        // Then
        XCTAssertTrue(isFav)
    }

    func testGivenNoStoredRecipe_WhenIsFavouriteIsCalled_ThenReturnsFalse() {
        // Given
        let recipe = makeRecipe(name: "burger")
        // When
        let isFav = sut.isFavourite(recipe)
        // Then
        XCTAssertFalse(isFav)
    }

    func testGivenMultipleRecipesStored_WhenGetFavouritesIsCalled_ThenReturnsAllRecipes() {
        // Given
        sut.addFavourite(makeRecipe(name: "pizza"))
        sut.addFavourite(makeRecipe(name: "burger"))
        // When
        let result = sut.getFavourites().map { $0.name }.sorted()
        // Then
        XCTAssertEqual(result, ["burger", "pizza"])
    }
}

func makeRecipe(id: Int = .random(in: 1...10000),
                name: String = "pizza",
                image: String? = "testImage",
                description: String? = "testDescription",
                instructions: [String] = ["testInstruction"],
                calories: Int? = 100,
                fat: Int? = 10,
                protein: Int? = 5,
                carbs: Int? = 20) -> Recipe {
    return Recipe(id: id, name: name, image: image, description: description, instructions: instructions, calories: calories, fat: fat, protein: protein, carbs: carbs)
}
